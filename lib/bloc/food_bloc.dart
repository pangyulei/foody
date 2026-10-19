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

  FoodLoaded _buildState(DateTime selectedDate) {
    final today = _day(DateTime.now());
    final selected = _day(selectedDate);
    final selectedLogs = repository.getDietLogsForDate(selected);
    final todayLogs = _sameDay(selected, today)
        ? selectedLogs
        : repository.getDietLogsForDate(today);
    return FoodLoaded(
      todayLogs: todayLogs,
      selectedLogs: selectedLogs,
      selectedDate: selected,
    );
  }

  void _onLoadDietLogs(LoadDietLogs event, Emitter<FoodState> emit) {
    emit(FoodLoading());
    try {
      emit(_buildState(event.selectedDate ?? DateTime.now()));
    } catch (e) {
      emit(FoodError(e.toString()));
    }
  }

  void _onSelectDate(SelectDate event, Emitter<FoodState> emit) {
    try {
      emit(_buildState(event.selectedDate));
    } catch (e) {
      emit(FoodError(e.toString()));
    }
  }

  void _onAddDietLog(AddDietLog event, Emitter<FoodState> emit) {
    try {
      repository.saveDietLog(event.log);
      emit(_buildState(_currentSelectedDate));
    } catch (e) {
      emit(FoodError(e.toString()));
    }
  }

  void _onUpdateDietLog(UpdateDietLog event, Emitter<FoodState> emit) {
    try {
      repository.saveDietLog(event.log);
      emit(_buildState(_currentSelectedDate));
    } catch (e) {
      emit(FoodError(e.toString()));
    }
  }

  void _onDeleteDietLog(DeleteDietLog event, Emitter<FoodState> emit) {
    try {
      repository.deleteDietLog(event.id);
      emit(_buildState(_currentSelectedDate));
    } catch (e) {
      emit(FoodError(e.toString()));
    }
  }
}
