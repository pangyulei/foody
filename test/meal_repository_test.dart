import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foody/extensions/meal_extensions.dart';
import 'package:foody/models/custom_food.dart';
import 'package:foody/models/meal.dart';
import 'package:foody/models/packaged_food.dart';
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

    test('saves and loads a PackagedFood meal reference', () async {
      final food = PackagedFood(
        name: '牛奶',
        kj: 251,
        carbs: 10,
        protein: 6,
        fat: 8,
        netContent: 200,
        basisAmount: 100,
        unitName: 'ml',
      );
      await foodRepository.saveFood(food);
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

      final loadedLog = loaded.first as PackagedMeal;
      expect(loadedLog.id, meal.id);
      expect(loadedLog.foodName, '牛奶');
      expect(loadedLog, isA<PackagedMeal>());
      expect(loadedLog.food.netContent, 200);
      expect(loadedLog.food.basisAmount, 100);
      expect(loadedLog.food.unitName, 'ml');
      expect(loadedLog.quantity, 2);
      expect(loadedLog.createTime, DateTime(2026, 10, 19, 8, 30));
      expect(loadedLog.note, 'Breakfast');
      expect(loadedLog.food.kj, 251);
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
        basisAmount: 100,
        unitName: 'g',
      );
      await foodRepository.saveFood(food);

      await repository.saveMeal(
        Meal.fromFood(
          food: food,
          netContent: 100,
          createTime: DateTime(2026, 10, 18, 8),
        ),
      );
      await repository.saveMeal(
        Meal.fromFood(
          food: food,
          netContent: 200,
          createTime: DateTime(2026, 10, 18, 18),
        ),
      );
      await repository.saveMeal(
        Meal.fromFood(
          food: food,
          netContent: 100,
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

    test('saves and loads a CustomFood meal reference', () async {
      final food = CustomFood(
        name: '鸡蛋',
        kj: 300,
        carbs: 1,
        protein: 6,
        fat: 5,
        basisAmount: 100,
        unitName: 'g',
      );
      await foodRepository.saveFood(food);
      final meal = Meal.fromFood(
        food: food,
        netContent: 100,
        createTime: DateTime(2026, 10, 19, 12),
      );

      await repository.saveMeal(meal);

      final loaded = await repository.getMealsForDate(DateTime(2026, 10, 19));
      expect(loaded, hasLength(1));
      expect(loaded.first.foodName, '鸡蛋');
      expect(loaded.first, isA<CustomMeal>());
      expect((loaded.first as CustomMeal).netContent, 100);
      expect(loaded.first.totalKj, 300);
    });

    test('updates a meal to reference another packaged food', () async {
      final firstFood = PackagedFood(
        name: '牛奶',
        kj: 251,
        carbs: 10,
        protein: 6,
        fat: 8,
      );
      await foodRepository.saveFood(firstFood);
      final meal = Meal.fromFood(
        food: firstFood,
        createTime: DateTime(2026, 10, 19, 8),
      );
      await repository.saveMeal(meal);

      final secondFood = PackagedFood(
        name: '豆浆',
        kj: 300,
        carbs: 5,
        protein: 7,
        fat: 4,
      );
      await foodRepository.saveFood(secondFood);
      final updated = Meal.fromFood(
        id: meal.id,
        food: secondFood,
        quantity: 2,
        createTime: meal.createTime,
        note: 'Updated',
      );
      await repository.saveMeal(updated);

      final loaded = await repository.getMealsForDate(DateTime(2026, 10, 19));
      expect(loaded, hasLength(1));
      expect(loaded.first.id, meal.id);
      expect(loaded.first.foodName, '豆浆');
      expect(loaded.first, isA<PackagedMeal>());
      expect((loaded.first as PackagedMeal).quantity, 2);
      expect(loaded.first.note, 'Updated');
      expect(loaded.first.totalKj, 600);
    });

    test('editing a food updates its meal history', () async {
      final food = CustomFood(
        name: '鸡蛋',
        kj: 300,
        carbs: 1,
        protein: 6,
        fat: 5,
      );
      await foodRepository.saveFood(food);
      await repository.saveMeal(
        Meal.fromFood(
          food: food,
          netContent: 100,
          createTime: DateTime(2026, 10, 19, 8),
        ),
      );

      food
        ..name = '改名后的鸡蛋'
        ..kj = 999;
      await foodRepository.saveFood(food);

      final loaded = await repository.getMealsForDate(DateTime(2026, 10, 19));
      expect(loaded.first.foodName, '改名后的鸡蛋');
      expect(loaded.first.food.kj, 999);
      expect(loaded.first.totalKj, 999);
    });

    test('deleting a referenced food is blocked', () async {
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
        netContent: 200,
        createTime: DateTime(2026, 10, 19, 8),
      );
      await repository.saveMeal(meal);

      await expectLater(
        foodRepository.deleteFood(food),
        throwsA(isA<FoodInUseException>()),
      );

      final loaded = await repository.getMealsForDate(DateTime(2026, 10, 19));
      expect(loaded, hasLength(1));
      expect(loaded.first.foodName, '鸡蛋');
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
        netContent: 100,
        createTime: DateTime(2026, 10, 19, 8),
      );
      await repository.saveMeal(meal);

      final deleted = await repository.deleteMeal(meal);
      expect(deleted, isTrue);

      final loaded = await repository.getMealsForDate(DateTime(2026, 10, 19));
      expect(loaded, isEmpty);

      final recent = await foodRepository.getQuickAddFoods();
      expect(recent, hasLength(1));
      expect(recent.first.name, '鸡蛋');
    });

    test('maintains daily summaries on save, move, and delete', () async {
      final food = CustomFood(
        name: '鸡蛋',
        kj: 300,
        carbs: 1,
        protein: 6,
        fat: 5,
      );
      await foodRepository.saveFood(food);

      final dayOne = DateTime(2026, 10, 18, 8);
      final dayTwo = DateTime(2026, 10, 19, 9);
      final meal = Meal.fromFood(
        food: food,
        netContent: 100,
        createTime: dayOne,
      );
      await repository.saveMeal(meal);

      var summaries = await repository.getDailySummaries();
      expect(summaries, hasLength(1));
      expect(summaries.single.day, DateTime(2026, 10, 18));
      expect(summaries.single.totalKj, 300);
      expect(summaries.single.totalCarbs, 1);
      expect(summaries.single.totalProtein, 6);
      expect(summaries.single.totalFat, 5);
      expect(summaries.single.mealCount, 1);

      // Moving the meal must refresh both the old and the new day.
      final moved = Meal.fromFood(
        id: meal.id,
        food: food,
        netContent: 200,
        createTime: dayTwo,
      );
      await repository.saveMeal(moved);

      summaries = await repository.getDailySummaries();
      expect(summaries, hasLength(1));
      expect(summaries.single.day, DateTime(2026, 10, 19));
      expect(summaries.single.totalKj, 600);
      expect(summaries.single.mealCount, 1);

      await repository.deleteMeal(moved);
      expect(await repository.getDailySummaries(), isEmpty);
    });

    test('lists meals newest first, ordered down to the second', () async {
      final food = CustomFood(
        name: '鸡蛋',
        kj: 300,
        carbs: 1,
        protein: 6,
        fat: 5,
      );
      await foodRepository.saveFood(food);

      for (final time in [
        DateTime(2026, 10, 19, 8, 0, 5),
        DateTime(2026, 10, 19, 8, 0, 42),
        DateTime(2026, 10, 19, 8, 0, 17),
        DateTime(2026, 10, 19, 8, 0, 42),
      ]) {
        await repository.saveMeal(
          Meal.fromFood(food: food, netContent: 100, createTime: time),
        );
      }

      final loaded = await repository.getMealsForDate(DateTime(2026, 10, 19));
      expect(loaded.map((meal) => meal.createTime.second), [42, 42, 17, 5]);

      // Same-second meals fall back to the newest id.
      expect(loaded[0].id, greaterThan(loaded[1].id));
    });

    test('daily summary combines packaged and custom meals', () async {
      final custom = CustomFood(
        name: '鸡蛋',
        kj: 300,
        carbs: 1,
        protein: 6,
        fat: 5,
      );
      final packaged = PackagedFood(
        name: '牛奶',
        kj: 251,
        carbs: 10,
        protein: 6,
        fat: 8,
        netContent: 200,
        basisAmount: 100,
        unitName: 'ml',
      );
      await foodRepository.saveFood(custom);
      await foodRepository.saveFood(packaged);

      final day = DateTime(2026, 10, 19, 8);
      await repository.saveMeal(
        Meal.fromFood(food: custom, netContent: 100, createTime: day),
      );
      await repository.saveMeal(
        Meal.fromFood(food: packaged, quantity: 2, createTime: day),
      );

      final summary = (await repository.getDailySummaries()).single;
      expect(summary.mealCount, 2);
      expect(summary.totalKj, closeTo(802, 0.001));
      expect(summary.totalCarbs, closeTo(21, 0.001));
      expect(summary.totalProtein, closeTo(18, 0.001));
      expect(summary.totalFat, closeTo(21, 0.001));
    });
  });
}
