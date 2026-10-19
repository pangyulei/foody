import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/diet_log_repository.dart';
import 'history_event.dart';
import 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final DietLogRepository repository;
  StreamSubscription<void>? _changesSubscription;
  DateTime _selectedDate = _day(DateTime.now());

  HistoryBloc({required this.repository}) : super(HistoryInitial()) {
    on<LoadHistoryLogs>((event, emit) => _load(emit, showLoading: true));
    on<SelectHistoryDate>(_onSelectDate);
    on<RefreshHistoryLogs>((event, emit) => _load(emit, showLoading: false));
    on<DeleteHistoryLog>(_onDelete);
    _changesSubscription = repository.changes.listen((_) {
      add(const RefreshHistoryLogs());
    });
  }

  static DateTime _day(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  Future<void> _onSelectDate(
    SelectHistoryDate event,
    Emitter<HistoryState> emit,
  ) {
    _selectedDate = _day(event.date);
    return _load(emit, showLoading: false);
  }

  Future<void> _load(
    Emitter<HistoryState> emit, {
    required bool showLoading,
  }) async {
    if (showLoading) emit(HistoryLoading());
    try {
      final logs = await repository.getDietLogsForDate(_selectedDate);
      emit(HistoryLoaded(logs: logs, selectedDate: _selectedDate));
    } catch (e) {
      emit(HistoryError(e.toString()));
    }
  }

  Future<void> _onDelete(
    DeleteHistoryLog event,
    Emitter<HistoryState> emit,
  ) async {
    try {
      await repository.deleteDietLog(event.id);
      // The repository change stream triggers a refresh.
    } catch (e) {
      emit(HistoryError(e.toString()));
    }
  }

  @override
  Future<void> close() async {
    await _changesSubscription?.cancel();
    return super.close();
  }
}
