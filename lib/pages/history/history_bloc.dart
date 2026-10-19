import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/meal_repository.dart';
import 'history_event.dart';
import 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final MealRepository repository;
  StreamSubscription<void>? _changesSubscription;

  HistoryBloc({required this.repository}) : super(HistoryInitial()) {
    on<LoadHistoryMeals>((event, emit) => _load(emit, showLoading: true));
    on<RefreshHistoryMeals>((event, emit) => _load(emit, showLoading: false));
    _changesSubscription = repository.changes.listen((_) {
      add(const RefreshHistoryMeals());
    });
  }

  Future<void> _load(
    Emitter<HistoryState> emit, {
    required bool showLoading,
  }) async {
    if (showLoading) emit(HistoryLoading());
    try {
      final days = await repository.getMealsByDay();
      emit(HistoryLoaded(days: days));
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
