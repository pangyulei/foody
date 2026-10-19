import 'package:equatable/equatable.dart';

import '../../models/diet_log.dart';

abstract class TodayState extends Equatable {
  const TodayState();

  @override
  List<Object?> get props => [];
}

class TodayInitial extends TodayState {}

class TodayLoading extends TodayState {}

class TodayLoaded extends TodayState {
  final List<DietLog> logs;

  const TodayLoaded({required this.logs});

  @override
  List<Object?> get props => [logs];
}

class TodayError extends TodayState {
  final String message;

  const TodayError(this.message);

  @override
  List<Object?> get props => [message];
}
