import 'package:equatable/equatable.dart';

abstract class HistoryEvent extends Equatable {
  const HistoryEvent();

  @override
  List<Object?> get props => [];
}

/// Initial load; shows a loading indicator.
class LoadHistoryMeals extends HistoryEvent {
  const LoadHistoryMeals();
}

/// Silent refresh after the repository reports a change.
class RefreshHistoryMeals extends HistoryEvent {
  const RefreshHistoryMeals();
}
