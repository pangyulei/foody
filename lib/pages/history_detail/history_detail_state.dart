import 'package:equatable/equatable.dart';

import '../../models/diet_log.dart';

abstract class HistoryDetailState extends Equatable {
  final DateTime date;

  const HistoryDetailState(this.date);

  @override
  List<Object?> get props => [date];
}

class HistoryDetailInitial extends HistoryDetailState {
  const HistoryDetailInitial(super.date);
}

class HistoryDetailLoading extends HistoryDetailState {
  const HistoryDetailLoading(super.date);
}

class HistoryDetailLoaded extends HistoryDetailState {
  final List<DietLog> logs;

  const HistoryDetailLoaded({required DateTime date, required this.logs})
    : super(date);

  @override
  List<Object?> get props => [date, logs];
}

class HistoryDetailError extends HistoryDetailState {
  final String message;

  const HistoryDetailError(super.date, this.message);

  @override
  List<Object?> get props => [date, message];
}
