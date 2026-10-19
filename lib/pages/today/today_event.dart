import 'package:equatable/equatable.dart';

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
  final int id;

  const DeleteTodayMeal(this.id);

  @override
  List<Object?> get props => [id];
}
