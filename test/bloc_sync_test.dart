import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foody/models/custom_food.dart';
import 'package:foody/models/meal.dart';
import 'package:foody/pages/history/history_bloc.dart';
import 'package:foody/pages/history/history_event.dart';
import 'package:foody/pages/history/history_state.dart';
import 'package:foody/pages/today/today_bloc.dart';
import 'package:foody/pages/today/today_event.dart';
import 'package:foody/pages/today/today_state.dart';
import 'package:foody/repositories/food_repository.dart';
import 'package:foody/repositories/meal_repository.dart';
import 'package:foody/services/app_database.dart';

void main() {
  test('Today and History blocs refresh when diet meals change', () async {
    final database = AppDatabase(NativeDatabase.memory());
    final foodRepository = FoodRepository(database);
    final mealRepository = MealRepository(database);
    final todayBloc = TodayBloc(
      repository: mealRepository,
      foodRepository: foodRepository,
    );
    final historyBloc = HistoryBloc(
      repository: mealRepository,
      foodRepository: foodRepository,
    );

    addTearDown(() async {
      await todayBloc.close();
      await historyBloc.close();
      await foodRepository.dispose();
      await mealRepository.dispose();
      await database.close();
    });

    final initialToday = todayBloc.stream.firstWhere(
      (state) => state is TodayLoaded && state.meals.isEmpty,
    );
    final initialHistory = historyBloc.stream.firstWhere(
      (state) => state is HistoryLoaded && state.days.isEmpty,
    );
    todayBloc.add(const LoadTodayMeals());
    historyBloc.add(const LoadHistoryMeals());
    await Future.wait([initialToday, initialHistory]);

    final todayHasLog = todayBloc.stream.firstWhere(
      (state) => state is TodayLoaded && state.meals.isNotEmpty,
    );
    final historyHasLog = historyBloc.stream.firstWhere(
      (state) => state is HistoryLoaded && state.days.isNotEmpty,
    );

    final food = CustomFood(name: '鸡蛋', kj: 300, carbs: 1, protein: 6, fat: 5);
    await foodRepository.saveFood(food);
    final meal = Meal.fromFood(
      food: food,
      netContent: 100,
      createTime: DateTime.now(),
    );
    await mealRepository.saveMeal(meal);
    await Future.wait([todayHasLog, historyHasLog]);

    // Editing a referenced food must update the aggregated history summary.
    final historyUpdated = historyBloc.stream.firstWhere(
      (state) => state is HistoryLoaded && state.days.single.totalKj == 400,
    );
    food.kj = 400;
    await foodRepository.saveFood(food);
    await historyUpdated;

    final todayEmptyAgain = todayBloc.stream.firstWhere(
      (state) => state is TodayLoaded && state.meals.isEmpty,
    );
    final historyEmptyAgain = historyBloc.stream.firstWhere(
      (state) => state is HistoryLoaded && state.days.isEmpty,
    );
    await mealRepository.deleteMeal(meal);
    await Future.wait([todayEmptyAgain, historyEmptyAgain]);
  });
}
