import 'package:equatable/equatable.dart';

import '../../models/meal.dart';

abstract class TodayState extends Equatable {
  const TodayState();

  @override
  List<Object?> get props => [];
}

class TodayInitial extends TodayState {}

class TodayLoading extends TodayState {}

class TodayLoaded extends TodayState {
  final List<Meal> meals;

  const TodayLoaded({required this.meals});

  @override
  List<Object?> get props => [meals];
}

class TodayError extends TodayState {
  final String message;

  const TodayError(this.message);

  @override
  List<Object?> get props => [message];
}
