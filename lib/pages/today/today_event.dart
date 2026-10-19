import 'package:equatable/equatable.dart';

abstract class TodayEvent extends Equatable {
  const TodayEvent();

  @override
  List<Object?> get props => [];
}

/// Initial load; shows a loading indicator.
class LoadTodayLogs extends TodayEvent {
  const LoadTodayLogs();
}

/// Silent refresh after the repository reports a change.
class RefreshTodayLogs extends TodayEvent {
  const RefreshTodayLogs();
}

/// Delete one of today's diet logs.
class DeleteTodayLog extends TodayEvent {
  final int id;

  const DeleteTodayLog(this.id);

  @override
  List<Object?> get props => [id];
}
