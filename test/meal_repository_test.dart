import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foody/extensions/meal_extensions.dart';
import 'package:foody/models/custom_food.dart';
import 'package:foody/models/food_source.dart';
import 'package:foody/models/meal.dart';
import 'package:foody/models/premade_food.dart';
import 'package:foody/repositories/food_repository.dart';
import 'package:foody/repositories/meal_repository.dart';
import 'package:foody/services/app_database.dart';

void main() {
  group('MealRepository', () {
    late AppDatabase database;
    late FoodRepository foodRepository;
    late MealRepository repository;

    setUp(() {
      database = AppDatabase(NativeDatabase.memory());
      foodRepository = FoodRepository(database);
      repository = MealRepository(database);
    });

    tearDown(() async {
      await repository.dispose();
      await database.close();
    });

    test('saves and loads a PremadeFood meal snapshot', () async {
      final food = PremadeFood(
        name: '牛奶',
        kj: 251,
        carbs: 10,
        protein: 6,
        fat: 8,
        netContent: 200,
        basisAmount: 100,
        unitName: 'ml',
      );
      final meal = Meal.fromFood(
        food: food,
        quantity: 2,
        createTime: DateTime(2026, 10, 19, 8, 30),
        note: 'Breakfast',
      );

      await repository.saveMeal(meal);
      expect(meal.id, greaterThan(0));

      final loaded = await repository.getMealsForDate(DateTime(2026, 10, 19));
      expect(loaded, hasLength(1));

      final loadedLog = loaded.first;
      expect(loadedLog.id, meal.id);
      expect(loadedLog.foodName, '牛奶');
      expect(loadedLog.foodSource, FoodSource.premade);
      expect(loadedLog.netContent, 200);
      expect(loadedLog.basisAmount, 100);
      expect(loadedLog.unitName, 'ml');
      expect(loadedLog.quantity, 2);
      expect(loadedLog.createTime, DateTime(2026, 10, 19, 8, 30));
      expect(loadedLog.note, 'Breakfast');
      expect(loadedLog.kj, 251);
      expect(loadedLog.totalKj, 502);
      expect(loadedLog.totalCarbs, 20);
      expect(loadedLog.totalProtein, 12);
      expect(loadedLog.totalFat, 16);
    });

    test('groups meals by day with totals, newest day first', () async {
      final food = CustomFood(
        name: '鸡蛋',
        kj: 300,
        carbs: 1,
        protein: 6,
        fat: 5,
      );

      await repository.saveMeal(
        Meal.fromFood(
          food: food,
          quantity: 1,
          createTime: DateTime(2026, 10, 18, 8),
        ),
      );
      await repository.saveMeal(
        Meal.fromFood(
          food: food,
          quantity: 2,
          createTime: DateTime(2026, 10, 18, 18),
        ),
      );
      await repository.saveMeal(
        Meal.fromFood(
          food: food,
          quantity: 1,
          createTime: DateTime(2026, 10, 19, 9),
        ),
      );

      final days = await repository.getMealsByDay();
      expect(days, hasLength(2));
      expect(days.first.date, DateTime(2026, 10, 19));
      expect(days.first.mealCount, 1);
      expect(days.first.totalKj, 300);

      final older = days.last;
      expect(older.date, DateTime(2026, 10, 18));
      expect(older.mealCount, 2);
      expect(older.totalKj, 900);
      expect(older.totalCarbs, 3);
      expect(older.totalProtein, 18);
      expect(older.totalFat, 15);
    });

    test('saves and loads a CustomFood meal snapshot', () async {
      final food = CustomFood(
        name: '鸡蛋',
        kj: 300,
        carbs: 1,
        protein: 6,
        fat: 5,
      );
      final meal = Meal.fromFood(
        food: food,
        createTime: DateTime(2026, 10, 19, 12),
      );

      await repository.saveMeal(meal);

      final loaded = await repository.getMealsForDate(DateTime(2026, 10, 19));
      expect(loaded, hasLength(1));
      expect(loaded.first.foodName, '鸡蛋');
      expect(loaded.first.foodSource, FoodSource.custom);
      expect(loaded.first.totalKj, 300);
    });

    test('updates a meal with a new food snapshot', () async {
      final premade = PremadeFood(
        name: '牛奶',
        kj: 251,
        carbs: 10,
        protein: 6,
        fat: 8,
      );
      final meal = Meal.fromFood(
        food: premade,
        createTime: DateTime(2026, 10, 19, 8),
      );
      await repository.saveMeal(meal);

      final custom = CustomFood(
        name: '鸡蛋',
        kj: 300,
        carbs: 1,
        protein: 6,
        fat: 5,
      );
      final updated = Meal.fromFood(
        id: meal.id,
        food: custom,
        quantity: 2,
        createTime: meal.createTime,
        note: 'Updated',
      );
      await repository.saveMeal(updated);

      final loaded = await repository.getMealsForDate(DateTime(2026, 10, 19));
      expect(loaded, hasLength(1));
      expect(loaded.first.id, meal.id);
      expect(loaded.first.foodName, '鸡蛋');
      expect(loaded.first.foodSource, FoodSource.custom);
      expect(loaded.first.quantity, 2);
      expect(loaded.first.note, 'Updated');
      expect(loaded.first.totalKj, 600);
    });

    test('later food changes do not alter an existing meal', () async {
      final food = CustomFood(
        name: '鸡蛋',
        kj: 300,
        carbs: 1,
        protein: 6,
        fat: 5,
      );
      final meal = Meal.fromFood(
        food: food,
        createTime: DateTime(2026, 10, 19, 8),
      );

      food
        ..name = '改名后的鸡蛋'
        ..kj = 999;

      await repository.saveMeal(meal);
      final loaded = await repository.getMealsForDate(DateTime(2026, 10, 19));

      expect(loaded.first.foodName, '鸡蛋');
      expect(loaded.first.kj, 300);
    });

    test('deleting a food does not change existing diet meals', () async {
      final food = CustomFood(
        name: '鸡蛋',
        kj: 300,
        carbs: 1,
        protein: 6,
        fat: 5,
      );
      await foodRepository.saveFood(food);
      final meal = Meal.fromFood(
        food: food,
        quantity: 2,
        createTime: DateTime(2026, 10, 19, 8),
      );
      await repository.saveMeal(meal);

      expect(await foodRepository.deleteFood(food), isTrue);
      expect(await foodRepository.getRecentFoods(), isEmpty);

      final loaded = await repository.getMealsForDate(DateTime(2026, 10, 19));
      expect(loaded, hasLength(1));
      expect(loaded.first.foodName, '鸡蛋');
      expect(loaded.first.kj, 300);
      expect(loaded.first.totalKj, 600);
    });

    test('deleting a meal does not remove food catalogue entries', () async {
      final food = CustomFood(
        name: '鸡蛋',
        kj: 300,
        carbs: 1,
        protein: 6,
        fat: 5,
      );
      await foodRepository.saveFood(food);
      final meal = Meal.fromFood(
        food: food,
        createTime: DateTime(2026, 10, 19, 8),
      );
      await repository.saveMeal(meal);

      final deleted = await repository.deleteMeal(meal.id);
      expect(deleted, isTrue);

      final loaded = await repository.getMealsForDate(DateTime(2026, 10, 19));
      expect(loaded, isEmpty);

      final recent = await foodRepository.getRecentFoods();
      expect(recent, hasLength(1));
      expect(recent.first.name, '鸡蛋');
    });
  });
}
