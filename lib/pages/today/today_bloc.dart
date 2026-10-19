import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/diet_log_repository.dart';
import 'today_event.dart';
import 'today_state.dart';

class TodayBloc extends Bloc<TodayEvent, TodayState> {
  final DietLogRepository repository;
  StreamSubscription<void>? _changesSubscription;

  TodayBloc({required this.repository}) : super(TodayInitial()) {
    on<LoadTodayLogs>((event, emit) => _load(emit, showLoading: true));
    on<RefreshTodayLogs>((event, emit) => _load(emit, showLoading: false));
    on<DeleteTodayLog>(_onDelete);
    _changesSubscription = repository.changes.listen((_) {
      add(const RefreshTodayLogs());
    });
  }

  Future<void> _load(
    Emitter<TodayState> emit, {
    required bool showLoading,
  }) async {
    if (showLoading) emit(TodayLoading());
    try {
      final logs = await repository.getDietLogsForDate(DateTime.now());
      emit(TodayLoaded(logs: logs));
    } catch (e) {
      emit(TodayError(e.toString()));
    }
  }

  Future<void> _onDelete(DeleteTodayLog event, Emitter<TodayState> emit) async {
    try {
      await repository.deleteDietLog(event.id);
      // The repository change stream triggers a refresh.
    } catch (e) {
      emit(TodayError(e.toString()));
    }
  }

  @override
  Future<void> close() async {
    await _changesSubscription?.cancel();
    return super.close();
  }
}
