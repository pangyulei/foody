import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/food_repository.dart';
import '../../repositories/meal_repository.dart';
import 'history_event.dart';
import 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final MealRepository repository;
  final FoodRepository foodRepository;
  StreamSubscription<void>? _changesSubscription;
  StreamSubscription<void>? _foodChangesSubscription;

  HistoryBloc({required this.repository, required this.foodRepository})
    : super(HistoryInitial()) {
    on<LoadHistoryMeals>((event, emit) => _load(emit, showLoading: true));
    on<RefreshHistoryMeals>((event, emit) => _load(emit, showLoading: false));
    _changesSubscription = repository.changes.listen((_) {
      add(const RefreshHistoryMeals());
    });
    _foodChangesSubscription = foodRepository.changes.listen((_) {
      add(const RefreshHistoryMeals());
    });
  }

  Future<void> _load(
    Emitter<HistoryState> emit, {
    required bool showLoading,
  }) async {
    if (showLoading) emit(HistoryLoading());
    try {
      final days = await repository.getDailySummaries();
      emit(HistoryLoaded(days: days));
    } catch (e) {
      emit(HistoryError(e.toString()));
    }
  }

  @override
  Future<void> close() async {
    await _changesSubscription?.cancel();
    await _foodChangesSubscription?.cancel();
    return super.close();
  }
}
