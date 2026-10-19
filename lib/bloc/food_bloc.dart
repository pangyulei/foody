import 'package:flutter_bloc/flutter_bloc.dart';

import '../repositories/food_repository.dart';
import 'food_event.dart';
import 'food_state.dart';

class FoodBloc extends Bloc<FoodEvent, FoodState> {
  final FoodRepository repository;

  FoodBloc({required this.repository}) : super(FoodInitial()) {
    on<LoadDietLogs>(_onLoadDietLogs);
    on<SelectDate>(_onSelectDate);
    on<AddDietLog>(_onAddDietLog);
    on<UpdateDietLog>(_onUpdateDietLog);
    on<DeleteDietLog>(_onDeleteDietLog);
  }

  DateTime _day(DateTime date) => DateTime(date.year, date.month, date.day);

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  DateTime get _currentSelectedDate => state is FoodLoaded
      ? (state as FoodLoaded).selectedDate
      : _day(DateTime.now());

  Future<FoodLoaded> _buildState(DateTime selectedDate) async {
    final today = _day(DateTime.now());
    final selected = _day(selectedDate);
    final selectedLogs = await repository.getDietLogsForDate(selected);
    final todayLogs = _sameDay(selected, today)
        ? selectedLogs
        : await repository.getDietLogsForDate(today);
    return FoodLoaded(
      todayLogs: todayLogs,
      selectedLogs: selectedLogs,
      selectedDate: selected,
    );
  }

  Future<void> _onLoadDietLogs(
    LoadDietLogs event,
    Emitter<FoodState> emit,
  ) async {
    emit(FoodLoading());
    try {
      emit(await _buildState(event.selectedDate ?? DateTime.now()));
    } catch (e) {
      emit(FoodError(e.toString()));
    }
  }

  Future<void> _onSelectDate(SelectDate event, Emitter<FoodState> emit) async {
    try {
      emit(await _buildState(event.selectedDate));
    } catch (e) {
      emit(FoodError(e.toString()));
    }
  }

  Future<void> _onAddDietLog(AddDietLog event, Emitter<FoodState> emit) async {
    try {
      await repository.saveDietLog(event.log);
      emit(await _buildState(_currentSelectedDate));
    } catch (e) {
      emit(FoodError(e.toString()));
    }
  }

  Future<void> _onUpdateDietLog(
    UpdateDietLog event,
    Emitter<FoodState> emit,
  ) async {
    try {
      await repository.saveDietLog(event.log);
      emit(await _buildState(_currentSelectedDate));
    } catch (e) {
      emit(FoodError(e.toString()));
    }
  }

  Future<void> _onDeleteDietLog(
    DeleteDietLog event,
    Emitter<FoodState> emit,
  ) async {
    try {
      await repository.deleteDietLog(event.id);
      emit(await _buildState(_currentSelectedDate));
    } catch (e) {
      emit(FoodError(e.toString()));
    }
  }
}
