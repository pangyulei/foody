import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/diet_log_repository.dart';
import 'history_detail_event.dart';
import 'history_detail_state.dart';

class HistoryDetailBloc extends Bloc<HistoryDetailEvent, HistoryDetailState> {
  final DietLogRepository repository;
  DateTime _date;
  StreamSubscription<void>? _changesSubscription;

  HistoryDetailBloc({required this.repository, required DateTime date})
    : _date = _day(date),
      super(HistoryDetailInitial(_day(date))) {
    on<LoadHistoryDetail>((event, emit) => _load(emit, showLoading: true));
    on<SelectHistoryDetailDate>(_onSelectDate);
    on<RefreshHistoryDetail>((event, emit) => _load(emit, showLoading: false));
    on<DeleteHistoryDetailLog>(_onDelete);
    _changesSubscription = repository.changes.listen((_) {
      add(const RefreshHistoryDetail());
    });
  }

  static DateTime _day(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  Future<void> _onSelectDate(
    SelectHistoryDetailDate event,
    Emitter<HistoryDetailState> emit,
  ) {
    _date = _day(event.date);
    return _load(emit, showLoading: true);
  }

  Future<void> _load(
    Emitter<HistoryDetailState> emit, {
    required bool showLoading,
  }) async {
    final date = _date;
    if (showLoading) emit(HistoryDetailLoading(date));
    try {
      final logs = await repository.getDietLogsForDate(date);
      // Drop a result that belongs to a day the user already switched away
      // from while the query was running.
      if (date != _date) return;
      emit(HistoryDetailLoaded(date: date, logs: logs));
    } catch (e) {
      if (date != _date) return;
      emit(HistoryDetailError(date, e.toString()));
    }
  }

  Future<void> _onDelete(
    DeleteHistoryDetailLog event,
    Emitter<HistoryDetailState> emit,
  ) async {
    try {
      await repository.deleteDietLog(event.id);
      // The repository change stream triggers a refresh.
    } catch (e) {
      emit(HistoryDetailError(_date, e.toString()));
    }
  }

  @override
  Future<void> close() async {
    await _changesSubscription?.cancel();
    return super.close();
  }
}
