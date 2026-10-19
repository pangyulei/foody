import 'package:equatable/equatable.dart';

import '../models/diet_log.dart';

abstract class FoodEvent extends Equatable {
  const FoodEvent();

  @override
  List<Object?> get props => [];
}

/// 加载进食记录 (可指定日期，默认当天)
class LoadDietLogs extends FoodEvent {
  final DateTime? selectedDate;

  const LoadDietLogs({this.selectedDate});

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

/// 添加进食记录
class AddDietLog extends FoodEvent {
  final DietLog log;

  const AddDietLog(this.log);

  @override
  List<Object?> get props => [log];
}

/// 更新进食记录
class UpdateDietLog extends FoodEvent {
  final DietLog log;

  const UpdateDietLog(this.log);

  @override
  List<Object?> get props => [log];
}

/// 删除进食记录
class DeleteDietLog extends FoodEvent {
  final int id;

  const DeleteDietLog(this.id);

  @override
  List<Object?> get props => [id];
}
