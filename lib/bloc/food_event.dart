import 'package:equatable/equatable.dart';

import '../models/food_entry.dart';

abstract class FoodEvent extends Equatable {
  const FoodEvent();

  @override
  List<Object?> get props => [];
}

/// 加载食物记录 (可指定日期，默认当天)
class LoadFoodEntries extends FoodEvent {
  final DateTime? selectedDate;

  const LoadFoodEntries({this.selectedDate});

  @override
  List<Object?> get props => [selectedDate];
}

/// 切换选择的日期
class SelectDate extends FoodEvent {
  final DateTime selectedDate;

  const SelectDate(this.selectedDate);

  @override
  List<Object?> get props => [selectedDate];
}

/// 添加食物记录
class AddFoodEntry extends FoodEvent {
  final FoodEntry entry;

  const AddFoodEntry(this.entry);

  @override
  List<Object?> get props => [entry];
}

/// 更新食物记录
class UpdateFoodEntry extends FoodEvent {
  final FoodEntry entry;

  const UpdateFoodEntry(this.entry);

  @override
  List<Object?> get props => [entry];
}

/// 删除食物记录
class DeleteFoodEntry extends FoodEvent {
  final int id;

  const DeleteFoodEntry(this.id);

  @override
  List<Object?> get props => [id];
}
