import 'package:equatable/equatable.dart';

import '../../models/daily_log_summary.dart';

abstract class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object?> get props => [];
}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<DailyLogSummary> summaries;

  const HistoryLoaded({required this.summaries});

  @override
  List<Object?> get props => [summaries];
}

class HistoryError extends HistoryState {
  final String message;

  const HistoryError(this.message);

  @override
  List<Object?> get props => [message];
}
