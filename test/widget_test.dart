import 'package:flutter_test/flutter_test.dart';
import 'package:foood/models/food_entry.dart';
import 'package:foood/utils/energy_converter.dart';

void main() {
  group('EnergyConverter Tests', () {
    test('kJ to kcal conversion formula', () {
      // 1 kcal = 4.184 kJ
      expect(EnergyConverter.kjToKcal(418.4), closeTo(100.0, 0.001));
      expect(EnergyConverter.kcalToKj(100.0), closeTo(418.4, 0.001));
    });

    test('FoodEntry calories getter', () {
      final entry = FoodEntry(
        name: '牛奶',
        createTime: DateTime.now(),
        kj: 502.08, // 502.08 kJ = 120 kcal
        carbs: 10.0,
        protein: 6.0,
        fat: 8.0,
      );

      expect(entry.calories, closeTo(120.0, 0.01));
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
}
