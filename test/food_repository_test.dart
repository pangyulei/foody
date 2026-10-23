import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foody/models/custom_food.dart';
import 'package:foody/models/meal.dart';
import 'package:foody/models/premade_food.dart';
import 'package:foody/repositories/food_repository.dart';
import 'package:foody/repositories/meal_repository.dart';
import 'package:foody/services/app_database.dart';

void main() {
  group('FoodRepository', () {
    late AppDatabase database;
    late FoodRepository repository;

    setUp(() {
      database = AppDatabase(NativeDatabase.memory());
      repository = FoodRepository(database);
    });

    tearDown(() async {
      await database.close();
    });

    test('saves foods and lists quick-add foods newest first', () async {
      final egg = CustomFood(
        name: '鸡蛋',
        kj: 300,
        carbs: 1,
        protein: 6,
        fat: 5,
        lastUsedTime: DateTime(2026, 10, 19, 8),
      );
      final milk = PremadeFood(
        name: '牛奶',
        kj: 251,
        carbs: 10,
        protein: 6,
        fat: 8,
        lastUsedTime: DateTime(2026, 10, 19, 9),
      );

      expect(await repository.saveFood(egg), greaterThan(0));
      expect(await repository.saveFood(milk), greaterThan(0));

      final recent = await repository.getQuickAddFoods();
      expect(recent, hasLength(2));
      expect(recent.first.name, '牛奶');
      expect(recent.last.name, '鸡蛋');
      expect(recent.first, isA<PremadeFood>());
      expect(recent.last, isA<CustomFood>());
    });

    test('updates an existing food', () async {
      final food = CustomFood(name: '鸡蛋', kj: 300, carbs: 1, protein: 6, fat: 5);
      final id = await repository.saveFood(food);

      food
        ..name = '煎蛋'
        ..kj = 350;
      expect(await repository.saveFood(food), id);

      final recent = await repository.getQuickAddFoods();
      expect(recent, hasLength(1));
      expect(recent.single.name, '煎蛋');
      expect(recent.single.kj, 350);
    });

    test('getAllFoods returns every catalogue entry', () async {
      await repository.saveFood(CustomFood(name: '鸡蛋', kj: 300, carbs: 1, protein: 6, fat: 5));
      await repository.saveFood(PremadeFood(name: '牛奶', kj: 251, carbs: 10, protein: 6, fat: 8));

      final foods = await repository.getAllFoods();
      expect(foods, hasLength(2));
      expect(foods.whereType<CustomFood>(), hasLength(1));
      expect(foods.whereType<PremadeFood>(), hasLength(1));
    });

    test('deleting a food keeps existing diet meals', () async {
      final mealRepository = MealRepository(database);
      addTearDown(mealRepository.dispose);

      final food = CustomFood(name: '鸡蛋', kj: 300, carbs: 1, protein: 6, fat: 5);
      await repository.saveFood(food);

      final meal = Meal.fromFood(food: food, createTime: DateTime(2026, 10, 19, 9));
      await mealRepository.saveMeal(meal);

      expect(await repository.deleteFood(food), isTrue);
      expect(await repository.getAllFoods(), isEmpty);

      final meals = await mealRepository.getMealsForDate(DateTime(2026, 10, 19));
      expect(meals, hasLength(1));
      expect(meals.single.foodName, '鸡蛋');
      expect(meals.single.kj, 300);
    });
  });
}
