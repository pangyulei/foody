import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foody/models/app_settings.dart';
import 'package:foody/models/custom_food.dart';
import 'package:foody/models/food_source.dart';
import 'package:foody/models/meal.dart';
import 'package:foody/models/packaged_food.dart';
import 'package:foody/repositories/food_repository.dart';
import 'package:foody/repositories/meal_repository.dart';
import 'package:foody/services/app_database.dart';
import 'package:foody/services/backup_service.dart';
import 'package:path/path.dart' as p;

void main() {
  test('backup round-trips foods, meals, and settings', () async {
    final tempDir = await Directory.systemTemp.createTemp('foody_backup_test');
    final sourceDb = AppDatabase(NativeDatabase.memory());
    final sourceFoods = FoodRepository(sourceDb);
    final sourceMeals = MealRepository(sourceDb);
    final sourceService = BackupService(database: sourceDb, foodRepository: sourceFoods, mealRepository: sourceMeals);

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
      lastUsedTime: DateTime(2026, 10, 19, 10),
    );
    await sourceFoods.saveFood(packaged);
    await sourceFoods.saveFood(custom);
    await sourceMeals.saveMeal(
      Meal.fromFood(food: packaged, quantity: 2, createTime: DateTime(2026, 10, 19, 8), note: 'Breakfast'),
    );

    const settings = AppSettings(weightKg: 70, backupFolder: 'ignored');
    final backupPath = await sourceService.createBackup(folderPath: tempDir.path, settings: settings);
    expect(File(backupPath).existsSync(), isTrue);

    // Simulate a restore over existing data.
    await sourceDb.delete(sourceDb.meals).go();
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

    final meals = await sourceMeals.getAllMeals();
    expect(meals, hasLength(1));
    expect(meals.single.foodName, '牛奶');
    expect(meals.single.quantity, 2);
    expect(meals.single.note, 'Breakfast');
  });

  test('restores a pre-v6 backup that uses the premadeFoods key', () async {
    final tempDir = await Directory.systemTemp.createTemp('foody_backup_v5');
    final database = AppDatabase(NativeDatabase.memory());
    final foods = FoodRepository(database);
    final meals = MealRepository(database);
    final service = BackupService(database: database, foodRepository: foods, mealRepository: meals);

    addTearDown(() async {
      await meals.dispose();
      await foods.dispose();
      await database.close();
      await tempDir.delete(recursive: true);
    });

    final backupFile = File(p.join(tempDir.path, 'foody_backup_v5.json'));
    await backupFile.writeAsString(
      jsonEncode({
        'version': 1,
        'createdAt': '2026-10-19T08:00:00.000',
        'settings': {'languageCode': 'en', 'weightKg': 70},
        'premadeFoods': [
          {
            'id': 7,
            'name': '牛奶',
            'kj': 251.0,
            'carbs': 10.0,
            'protein': 6.0,
            'fat': 8.0,
            'netContent': 250.0,
            'basisAmount': 100.0,
            'unitName': 'ml',
            'lastUsedTime': '2026-10-19T09:00:00.000',
          },
        ],
        'customFoods': [
          {
            'id': 9,
            'name': '鸡蛋',
            'kj': 300.0,
            'carbs': 1.0,
            'protein': 6.0,
            'fat': 5.0,
            'lastUsedTime': '2026-10-19T10:00:00.000',
          },
        ],
        'meals': [
          {
            'id': 3,
            'foodName': '牛奶',
            'kj': 251.0,
            'carbs': 10.0,
            'protein': 6.0,
            'fat': 8.0,
            'rawFoodSource': 0,
            'netContent': 250.0,
            'basisAmount': 100.0,
            'unitName': 'ml',
            'quantity': 2.0,
            'createTime': '2026-10-19T08:30:00.000',
            'note': 'Breakfast',
          },
        ],
      }),
    );

    final restoredSettings = await service.restoreBackup(backupFile.path);
    expect(restoredSettings.languageCode, 'en');

    final loadedFoods = await foods.getAllFoods();
    expect(loadedFoods, hasLength(2));
    final packaged = loadedFoods.whereType<PackagedFood>().single;
    expect(packaged.id, 7);
    expect(packaged.name, '牛奶');
    expect(packaged.netContent, 250);
    expect(loadedFoods.whereType<CustomFood>().single.name, '鸡蛋');

    final loadedMeals = await meals.getMealsForDate(DateTime(2026, 10, 19));
    expect(loadedMeals, hasLength(1));
    expect(loadedMeals.single.id, 3);
    expect(loadedMeals.single.foodName, '牛奶');
    expect(loadedMeals.single.foodSource, FoodSource.packaged);
    expect(loadedMeals.single.quantity, 2);
    expect(loadedMeals.single.note, 'Breakfast');
  });

  test('restores legacy backup fields from older schemas', () async {
    final tempDir = await Directory.systemTemp.createTemp('foody_backup_legacy');
    final database = AppDatabase(NativeDatabase.memory());
    final foods = FoodRepository(database);
    final meals = MealRepository(database);
    final service = BackupService(database: database, foodRepository: foods, mealRepository: meals);

    addTearDown(() async {
      await meals.dispose();
      await foods.dispose();
      await database.close();
      await tempDir.delete(recursive: true);
    });

    final backupFile = File(p.join(tempDir.path, 'foody_backup_legacy.json'));
    await backupFile.writeAsString(
      jsonEncode({
        'version': 0,
        'settings': {'languageCode': 'zh'},
        'premadeFoods': [
          {
            'id': 11,
            'name': '面包',
            'kj': 1000,
            'carbs': 40,
            'protein': 8,
            'fat': 3,
            // v1-v3 called the net content `servingAmount`.
            'servingAmount': 300,
            'basisAmount': 100,
            'unitName': 'g',
            'lastUsedTime': '2026-10-19T09:00:00.000',
          },
        ],
        'customFoods': const [],
        // v1/v2 used the `dietLogs` key and a text `inputMode`.
        'dietLogs': [
          {
            'id': 5,
            'foodName': '面包',
            'kj': 1000,
            'carbs': 40,
            'protein': 8,
            'fat': 3,
            'inputMode': 'table',
            'servingAmount': 300,
            'basisAmount': 100,
            'unitName': 'g',
            'quantity': 1.5,
            'createTime': '2026-10-19T08:30:00.000',
          },
        ],
      }),
    );

    await service.restoreBackup(backupFile.path);

    final packaged = (await foods.getAllFoods()).whereType<PackagedFood>().single;
    expect(packaged.id, 11);
    expect(packaged.name, '面包');
    expect(packaged.netContent, 300);

    final loadedMeals = await meals.getMealsForDate(DateTime(2026, 10, 19));
    expect(loadedMeals, hasLength(1));
    expect(loadedMeals.single.id, 5);
    expect(loadedMeals.single.foodSource, FoodSource.packaged);
    expect(loadedMeals.single.netContent, 300);
    expect(loadedMeals.single.quantity, 1.5);
  });

  test('automatic backups use a timestamped file name', () async {
    final tempDir = await Directory.systemTemp.createTemp('foody_auto_backup');
    final database = AppDatabase(NativeDatabase.memory());
    final foods = FoodRepository(database);
    final meals = MealRepository(database);
    final service = BackupService(database: database, foodRepository: foods, mealRepository: meals);

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

    final timestampPattern = RegExp(r'foody_auto_backup_\d{8}_\d{6}_\d{3}\.json$');
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
}
