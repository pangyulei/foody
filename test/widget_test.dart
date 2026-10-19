import 'package:flutter_test/flutter_test.dart';
import 'package:foood/extensions/diet_log_extensions.dart';
import 'package:foood/models/app_settings.dart';
import 'package:foood/models/custom_food.dart';
import 'package:foood/models/diet_log.dart';
import 'package:foood/models/food.dart';
import 'package:foood/models/premade_food.dart';
import 'package:foood/utils/energy_converter.dart';

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
  });

  group('DietLog statistics', () {
    test('DietLog multiplies food nutrition by quantity', () {
      final food = CustomFood(
        name: 'A',
        kj: 100,
        carbs: 10,
        protein: 5,
        fat: 2,
      );
      final log = DietLog.withFood(
        food: food,
        quantity: 2,
        createTime: DateTime.now(),
      );

      expect(log.food, same(food));
      expect(log.kj, 200);
      expect(log.carbs, 20);
      expect(log.protein, 10);
      expect(log.fat, 4);
    });

    test('DietLog supports both PremadeFood and CustomFood', () {
      final premade = PremadeFood(
        name: '牛奶',
        kj: 502.08,
        carbs: 10,
        protein: 6,
        fat: 8,
        servingAmount: 200,
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

      final premadeLog = DietLog.withFood(
        food: premade,
        createTime: DateTime.now(),
      );
      expect(premadeLog.food, same(premade));

      premadeLog.setFood(custom);
      expect(premadeLog.food, same(custom));

      expect(
        DietLog.withFood(food: custom, createTime: DateTime.now()).food,
        same(custom),
      );
    });

    test('List<DietLog> extension sums logs', () {
      final foodA = CustomFood(
        name: 'A',
        kj: 100,
        carbs: 10,
        protein: 5,
        fat: 2,
      );
      final foodB = PremadeFood(
        name: 'B',
        kj: 200,
        carbs: 20,
        protein: 10,
        fat: 4,
      );
      final logs = [
        DietLog.withFood(food: foodA, quantity: 1, createTime: DateTime.now()),
        DietLog.withFood(food: foodB, quantity: 2, createTime: DateTime.now()),
      ];

      expect(logs.totalKj, 500);
      expect(logs.totalCarbs, 50);
      expect(logs.totalProtein, 25);
      expect(logs.totalFat, 10);
    });
  });
}
