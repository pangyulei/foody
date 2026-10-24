import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/food_repository.dart';
import '../../repositories/meal_repository.dart';
import 'history_detail_event.dart';
import 'history_detail_state.dart';

class HistoryDetailBloc extends Bloc<HistoryDetailEvent, HistoryDetailState> {
  final MealRepository repository;
  final FoodRepository foodRepository;
  DateTime _date;
  StreamSubscription<void>? _changesSubscription;
  StreamSubscription<void>? _foodChangesSubscription;

  HistoryDetailBloc({
    required this.repository,
    required this.foodRepository,
    required DateTime date,
  }) : _date = _day(date),
       super(HistoryDetailInitial(_day(date))) {
    on<LoadHistoryDetail>((event, emit) => _load(emit, showLoading: true));
    on<SelectHistoryDetailDate>(_onSelectDate);
    on<RefreshHistoryDetail>((event, emit) => _load(emit, showLoading: false));
    on<DeleteHistoryDetailMeal>(_onDelete);
    _changesSubscription = repository.changes.listen((_) {
      add(const RefreshHistoryDetail());
    });
    _foodChangesSubscription = foodRepository.changes.listen((_) {
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
      final meals = await repository.getMealsForDate(date);
      // Drop a result that belongs to a day the user already switched away
      // from while the query was running.
      if (date != _date) return;
      emit(HistoryDetailLoaded(date: date, meals: meals));
    } catch (e) {
      if (date != _date) return;
      emit(HistoryDetailError(date, e.toString()));
    }
  }

  Future<void> _onDelete(
    DeleteHistoryDetailMeal event,
    Emitter<HistoryDetailState> emit,
  ) async {
    try {
      await repository.deleteMeal(event.meal);
      // The repository change stream triggers a refresh.
    } catch (e) {
      emit(HistoryDetailError(_date, e.toString()));
    }
  }

  @override
  Future<void> close() async {
    await _changesSubscription?.cancel();
    await _foodChangesSubscription?.cancel();
    return super.close();
  }
}
