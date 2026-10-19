import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/diet_log_repository.dart';
import 'history_event.dart';
import 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final DietLogRepository repository;
  StreamSubscription<void>? _changesSubscription;

  HistoryBloc({required this.repository}) : super(HistoryInitial()) {
    on<LoadHistoryLogs>((event, emit) => _load(emit, showLoading: true));
    on<RefreshHistoryLogs>((event, emit) => _load(emit, showLoading: false));
    _changesSubscription = repository.changes.listen((_) {
      add(const RefreshHistoryLogs());
    });
  }

  Future<void> _load(
    Emitter<HistoryState> emit, {
    required bool showLoading,
  }) async {
    if (showLoading) emit(HistoryLoading());
    try {
      final summaries = await repository.getDailySummaries();
      emit(HistoryLoaded(summaries: summaries));
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
