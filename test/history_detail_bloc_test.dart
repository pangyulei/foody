import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foody/models/custom_food.dart';
import 'package:foody/models/meal.dart';
import 'package:foody/pages/history_detail/history_detail_bloc.dart';
import 'package:foody/pages/history_detail/history_detail_event.dart';
import 'package:foody/pages/history_detail/history_detail_state.dart';
import 'package:foody/repositories/food_repository.dart';
import 'package:foody/repositories/meal_repository.dart';
import 'package:foody/services/app_database.dart';

void main() {
  test('history detail switches days and refreshes on delete', () async {
    final database = AppDatabase(NativeDatabase.memory());
    final foodRepository = FoodRepository(database);
    final repository = MealRepository(database);
    final bloc = HistoryDetailBloc(
      repository: repository,
      foodRepository: foodRepository,
      date: DateTime(2026, 10, 18),
    );

    addTearDown(() async {
      await bloc.close();
      await foodRepository.dispose();
      await repository.dispose();
      await database.close();
    });

    final food = CustomFood(name: '鸡蛋', kj: 300, carbs: 1, protein: 6, fat: 5);
    await foodRepository.saveFood(food);
    final selectedLog = Meal.fromFood(
      food: food,
      netContent: 100,
      createTime: DateTime(2026, 10, 18, 8),
    );
    final otherLog = Meal.fromFood(
      food: food,
      netContent: 100,
      createTime: DateTime(2026, 10, 19, 8),
    );
    await repository.saveMeal(selectedLog);
    await repository.saveMeal(otherLog);

    final loaded = bloc.stream.firstWhere(
      (state) => state is HistoryDetailLoaded && state.meals.length == 1,
    );
    bloc.add(const LoadHistoryDetail());
    final loadedState = await loaded as HistoryDetailLoaded;
    expect(loadedState.date, DateTime(2026, 10, 18));
    expect(loadedState.meals.single.id, selectedLog.id);

    final switchedToNextDay = bloc.stream.firstWhere(
      (state) =>
          state is HistoryDetailLoaded && state.date == DateTime(2026, 10, 19),
    );
    bloc.add(SelectHistoryDetailDate(DateTime(2026, 10, 19)));
    final nextDayState = await switchedToNextDay as HistoryDetailLoaded;
    expect(nextDayState.meals.single.id, otherLog.id);

    final switchedBack = bloc.stream.firstWhere(
      (state) =>
          state is HistoryDetailLoaded && state.date == DateTime(2026, 10, 18),
    );
    bloc.add(SelectHistoryDetailDate(DateTime(2026, 10, 18)));
    await switchedBack;

    final empty = bloc.stream.firstWhere(
      (state) => state is HistoryDetailLoaded && state.meals.isEmpty,
    );
    bloc.add(DeleteHistoryDetailMeal(selectedLog));
    await empty;

    final remaining = await repository.getMealsForDate(DateTime(2026, 10, 19));
    expect(remaining, hasLength(1));
    expect(remaining.single.id, otherLog.id);
  });
}
