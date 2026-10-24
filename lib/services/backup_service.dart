import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;

import '../models/app_settings.dart';
import '../models/custom_food.dart';
import '../models/meal.dart';
import '../models/packaged_food.dart';
import '../repositories/food_repository.dart';
import '../repositories/meal_repository.dart';
import 'app_database.dart';

/// Writes and restores JSON snapshots of the food catalogue, meals, and settings.
class BackupService {
  static const int backupVersion = 2;

  /// Matches automatic backup names, including the older format without a
  /// millisecond suffix.
  static final RegExp _automaticBackupName = RegExp(
    r'^foody_auto_backup_\d{8}_\d{6}(_\d{3})?\.json$',
  );

  final AppDatabase database;
  final FoodRepository foodRepository;
  final MealRepository mealRepository;

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
      final now = DateTime.now();
      final fileName = automatic
          ? 'foody_auto_backup_${DateFormat('yyyyMMdd_HHmmss_SSS').format(now)}.json'
          : 'foody_backup_${DateFormat('yyyyMMdd_HHmmss').format(now)}.json';
      final file = File(p.join(folderPath, fileName));
      await file.writeAsString(
        const JsonEncoder.withIndent('  ').convert(data),
        flush: true,
      );

      if (automatic) {
        try {
          await pruneAutomaticBackups(
            folderPath: folderPath,
            keep: settings.autoBackupLimit,
          );
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
  Future<void> createAutomaticBackup({
    required String folderPath,
    required AppSettings settings,
  }) async {
    if (_isBackingUp) return;

    try {
      await createBackup(
        folderPath: folderPath,
        settings: settings,
        automatic: true,
      );
    } catch (_) {
      // Automatic backups must never interrupt the user's action.
    }
  }

  /// Deletes older automatic backups so only the latest [keep] remain.
  ///
  /// Manual backups are never touched. Automatic backups are recognised by
  /// their file-name prefix, including files written by older releases.
  Future<void> pruneAutomaticBackups({
    required String folderPath,
    required int keep,
  }) async {
    final directory = Directory(folderPath);
    if (!await directory.exists()) return;

    final limit = AppSettings.clampAutoBackupLimit(keep);
    final files = <File>[];
    await for (final entity in directory.list()) {
      if (entity is File &&
          _automaticBackupName.hasMatch(p.basename(entity.path))) {
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
    if (version != backupVersion) {
      throw FormatException('Unsupported backup version: $version');
    }

    final settingsJson = decoded['settings'];
    final settings = settingsJson is Map<String, dynamic>
        ? AppSettings.fromJson(settingsJson)
        : const AppSettings();

    final packagedFoods = _listOfMaps(decoded['packagedFoods'])
        .map(_packagedFromJson)
        .toList();
    final customFoods = _listOfMaps(decoded['customFoods'])
        .map(_customFromJson)
        .toList();
    final meals = _listOfMaps(decoded['meals']).map(_mealFromJson).toList();

    await database.transaction(() async {
      await database.delete(database.packagedMeals).go();
      await database.delete(database.customMeals).go();
      await database.delete(database.packagedFoods).go();
      await database.delete(database.customFoods).go();

      for (final food in packagedFoods) {
        await _insertPackagedFood(food);
      }

      for (final food in customFoods) {
        await _insertCustomFood(food);
      }

      for (final meal in meals) {
        final resolved = _resolveMeal(meal, packagedFoods, customFoods);
        if (resolved != null) {
          await _insertMeal(resolved);
        }
      }

      await mealRepository.rebuildDailySummaries();
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
      'packagedFoods': foods
          .whereType<PackagedFood>()
          .map(_packagedToJson)
          .toList(),
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
    'basisAmount': food.basisAmount,
    'unitName': food.unitName,
    'lastUsedTime': food.lastUsedTime.toIso8601String(),
  };

  Map<String, dynamic> _mealToJson(Meal meal) => {
    'id': meal.id,
    'packagedFoodId': meal is PackagedMeal ? meal.food.id : null,
    'customFoodId': meal is CustomMeal ? meal.food.id : null,
    'quantity': meal is PackagedMeal ? meal.quantity : null,
    'netContent': meal is CustomMeal ? meal.netContent : null,
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
      basisAmount: _double(json['basisAmount'], 100),
      unitName: json['unitName'] as String? ?? 'g',
      lastUsedTime: _dateTime(json['lastUsedTime']),
    );
  }

  _BackupMeal _mealFromJson(Map<String, dynamic> json) {
    final rawPackagedId = json['packagedFoodId'];
    final rawCustomId = json['customFoodId'];
    return _BackupMeal(
      id: _int(json['id']),
      packagedFoodId: rawPackagedId is num ? rawPackagedId.toInt() : null,
      customFoodId: rawCustomId is num ? rawCustomId.toInt() : null,
      quantity: _double(json['quantity'], 1),
      netContent: _double(json['netContent']),
      createTime: _dateTime(json['createTime']),
      note: json['note'] as String?,
    );
  }

  Future<void> _insertPackagedFood(PackagedFood food) async {
    final id = await database
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
    if (food.id <= 0) food.id = id;
  }

  Future<void> _insertCustomFood(CustomFood food) async {
    final id = await database
        .into(database.customFoods)
        .insert(
          CustomFoodsCompanion(
            id: _idValue(food.id),
            name: Value(food.name),
            kj: Value(food.kj),
            carbs: Value(food.carbs),
            protein: Value(food.protein),
            fat: Value(food.fat),
            basisAmount: Value(food.basisAmount),
            unitName: Value(food.unitName),
            lastUsedTime: Value(food.lastUsedTime),
          ),
        );
    if (food.id <= 0) food.id = id;
  }

  Future<void> _insertMeal(Meal meal) async {
    switch (meal) {
      case PackagedMeal():
        await database
            .into(database.packagedMeals)
            .insert(
              PackagedMealsCompanion(
                id: _idValue(meal.id),
                packagedFoodId: Value(meal.food.id),
                quantity: Value(meal.quantity),
                createTime: Value(meal.createTime),
                note: Value(meal.note),
              ),
            );
      case CustomMeal():
        await database
            .into(database.customMeals)
            .insert(
              CustomMealsCompanion(
                id: _idValue(meal.id),
                customFoodId: Value(meal.food.id),
                netContent: Value(meal.netContent),
                createTime: Value(meal.createTime),
                note: Value(meal.note),
              ),
            );
    }
  }

  Meal? _resolveMeal(
    _BackupMeal backupMeal,
    List<PackagedFood> packagedFoods,
    List<CustomFood> customFoods,
  ) {
    final packaged = _findPackagedById(
      packagedFoods,
      backupMeal.packagedFoodId,
    );
    if (packaged != null) {
      return PackagedMeal(
        id: backupMeal.id,
        food: packaged,
        quantity: backupMeal.quantity,
        createTime: backupMeal.createTime,
        note: backupMeal.note,
      );
    }

    final custom = _findCustomById(customFoods, backupMeal.customFoodId);
    if (custom != null) {
      return CustomMeal(
        id: backupMeal.id,
        food: custom,
        netContent: backupMeal.netContent,
        createTime: backupMeal.createTime,
        note: backupMeal.note,
      );
    }

    return null;
  }

  PackagedFood? _findPackagedById(List<PackagedFood> foods, int? id) {
    if (id == null) return null;
    for (final food in foods) {
      if (food.id == id) return food;
    }
    return null;
  }

  CustomFood? _findCustomById(List<CustomFood> foods, int? id) {
    if (id == null) return null;
    for (final food in foods) {
      if (food.id == id) return food;
    }
    return null;
  }

  List<Map<String, dynamic>> _listOfMaps(dynamic value) {
    if (value is! List) return const [];
    return value
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
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

  DateTime _dateTime(dynamic value) =>
      DateTime.tryParse(value as String? ?? '') ?? DateTime.now();
}

class _BackupMeal {
  final int id;
  final int? packagedFoodId;
  final int? customFoodId;
  final double quantity;
  final double netContent;
  final DateTime createTime;
  final String? note;

  const _BackupMeal({
    required this.id,
    required this.packagedFoodId,
    required this.customFoodId,
    required this.quantity,
    required this.netContent,
    required this.createTime,
    required this.note,
  });
}
