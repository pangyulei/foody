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
import '../models/packaged_food.dart';
import '../repositories/food_repository.dart';
import '../repositories/meal_repository.dart';
import 'app_database.dart';

/// Writes and restores JSON snapshots of the food catalogue, meals, and settings.
class BackupService {
  static const int backupVersion = 1;

  /// Matches automatic backup names, including the older format without a
  /// millisecond suffix.
  static final RegExp _automaticBackupName = RegExp(r'^foody_auto_backup_\d{8}_\d{6}(_\d{3})?\.json$');

  final AppDatabase database;
  final FoodRepository foodRepository;
  final MealRepository mealRepository;

  bool _isBackingUp = false;

  BackupService({required this.database, required this.foodRepository, required this.mealRepository});

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
      final now = DateTime.now();
      final fileName = automatic
          ? 'foody_auto_backup_${DateFormat('yyyyMMdd_HHmmss_SSS').format(now)}.json'
          : 'foody_backup_${DateFormat('yyyyMMdd_HHmmss').format(now)}.json';
      final file = File(p.join(folderPath, fileName));
      await file.writeAsString(const JsonEncoder.withIndent('  ').convert(data), flush: true);

      if (automatic) {
        try {
          await pruneAutomaticBackups(folderPath: folderPath, keep: settings.autoBackupLimit);
        } catch (_) {
          // Retention cleanup must not fail the backup that was just written.
        }
      }

      return file.path;
    } finally {
      _isBackingUp = false;
    }
  }

  /// Writes a snapshot after a database change.
  ///
  /// Concurrent calls are skipped rather than queued; the next change writes a
  /// fresh snapshot anyway.
  Future<void> createAutomaticBackup({required String folderPath, required AppSettings settings}) async {
    if (_isBackingUp) return;

    try {
      await createBackup(folderPath: folderPath, settings: settings, automatic: true);
    } catch (_) {
      // Automatic backups must never interrupt the user's action.
    }
  }

  /// Deletes older automatic backups so only the latest [keep] remain.
  ///
  /// Manual backups are never touched. Automatic backups are recognised by
  /// their file-name prefix, including files written by older releases.
  Future<void> pruneAutomaticBackups({required String folderPath, required int keep}) async {
    final directory = Directory(folderPath);
    if (!await directory.exists()) return;

    final limit = AppSettings.clampAutoBackupLimit(keep);
    final files = <File>[];
    await for (final entity in directory.list()) {
      if (entity is File && _automaticBackupName.hasMatch(p.basename(entity.path))) {
        files.add(entity);
      }
    }

    // Timestamps in the file names sort chronologically as plain strings.
    files.sort((a, b) => p.basename(b.path).compareTo(p.basename(a.path)));

    for (final file in files.skip(limit)) {
      try {
        await file.delete();
      } catch (_) {
        // Best effort: a locked file is retried on the next automatic backup.
      }
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

    final rawVersion = decoded['version'];
    final version = rawVersion == null ? backupVersion : _int(rawVersion);
    // Backups are forward-compatible only: accept older formats, reject files
    // written by a newer app version that this code does not understand.
    if (version > backupVersion) {
      throw FormatException('Unsupported backup version: $version');
    }

    final settingsJson = decoded['settings'];
    final settings = settingsJson is Map<String, dynamic> ? AppSettings.fromJson(settingsJson) : const AppSettings();

    // Backups written before schema v6 used `premadeFoods`; keep reading that
    // key so old backups still restore.
    final packagedFoodsJson = decoded['packagedFoods'] ?? decoded['premadeFoods'];
    final packagedFoods = _listOfMaps(packagedFoodsJson).map(_packagedFromJson).toList();
    final customFoods = _listOfMaps(decoded['customFoods']).map(_customFromJson).toList();
    // v1/v2 called the meal list `dietLogs`.
    final mealsJson = decoded['meals'] ?? decoded['dietLogs'];
    final meals = _listOfMaps(mealsJson).map(_mealFromJson).toList();

    await database.transaction(() async {
      await database.delete(database.meals).go();
      await database.delete(database.packagedFoods).go();
      await database.delete(database.customFoods).go();

      for (final food in packagedFoods) {
        await database
            .into(database.packagedFoods)
            .insert(
              PackagedFoodsCompanion(
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
      'packagedFoods': foods.whereType<PackagedFood>().map(_packagedToJson).toList(),
      'customFoods': foods.whereType<CustomFood>().map(_customToJson).toList(),
      'meals': meals.map(_mealToJson).toList(),
    };
  }

  Map<String, dynamic> _packagedToJson(PackagedFood food) => {
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

  PackagedFood _packagedFromJson(Map<String, dynamic> json) {
    return PackagedFood(
      id: _int(json['id']),
      name: json['name'] as String? ?? '',
      kj: _double(json['kj']),
      carbs: _double(json['carbs']),
      protein: _double(json['protein']),
      fat: _double(json['fat']),
      netContent: _double(json['netContent'] ?? json['servingAmount'], 100),
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
      rawFoodSource: _foodSourceFromJson(json),
      netContent: _double(json['netContent'] ?? json['servingAmount'], 1),
      basisAmount: _double(json['basisAmount'], 1),
      unitName: json['unitName'] as String? ?? '份',
      quantity: _double(json['quantity'], 1),
      createTime: _dateTime(json['createTime']),
      note: json['note'] as String?,
    );
  }

  /// Reads the persisted food source, tolerating older backups that stored a
  /// text `inputMode` (`table`/`direct`) instead of the integer value.
  int _foodSourceFromJson(Map<String, dynamic> json) {
    final raw = json['rawFoodSource'];
    if (raw is num) return raw.toInt();
    if (raw is String) {
      final parsed = int.tryParse(raw);
      return parsed ?? _sourceValueFromText(raw);
    }

    final legacyMode = json['inputMode'];
    if (legacyMode is num) return legacyMode.toInt();
    if (legacyMode is String) return _sourceValueFromText(legacyMode);
    return FoodSource.custom.value;
  }

  int _sourceValueFromText(String value) => value == 'table' || value == 'premade' || value == 'packaged'
      ? FoodSource.packaged.value
      : FoodSource.custom.value;

  List<Map<String, dynamic>> _listOfMaps(dynamic value) {
    if (value is! List) return const [];
    return value.whereType<Map>().map((item) => Map<String, dynamic>.from(item)).toList();
  }

  Value<int> _idValue(int id) => id > 0 ? Value(id) : const Value.absent();

  int _int(dynamic value) {
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  double _double(dynamic value, [double fallback = 0]) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? fallback;
    return fallback;
  }

  DateTime _dateTime(dynamic value) => DateTime.tryParse(value as String? ?? '') ?? DateTime.now();
}
