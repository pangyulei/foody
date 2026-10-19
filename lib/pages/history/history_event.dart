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

/// Silent refresh after the repository reports a change.
class RefreshHistoryLogs extends HistoryEvent {
  const RefreshHistoryLogs();
}
