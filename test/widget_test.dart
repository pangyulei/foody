import 'package:flutter_test/flutter_test.dart';
import 'package:foody/extensions/meal_extensions.dart';
import 'package:foody/models/app_settings.dart';
import 'package:foody/models/custom_food.dart';
import 'package:foody/models/food.dart';
import 'package:foody/models/meal.dart';
import 'package:foody/models/packaged_food.dart';
import 'package:foody/utils/energy_converter.dart';

void main() {
  group('EnergyConverter Tests', () {
    test('kJ to kcal conversion formula', () {
      // 1 kcal = 4.184 kJ
      expect(EnergyConverter.kjToKcal(418.4), closeTo(100.0, 0.001));
      expect(EnergyConverter.kcalToKj(100.0), closeTo(418.4, 0.001));
    });

    test('Food calories getter', () {
      final food = CustomFood(
        name: '牛奶',
        kj: 502.08, // 502.08 kJ = 120 kcal
        carbs: 10.0,
        protein: 6.0,
        fat: 8.0,
      );

      expect(food.calories, closeTo(120.0, 0.01));
    });

    test('Nutrition Table multiplier calculation', () {
      // 一瓶牛奶 200ml, 每100ml含 10g 碳水, 6g 蛋白质, 8g 脂肪, 251kJ 能量
      const totalAmount = 200.0;
      const unitAmount = 100.0;
      const multiplier = totalAmount / unitAmount; // 2.0

      const unitCarbs = 10.0;
      const unitProtein = 6.0;
      const unitFat = 8.0;
      const unitKj = 251.0;

      final totalKj = unitKj * multiplier; // 502.0 kJ
      final totalCarbs = unitCarbs * multiplier; // 20.0 g
      final totalProtein = unitProtein * multiplier; // 12.0 g
      final totalFat = unitFat * multiplier; // 16.0 g

      final totalKcal = EnergyConverter.kjToKcal(totalKj);

      expect(multiplier, equals(2.0));
      expect(totalKj, equals(502.0));
      expect(totalCarbs, equals(20.0));
      expect(totalProtein, equals(12.0));
      expect(totalFat, equals(16.0));
      expect(totalKcal, closeTo(119.98, 0.1));
    });
  });

  group('AppSettings goals', () {
    test('targets are body weight multiplied by factor', () {
      const settings = AppSettings(
        weightKg: 70,
        carbsFactor: 3,
        proteinFactor: 1.5,
        fatFactor: 1,
      );

      expect(settings.hasGoals, isTrue);
      expect(settings.targetCarbs, 210);
      expect(settings.targetProtein, 105);
      expect(settings.targetFat, 70);
      expect(settings.targetKcal, 1890);
    });

    test('goals are inactive without body weight', () {
      const settings = AppSettings(weightKg: 0);
      expect(settings.hasGoals, isFalse);
    });

    test('goals require weight and all macro factors', () {
      expect(const AppSettings(weightKg: 70).hasCompleteGoalData, isTrue);
      expect(const AppSettings(weightKg: 0).hasCompleteGoalData, isFalse);
      expect(
        const AppSettings(weightKg: 70, carbsFactor: 0).hasCompleteGoalData,
        isFalse,
      );
      expect(
        const AppSettings(weightKg: 70, proteinFactor: 0).hasCompleteGoalData,
        isFalse,
      );
      expect(
        const AppSettings(weightKg: 70, fatFactor: 0).hasCompleteGoalData,
        isFalse,
      );
    });

    test('old settings JSON with goalsEnabled still loads other values', () {
      final settings = AppSettings.fromJson({
        'languageCode': 'en',
        'themeColorValue': 0xFF2196F3,
        'goalsEnabled': true,
        'weightKg': 70,
        'carbsFactor': 3,
        'proteinFactor': 1.5,
        'fatFactor': 1,
      });

      expect(settings.languageCode, 'en');
      expect(settings.themeColorValue, 0xFF2196F3);
      expect(settings.weightKg, 70);
      expect(settings.hasCompleteGoalData, isTrue);
      expect(settings.backupFolder, isNull);
    });

    test('backup folder round-trips through settings JSON', () {
      const settings = AppSettings(backupFolder: r'C:\backups');
      final restored = AppSettings.fromJson(settings.toJson());
      expect(restored.backupFolder, r'C:\backups');
    });

    test('old settings JSON defaults the auto-backup limit to 3', () {
      final settings = AppSettings.fromJson({
        'languageCode': 'en',
        'weightKg': 70,
      });

      expect(settings.autoBackupLimit, 3);
      expect(settings.languageCode, 'en');
      expect(settings.weightKg, 70);
    });

    test('auto-backup limit round-trips and is clamped to 1-10', () {
      const settings = AppSettings(autoBackupLimit: 7);
      expect(AppSettings.fromJson(settings.toJson()).autoBackupLimit, 7);
      expect(AppSettings.fromJson({'autoBackupLimit': 0}).autoBackupLimit, 1);
      expect(AppSettings.fromJson({'autoBackupLimit': 11}).autoBackupLimit, 10);
      expect(AppSettings.fromJson({'autoBackupLimit': '5'}).autoBackupLimit, 5);
      expect(
        AppSettings.fromJson({'autoBackupLimit': 'nope'}).autoBackupLimit,
        3,
      );
    });

    test('settings JSON gains a version while keeping old values', () {
      final settings = AppSettings.fromJson({
        'languageCode': 'en',
        'themeColorValue': 0xFF2196F3,
        'weightKg': 70,
      });
      final json = settings.toJson();

      expect(json['version'], AppSettings.currentVersion);
      expect(json['languageCode'], 'en');
      expect(json['themeColorValue'], 0xFF2196F3);
      expect(json['weightKg'], 70);
      expect(json['autoBackupLimit'], 3);
    });
  });

  group('Meal statistics', () {
    test('Meal scales custom food by consumed net content', () {
      final food = CustomFood(
        name: 'A',
        kj: 100,
        carbs: 10,
        protein: 5,
        fat: 2,
        basisAmount: 100,
        unitName: 'g',
      );
      final meal = Meal.fromFood(
        food: food,
        netContent: 200,
        createTime: DateTime.now(),
      );

      expect(meal.foodName, 'A');
      expect(meal.food.kj, 100);
      expect(meal.totalKj, 200);
      expect(meal.totalCarbs, 20);
      expect(meal.totalProtein, 10);
      expect(meal.totalFat, 4);
    });

    test('Meal.fromFood keeps a reference to the food', () {
      final packaged = PackagedFood(
        name: '牛奶',
        kj: 502.08,
        carbs: 10,
        protein: 6,
        fat: 8,
        netContent: 200,
        basisAmount: 100,
        unitName: 'ml',
      );
      final custom = CustomFood(
        name: '鸡蛋',
        kj: 300,
        carbs: 1,
        protein: 6,
        fat: 5,
      );

      final packagedLog = Meal.fromFood(
        food: packaged,
        createTime: DateTime.now(),
      ) as PackagedMeal;
      expect(packagedLog.food, same(packaged));
      expect(packagedLog.foodName, '牛奶');
      expect(packagedLog, isA<PackagedMeal>());
      expect(packagedLog.food.netContent, 200);
      expect(packagedLog.food.basisAmount, 100);
      expect(packagedLog.food.unitName, 'ml');

      final customLog = Meal.fromFood(
        food: custom,
        netContent: 50,
        createTime: DateTime.now(),
      ) as CustomMeal;
      expect(customLog.food, same(custom));
      expect(customLog.foodName, '鸡蛋');
      expect(customLog, isA<CustomMeal>());
      expect(customLog.netContent, 50);
      expect(customLog.food.basisAmount, 100);
      expect(customLog.food.unitName, 'g');
    });

    test('List<Meal> extension sums meals', () {
      final foodA = CustomFood(
        name: 'A',
        kj: 100,
        carbs: 10,
        protein: 5,
        fat: 2,
        basisAmount: 100,
        unitName: 'g',
      );
      final foodB = PackagedFood(
        name: 'B',
        kj: 200,
        carbs: 20,
        protein: 10,
        fat: 4,
      );
      final meals = [
        Meal.fromFood(food: foodA, netContent: 100, createTime: DateTime.now()),
        Meal.fromFood(food: foodB, quantity: 2, createTime: DateTime.now()),
      ];

      expect(meals.totalKj, 500);
      expect(meals.totalCarbs, 50);
      expect(meals.totalProtein, 25);
      expect(meals.totalFat, 10);
    });
  });
}
