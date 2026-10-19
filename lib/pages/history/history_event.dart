import 'package:equatable/equatable.dart';

abstract class HistoryEvent extends Equatable {
  const HistoryEvent();

  @override
  List<Object?> get props => [];
}

/// Initial load; shows a loading indicator.
class LoadHistoryLogs extends HistoryEvent {
  const LoadHistoryLogs();
}

/// The user picked a different date.
class SelectHistoryDate extends HistoryEvent {
  final DateTime date;

  const SelectHistoryDate(this.date);

  @override
  List<Object?> get props => [date];
}

/// Silent refresh after the repository reports a change.
class RefreshHistoryLogs extends HistoryEvent {
  const RefreshHistoryLogs();
}

/// Delete one of the selected day's diet logs.
class DeleteHistoryLog extends HistoryEvent {
  final int id;

  const DeleteHistoryLog(this.id);

  @override
  List<Object?> get props => [id];
}
