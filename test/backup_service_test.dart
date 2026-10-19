import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foody/models/app_settings.dart';
import 'package:foody/models/custom_food.dart';
import 'package:foody/models/meal.dart';
import 'package:foody/models/premade_food.dart';
import 'package:foody/repositories/food_repository.dart';
import 'package:foody/repositories/meal_repository.dart';
import 'package:foody/services/app_database.dart';
import 'package:foody/services/backup_service.dart';

void main() {
  test('backup round-trips foods, meals, and settings', () async {
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

    final premade = PremadeFood(
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
    await sourceFoods.saveFood(premade);
    await sourceFoods.saveFood(custom);
    await sourceMeals.saveMeal(
      Meal.fromFood(
        food: premade,
        quantity: 2,
        createTime: DateTime(2026, 10, 19, 8),
        note: 'Breakfast',
      ),
    );

    const settings = AppSettings(weightKg: 70, backupFolder: 'ignored');
    final backupPath = await sourceService.createBackup(
      folderPath: tempDir.path,
      settings: settings,
    );
    expect(File(backupPath).existsSync(), isTrue);

    // Simulate a restore over existing data.
    await sourceDb.delete(sourceDb.meals).go();
    await sourceDb.delete(sourceDb.premadeFoods).go();
    await sourceDb.delete(sourceDb.customFoods).go();
    expect(await sourceFoods.getAllFoods(), isEmpty);

    final restoredSettings = await sourceService.restoreBackup(backupPath);
    expect(restoredSettings.weightKg, 70);
    expect(restoredSettings.backupFolder, 'ignored');

    final foods = await sourceFoods.getAllFoods();
    expect(foods, hasLength(2));
    final importedPremade = foods.whereType<PremadeFood>().single;
    expect(importedPremade.id, premade.id);
    expect(importedPremade.name, '牛奶');
    expect(importedPremade.netContent, 250);
    final importedCustom = foods.whereType<CustomFood>().single;
    expect(importedCustom.id, custom.id);
    expect(importedCustom.name, '鸡蛋');

    final meals = await sourceMeals.getAllMeals();
    expect(meals, hasLength(1));
    expect(meals.single.foodName, '牛奶');
    expect(meals.single.quantity, 2);
    expect(meals.single.note, 'Breakfast');
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
    // File names have second resolution, so move past the current second.
    await Future<void>.delayed(const Duration(milliseconds: 1100));
    final secondPath = await service.createBackup(
      folderPath: tempDir.path,
      settings: const AppSettings(),
      automatic: true,
    );

    final timestampPattern = RegExp(r'foody_auto_backup_\d{8}_\d{6}\.json$');
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
