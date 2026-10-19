import 'package:equatable/equatable.dart';

import '../../models/meal.dart';

abstract class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object?> get props => [];
}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  /// One list per day, newest day first.
  final List<List<Meal>> days;

  const HistoryLoaded({required this.days});

  @override
  List<Object?> get props => [days];
}

class HistoryError extends HistoryState {
  final String message;

  const HistoryError(this.message);

  @override
  List<Object?> get props => [message];
}
