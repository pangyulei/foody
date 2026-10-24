import 'package:equatable/equatable.dart';

import '../../models/meal.dart';

abstract class TodayEvent extends Equatable {
  const TodayEvent();

  @override
  List<Object?> get props => [];
}

/// Initial load; shows a loading indicator.
class LoadTodayMeals extends TodayEvent {
  const LoadTodayMeals();
}

/// Silent refresh after the repository reports a change.
class RefreshTodayMeals extends TodayEvent {
  const RefreshTodayMeals();
}

/// Delete one of today's diet meals.
class DeleteTodayMeal extends TodayEvent {
  final Meal meal;

  const DeleteTodayMeal(this.meal);

  @override
  List<Object?> get props => [meal.id, meal is CustomMeal];
}
