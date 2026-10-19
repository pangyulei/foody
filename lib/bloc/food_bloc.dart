import 'package:flutter_bloc/flutter_bloc.dart';

import '../repositories/food_repository.dart';
import 'food_event.dart';
import 'food_state.dart';

class FoodBloc extends Bloc<FoodEvent, FoodState> {
  final FoodRepository repository;

  FoodBloc({required this.repository}) : super(FoodInitial()) {
    on<LoadFoodEntries>(_onLoadFoodEntries);
    on<SelectDate>(_onSelectDate);
    on<AddFoodEntry>(_onAddFoodEntry);
    on<UpdateFoodEntry>(_onUpdateFoodEntry);
    on<DeleteFoodEntry>(_onDeleteFoodEntry);
  }

  void _onLoadFoodEntries(LoadFoodEntries event, Emitter<FoodState> emit) {
    emit(FoodLoading());
    try {
      final targetDate = event.selectedDate ?? DateTime.now();
      final entries = repository.getFoodEntriesForDate(targetDate);
      emit(FoodLoaded(entries: entries, selectedDate: targetDate));
    } catch (e) {
      emit(FoodError("加载数据失败: ${e.toString()}"));
    }
  }

  void _onSelectDate(SelectDate event, Emitter<FoodState> emit) {
    emit(FoodLoading());
    try {
      final entries = repository.getFoodEntriesForDate(event.selectedDate);
      emit(FoodLoaded(entries: entries, selectedDate: event.selectedDate));
    } catch (e) {
      emit(FoodError("切换日期失败: ${e.toString()}"));
    }
  }

  void _onAddFoodEntry(AddFoodEntry event, Emitter<FoodState> emit) {
    try {
      repository.saveFoodEntry(event.entry);
      // 保持当前选中的日期，或者跟新加入的记录日期一致
      final currentSelectedDate = state is FoodLoaded
          ? (state as FoodLoaded).selectedDate
          : event.entry.createTime;

      final entries = repository.getFoodEntriesForDate(currentSelectedDate);
      emit(FoodLoaded(entries: entries, selectedDate: currentSelectedDate));
    } catch (e) {
      emit(FoodError("添加记录失败: ${e.toString()}"));
    }
  }

  void _onUpdateFoodEntry(UpdateFoodEntry event, Emitter<FoodState> emit) {
    try {
      repository.saveFoodEntry(event.entry);
      final currentSelectedDate = state is FoodLoaded
          ? (state as FoodLoaded).selectedDate
          : event.entry.createTime;

      final entries = repository.getFoodEntriesForDate(currentSelectedDate);
      emit(FoodLoaded(entries: entries, selectedDate: currentSelectedDate));
    } catch (e) {
      emit(FoodError("更新记录失败: ${e.toString()}"));
    }
  }

  void _onDeleteFoodEntry(DeleteFoodEntry event, Emitter<FoodState> emit) {
    try {
      repository.deleteFoodEntry(event.id);
      final currentSelectedDate = state is FoodLoaded
          ? (state as FoodLoaded).selectedDate
          : DateTime.now();

      final entries = repository.getFoodEntriesForDate(currentSelectedDate);
      emit(FoodLoaded(entries: entries, selectedDate: currentSelectedDate));
    } catch (e) {
      emit(FoodError("删除记录失败: ${e.toString()}"));
    }
  }
}
