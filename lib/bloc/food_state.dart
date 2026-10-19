import 'package:equatable/equatable.dart';

import '../models/diet_log.dart';

abstract class FoodState extends Equatable {
  const FoodState();

  @override
  List<Object?> get props => [];
}

class FoodInitial extends FoodState {}

class FoodLoading extends FoodState {}

class FoodLoaded extends FoodState {
  /// 今日的记录 (按时间倒序)
  final List<DietLog> todayLogs;

  /// 历史标签页所选日期的记录 (按时间倒序)
  final List<DietLog> selectedLogs;

  /// 历史标签页当前选择的日期
  final DateTime selectedDate;

  const FoodLoaded({
    required this.todayLogs,
    required this.selectedLogs,
    required this.selectedDate,
  });

  @override
  List<Object?> get props => [todayLogs, selectedLogs, selectedDate];
}

class FoodError extends FoodState {
  final String message;

  const FoodError(this.message);

  @override
  List<Object?> get props => [message];
}
