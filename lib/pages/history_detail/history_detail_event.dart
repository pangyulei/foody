import 'package:equatable/equatable.dart';

import '../../models/meal.dart';

abstract class HistoryDetailEvent extends Equatable {
  const HistoryDetailEvent();

  @override
  List<Object?> get props => [];
}

/// Initial load; shows a loading indicator.
class LoadHistoryDetail extends HistoryDetailEvent {
  const LoadHistoryDetail();
}

/// Switch the detail page to another day.
class SelectHistoryDetailDate extends HistoryDetailEvent {
  final DateTime date;

  const SelectHistoryDetailDate(this.date);

  @override
  List<Object?> get props => [date];
}

/// Silent refresh after the repository reports a change.
class RefreshHistoryDetail extends HistoryDetailEvent {
  const RefreshHistoryDetail();
}

/// Delete one of the selected day's meals.
class DeleteHistoryDetailMeal extends HistoryDetailEvent {
  final Meal meal;

  const DeleteHistoryDetailMeal(this.meal);

  @override
  List<Object?> get props => [meal.id, meal is CustomMeal];
}
