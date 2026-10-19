import 'package:equatable/equatable.dart';

import '../../models/diet_log.dart';

abstract class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object?> get props => [];
}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<DietLog> logs;
  final DateTime selectedDate;

  const HistoryLoaded({required this.logs, required this.selectedDate});

  @override
  List<Object?> get props => [logs, selectedDate];
}

class HistoryError extends HistoryState {
  final String message;

  const HistoryError(this.message);

  @override
  List<Object?> get props => [message];
}
