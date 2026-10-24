import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/food_repository.dart';
import '../../repositories/meal_repository.dart';
import 'today_event.dart';
import 'today_state.dart';

class TodayBloc extends Bloc<TodayEvent, TodayState> {
  final MealRepository repository;
  final FoodRepository foodRepository;
  StreamSubscription<void>? _changesSubscription;
  StreamSubscription<void>? _foodChangesSubscription;

  TodayBloc({required this.repository, required this.foodRepository})
    : super(TodayInitial()) {
    on<LoadTodayMeals>((event, emit) => _load(emit, showLoading: true));
    on<RefreshTodayMeals>((event, emit) => _load(emit, showLoading: false));
    on<DeleteTodayMeal>(_onDelete);
    _changesSubscription = repository.changes.listen((_) {
      add(const RefreshTodayMeals());
    });
    _foodChangesSubscription = foodRepository.changes.listen((_) {
      add(const RefreshTodayMeals());
    });
  }

  Future<void> _load(
    Emitter<TodayState> emit, {
    required bool showLoading,
  }) async {
    if (showLoading) emit(TodayLoading());
    try {
      final meals = await repository.getMealsForDate(DateTime.now());
      emit(TodayLoaded(meals: meals));
    } catch (e) {
      emit(TodayError(e.toString()));
    }
  }

  Future<void> _onDelete(
    DeleteTodayMeal event,
    Emitter<TodayState> emit,
  ) async {
    try {
      await repository.deleteMeal(event.meal);
      // The repository change stream triggers a refresh.
    } catch (e) {
      emit(TodayError(e.toString()));
    }
  }

  @override
  Future<void> close() async {
    await _changesSubscription?.cancel();
    await _foodChangesSubscription?.cancel();
    return super.close();
  }
}
