import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foody/models/custom_food.dart';
import 'package:foody/models/meal.dart';
import 'package:foody/pages/food_catalogue/food_catalogue_bloc.dart';
import 'package:foody/pages/food_catalogue/food_catalogue_event.dart';
import 'package:foody/pages/food_catalogue/food_catalogue_state.dart';
import 'package:foody/repositories/food_repository.dart';
import 'package:foody/repositories/meal_repository.dart';
import 'package:foody/services/app_database.dart';

void main() {
  test('catalogue bloc loads and deletes without touching meals', () async {
    final database = AppDatabase(NativeDatabase.memory());
    final foodRepository = FoodRepository(database);
    final mealRepository = MealRepository(database);

    final food = CustomFood(name: '鸡蛋', kj: 300, carbs: 1, protein: 6, fat: 5);
    await foodRepository.saveFood(food);
    await mealRepository.saveMeal(
      Meal.fromFood(food: food, createTime: DateTime(2026, 10, 19, 9)),
    );

    final bloc = FoodCatalogueBloc(repository: foodRepository);

    addTearDown(() async {
      await bloc.close();
      await mealRepository.dispose();
      await foodRepository.dispose();
      await database.close();
    });

    final loaded = bloc.stream.firstWhere(
      (state) => state is FoodCatalogueLoaded && state.foods.length == 1,
    );
    bloc.add(const LoadFoodCatalogue());
    await loaded;

    final empty = bloc.stream.firstWhere(
      (state) => state is FoodCatalogueLoaded && state.foods.isEmpty,
    );
    bloc.add(DeleteFoodCatalogueEntry(food));
    await empty;

    final meals = await mealRepository.getMealsForDate(DateTime(2026, 10, 19));
    expect(meals, hasLength(1));
    expect(meals.single.foodName, '鸡蛋');
  });
}
