import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;

import '../models/app_settings.dart';
import '../models/custom_food.dart';
import '../models/food_source.dart';
import '../models/meal.dart';
import '../models/premade_food.dart';
import '../repositories/food_repository.dart';
import '../repositories/meal_repository.dart';
import 'app_database.dart';

/// Writes and restores JSON snapshots of the food catalogue, meals, and settings.
class BackupService {
  static const int backupVersion = 1;

  final AppDatabase database;
  final FoodRepository foodRepository;
  final MealRepository mealRepository;

  DateTime? _lastAutomaticBackup;
  bool _isBackingUp = false;

  BackupService({
    required this.database,
    required this.foodRepository,
    required this.mealRepository,
  });

  /// Creates a backup file in [folderPath].
  ///
  /// Both manual and automatic backups include a timestamp in the file name so
  /// earlier snapshots are never overwritten. Automatic backups use a distinct
  /// prefix so they can be told apart from manual ones.
  Future<String> createBackup({
    required String folderPath,
    required AppSettings settings,
    bool automatic = false,
  }) async {
    if (_isBackingUp) {
      throw StateError('A backup is already in progress');
    }

    _isBackingUp = true;
    try {
      final directory = Directory(folderPath);
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      final data = await _collectData(settings);
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final fileName = automatic
          ? 'foody_auto_backup_$timestamp.json'
          : 'foody_backup_$timestamp.json';
      final file = File(p.join(folderPath, fileName));
      await file.writeAsString(
        const JsonEncoder.withIndent('  ').convert(data),
        flush: true,
      );
      return file.path;
    } finally {
      _isBackingUp = false;
    }
  }

  /// Background backups are lightly throttled so duplicate lifecycle events
  /// cannot write the same snapshot twice in a row.
  Future<void> createAutomaticBackup({
    required String folderPath,
    required AppSettings settings,
  }) async {
    final now = DateTime.now();
    if (_lastAutomaticBackup != null &&
        now.difference(_lastAutomaticBackup!) < const Duration(seconds: 5)) {
      return;
    }
    if (_isBackingUp) return;

    try {
      await createBackup(
        folderPath: folderPath,
        settings: settings,
        automatic: true,
      );
      _lastAutomaticBackup = now;
    } catch (_) {
      // Automatic backups must never interrupt backgrounding.
    }
  }

  /// Replaces all foods and meals with the contents of [filePath].
  ///
  /// Returns the settings stored in the backup. The caller decides whether to
  /// keep the current backup folder.
  Future<AppSettings> restoreBackup(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) {
      throw FileSystemException('Backup file not found', filePath);
    }

    final decoded = jsonDecode(await file.readAsString());
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Invalid backup file');
    }

    final version = (decoded['version'] as num?)?.toInt() ?? backupVersion;
    if (version != backupVersion) {
      throw FormatException('Unsupported backup version: $version');
    }

    final settingsJson = decoded['settings'];
    final settings = settingsJson is Map<String, dynamic>
        ? AppSettings.fromJson(settingsJson)
        : const AppSettings();

    final premadeFoods = _listOfMaps(decoded['premadeFoods'])
        .map(_premadeFromJson)
        .toList();
    final customFoods = _listOfMaps(decoded['customFoods'])
        .map(_customFromJson)
        .toList();
    final meals = _listOfMaps(decoded['meals']).map(_mealFromJson).toList();

    await database.transaction(() async {
      await database.delete(database.meals).go();
      await database.delete(database.premadeFoods).go();
      await database.delete(database.customFoods).go();

      for (final food in premadeFoods) {
        await database
            .into(database.premadeFoods)
            .insert(
              PremadeFoodsCompanion(
                id: _idValue(food.id),
                name: Value(food.name),
                kj: Value(food.kj),
                carbs: Value(food.carbs),
                protein: Value(food.protein),
                fat: Value(food.fat),
                netContent: Value(food.netContent),
                basisAmount: Value(food.basisAmount),
                unitName: Value(food.unitName),
                lastUsedTime: Value(food.lastUsedTime),
              ),
            );
      }

      for (final food in customFoods) {
        await database
            .into(database.customFoods)
            .insert(
              CustomFoodsCompanion(
                id: _idValue(food.id),
                name: Value(food.name),
                kj: Value(food.kj),
                carbs: Value(food.carbs),
                protein: Value(food.protein),
                fat: Value(food.fat),
                lastUsedTime: Value(food.lastUsedTime),
              ),
            );
      }

      for (final meal in meals) {
        await database
            .into(database.meals)
            .insert(
              MealsCompanion(
                id: _idValue(meal.id),
                foodName: Value(meal.foodName),
                kj: Value(meal.kj),
                carbs: Value(meal.carbs),
                protein: Value(meal.protein),
                fat: Value(meal.fat),
                rawFoodSource: Value(meal.rawFoodSource),
                netContent: Value(meal.netContent),
                basisAmount: Value(meal.basisAmount),
                unitName: Value(meal.unitName),
                quantity: Value(meal.quantity),
                createTime: Value(meal.createTime),
                note: Value(meal.note),
              ),
            );
      }
    });

    foodRepository.notifyChanged();
    mealRepository.notifyChanged();
    return settings;
  }

  Future<Map<String, dynamic>> _collectData(AppSettings settings) async {
    final foods = await foodRepository.getAllFoods();
    final meals = await mealRepository.getAllMeals();

    return {
      'version': backupVersion,
      'createdAt': DateTime.now().toIso8601String(),
      'settings': settings.toJson(),
      'premadeFoods': foods
          .whereType<PremadeFood>()
          .map(_premadeToJson)
          .toList(),
      'customFoods': foods.whereType<CustomFood>().map(_customToJson).toList(),
      'meals': meals.map(_mealToJson).toList(),
    };
  }

  Map<String, dynamic> _premadeToJson(PremadeFood food) => {
    'id': food.id,
    'name': food.name,
    'kj': food.kj,
    'carbs': food.carbs,
    'protein': food.protein,
    'fat': food.fat,
    'netContent': food.netContent,
    'basisAmount': food.basisAmount,
    'unitName': food.unitName,
    'lastUsedTime': food.lastUsedTime.toIso8601String(),
  };

  Map<String, dynamic> _customToJson(CustomFood food) => {
    'id': food.id,
    'name': food.name,
    'kj': food.kj,
    'carbs': food.carbs,
    'protein': food.protein,
    'fat': food.fat,
    'lastUsedTime': food.lastUsedTime.toIso8601String(),
  };

  Map<String, dynamic> _mealToJson(Meal meal) => {
    'id': meal.id,
    'foodName': meal.foodName,
    'kj': meal.kj,
    'carbs': meal.carbs,
    'protein': meal.protein,
    'fat': meal.fat,
    'rawFoodSource': meal.rawFoodSource,
    'netContent': meal.netContent,
    'basisAmount': meal.basisAmount,
    'unitName': meal.unitName,
    'quantity': meal.quantity,
    'createTime': meal.createTime.toIso8601String(),
    'note': meal.note,
  };

  PremadeFood _premadeFromJson(Map<String, dynamic> json) {
    return PremadeFood(
      id: _int(json['id']),
      name: json['name'] as String? ?? '',
      kj: _double(json['kj']),
      carbs: _double(json['carbs']),
      protein: _double(json['protein']),
      fat: _double(json['fat']),
      netContent: _double(json['netContent'], 100),
      basisAmount: _double(json['basisAmount'], 100),
      unitName: json['unitName'] as String? ?? 'ml',
      lastUsedTime: _dateTime(json['lastUsedTime']),
    );
  }

  CustomFood _customFromJson(Map<String, dynamic> json) {
    return CustomFood(
      id: _int(json['id']),
      name: json['name'] as String? ?? '',
      kj: _double(json['kj']),
      carbs: _double(json['carbs']),
      protein: _double(json['protein']),
      fat: _double(json['fat']),
      lastUsedTime: _dateTime(json['lastUsedTime']),
    );
  }

  Meal _mealFromJson(Map<String, dynamic> json) {
    return Meal(
      id: _int(json['id']),
      foodName: json['foodName'] as String? ?? '',
      kj: _double(json['kj']),
      carbs: _double(json['carbs']),
      protein: _double(json['protein']),
      fat: _double(json['fat']),
      rawFoodSource:
          (json['rawFoodSource'] as num?)?.toInt() ?? FoodSource.custom.value,
      netContent: _double(json['netContent'], 1),
      basisAmount: _double(json['basisAmount'], 1),
      unitName: json['unitName'] as String? ?? '份',
      quantity: _double(json['quantity'], 1),
      createTime: _dateTime(json['createTime']),
      note: json['note'] as String?,
    );
  }

  List<Map<String, dynamic>> _listOfMaps(dynamic value) {
    if (value is! List) return const [];
    return value
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  Value<int> _idValue(int id) => id > 0 ? Value(id) : const Value.absent();

  int _int(dynamic value) => (value as num?)?.toInt() ?? 0;

  double _double(dynamic value, [double fallback = 0]) =>
      (value as num?)?.toDouble() ?? fallback;

  DateTime _dateTime(dynamic value) =>
      DateTime.tryParse(value as String? ?? '') ?? DateTime.now();
}
