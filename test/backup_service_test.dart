import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foody/models/app_settings.dart';
import 'package:foody/models/custom_food.dart';
import 'package:foody/models/meal.dart';
import 'package:foody/models/packaged_food.dart';
import 'package:foody/repositories/food_repository.dart';
import 'package:foody/repositories/meal_repository.dart';
import 'package:foody/services/app_database.dart';
import 'package:foody/services/backup_service.dart';
import 'package:path/path.dart' as p;

void main() {
  test('backup round-trips foods, both meal types, and settings', () async {
    final tempDir = await Directory.systemTemp.createTemp('foody_backup_test');
    final sourceDb = AppDatabase(NativeDatabase.memory());
    final sourceFoods = FoodRepository(sourceDb);
    final sourceMeals = MealRepository(sourceDb);
    final sourceService = BackupService(
      database: sourceDb,
      foodRepository: sourceFoods,
      mealRepository: sourceMeals,
    );

    addTearDown(() async {
      await sourceMeals.dispose();
      await sourceFoods.dispose();
      await sourceDb.close();
      await tempDir.delete(recursive: true);
    });

    final packaged = PackagedFood(
      name: '牛奶',
      kj: 251,
      carbs: 10,
      protein: 6,
      fat: 8,
      netContent: 250,
      basisAmount: 100,
      unitName: 'ml',
      lastUsedTime: DateTime(2026, 10, 19, 9),
    );
    final custom = CustomFood(
      name: '鸡蛋',
      kj: 300,
      carbs: 1,
      protein: 6,
      fat: 5,
      basisAmount: 100,
      unitName: 'g',
      lastUsedTime: DateTime(2026, 10, 19, 10),
    );
    await sourceFoods.saveFood(packaged);
    await sourceFoods.saveFood(custom);
    await sourceMeals.saveMeal(
      Meal.fromFood(
        food: packaged,
        quantity: 2,
        createTime: DateTime(2026, 10, 19, 8),
        note: 'Breakfast',
      ),
    );
    await sourceMeals.saveMeal(
      Meal.fromFood(
        food: custom,
        netContent: 150,
        createTime: DateTime(2026, 10, 19, 12),
        note: 'Lunch',
      ),
    );

    const settings = AppSettings(weightKg: 70, backupFolder: 'ignored');
    final backupPath = await sourceService.createBackup(
      folderPath: tempDir.path,
      settings: settings,
    );
    expect(File(backupPath).existsSync(), isTrue);

    // Simulate a restore over existing data.
    await sourceDb.delete(sourceDb.packagedMeals).go();
    await sourceDb.delete(sourceDb.customMeals).go();
    await sourceDb.delete(sourceDb.packagedFoods).go();
    await sourceDb.delete(sourceDb.customFoods).go();
    expect(await sourceFoods.getAllFoods(), isEmpty);

    final restoredSettings = await sourceService.restoreBackup(backupPath);
    expect(restoredSettings.weightKg, 70);
    expect(restoredSettings.backupFolder, 'ignored');

    final foods = await sourceFoods.getAllFoods();
    expect(foods, hasLength(2));
    final importedPackaged = foods.whereType<PackagedFood>().single;
    expect(importedPackaged.id, packaged.id);
    expect(importedPackaged.name, '牛奶');
    expect(importedPackaged.netContent, 250);
    final importedCustom = foods.whereType<CustomFood>().single;
    expect(importedCustom.id, custom.id);
    expect(importedCustom.name, '鸡蛋');
    expect(importedCustom.basisAmount, 100);
    expect(importedCustom.unitName, 'g');

    final meals = await sourceMeals.getAllMeals();
    expect(meals, hasLength(2));

    final packagedMeal = meals.whereType<PackagedMeal>().single;
    expect(packagedMeal.foodName, '牛奶');
    expect(packagedMeal.quantity, 2);
    expect(packagedMeal.note, 'Breakfast');
    expect(packagedMeal.totalKj, 502);

    final customMeal = meals.whereType<CustomMeal>().single;
    expect(customMeal.foodName, '鸡蛋');
    expect(customMeal.netContent, 150);
    expect(customMeal.note, 'Lunch');
    expect(customMeal.totalKj, 450);

    final summaries = await sourceMeals.getDailySummaries();
    expect(summaries, hasLength(1));
    expect(summaries.single.day, DateTime(2026, 10, 19));
    expect(summaries.single.mealCount, 2);
    expect(summaries.single.totalKj, 952);
  });

  test('rejects backups from an unsupported version', () async {
    final tempDir = await Directory.systemTemp.createTemp('foody_backup_old');
    final database = AppDatabase(NativeDatabase.memory());
    final foods = FoodRepository(database);
    final meals = MealRepository(database);
    final service = BackupService(
      database: database,
      foodRepository: foods,
      mealRepository: meals,
    );

    addTearDown(() async {
      await meals.dispose();
      await foods.dispose();
      await database.close();
      await tempDir.delete(recursive: true);
    });

    final backupFile = File(p.join(tempDir.path, 'foody_backup_v1.json'));
    await backupFile.writeAsString(
      jsonEncode({
        'version': 1,
        'settings': {'languageCode': 'en'},
        'packagedFoods': const [],
        'customFoods': const [],
        'meals': const [],
      }),
    );

    await expectLater(
      service.restoreBackup(backupFile.path),
      throwsA(isA<FormatException>()),
    );
  });

  test('automatic backups use a timestamped file name', () async {
    final tempDir = await Directory.systemTemp.createTemp('foody_auto_backup');
    final database = AppDatabase(NativeDatabase.memory());
    final foods = FoodRepository(database);
    final meals = MealRepository(database);
    final service = BackupService(
      database: database,
      foodRepository: foods,
      mealRepository: meals,
    );

    addTearDown(() async {
      await meals.dispose();
      await foods.dispose();
      await database.close();
      await tempDir.delete(recursive: true);
    });

    final firstPath = await service.createBackup(
      folderPath: tempDir.path,
      settings: const AppSettings(),
      automatic: true,
    );
    // File names have millisecond resolution; keep a small gap so the two
    // snapshots cannot collide.
    await Future<void>.delayed(const Duration(milliseconds: 20));
    final secondPath = await service.createBackup(
      folderPath: tempDir.path,
      settings: const AppSettings(),
      automatic: true,
    );

    final timestampPattern = RegExp(
      r'foody_auto_backup_\d{8}_\d{6}_\d{3}\.json$',
    );
    expect(timestampPattern.hasMatch(firstPath), isTrue, reason: firstPath);
    expect(timestampPattern.hasMatch(secondPath), isTrue, reason: secondPath);
    expect(firstPath, isNot(secondPath));
    expect(File(firstPath).existsSync(), isTrue);
    expect(File(secondPath).existsSync(), isTrue);
    expect(
      tempDir.listSync().whereType<File>(),
      hasLength(2),
      reason: 'automatic backups must not overwrite each other',
    );
  });

  test('retention keeps only the newest automatic backups', () async {
    final tempDir = await Directory.systemTemp.createTemp('foody_retention');
    final database = AppDatabase(NativeDatabase.memory());
    final foods = FoodRepository(database);
    final meals = MealRepository(database);
    final service = BackupService(
      database: database,
      foodRepository: foods,
      mealRepository: meals,
    );

    addTearDown(() async {
      await meals.dispose();
      await foods.dispose();
      await database.close();
      await tempDir.delete(recursive: true);
    });

    for (final name in const [
      'foody_auto_backup_20260101_000001.json',
      'foody_auto_backup_20260101_000002.json',
      'foody_auto_backup_20260101_000003_123.json',
      'foody_auto_backup_20260101_000004.json',
    ]) {
      await File(p.join(tempDir.path, name)).writeAsString('{}');
    }
    await File(p.join(tempDir.path, 'foody_backup_20260101_000005.json'))
        .writeAsString('{}');

    await service.pruneAutomaticBackups(folderPath: tempDir.path, keep: 2);

    final remaining = tempDir
        .listSync()
        .whereType<File>()
        .map((file) => p.basename(file.path))
        .toList();
    expect(remaining, hasLength(3));
    expect(remaining, contains('foody_auto_backup_20260101_000004.json'));
    expect(remaining, contains('foody_auto_backup_20260101_000003_123.json'));
    expect(remaining, contains('foody_backup_20260101_000005.json'));
  });

  test('automatic backups apply retention but manual backups do not', () async {
    final tempDir = await Directory.systemTemp.createTemp(
      'foody_retention_run',
    );
    final database = AppDatabase(NativeDatabase.memory());
    final foods = FoodRepository(database);
    final meals = MealRepository(database);
    final service = BackupService(
      database: database,
      foodRepository: foods,
      mealRepository: meals,
    );

    addTearDown(() async {
      await meals.dispose();
      await foods.dispose();
      await database.close();
      await tempDir.delete(recursive: true);
    });

    for (var i = 1; i <= 4; i++) {
      await File(
        p.join(tempDir.path, 'foody_auto_backup_20000101_00000$i.json'),
      ).writeAsString('{}');
    }

    const settings = AppSettings(autoBackupLimit: 2);

    // Manual backups never prune automatic ones.
    await service.createBackup(folderPath: tempDir.path, settings: settings);
    expect(_automaticBackupNames(tempDir), hasLength(4));

    await service.createBackup(
      folderPath: tempDir.path,
      settings: settings,
      automatic: true,
    );

    final remaining = _automaticBackupNames(tempDir);
    expect(remaining, hasLength(2));
    expect(remaining, contains('foody_auto_backup_20000101_000004.json'));
  });
}

List<String> _automaticBackupNames(Directory directory) => directory
    .listSync()
    .whereType<File>()
    .map((file) => p.basename(file.path))
    .where((name) => name.startsWith('foody_auto_backup_'))
    .toList();
