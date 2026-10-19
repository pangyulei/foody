import 'package:equatable/equatable.dart';

import '../models/food_entry.dart';
import '../utils/energy_converter.dart';

abstract class FoodState extends Equatable {
  const FoodState();

  @override
  List<Object?> get props => [];
}

class FoodInitial extends FoodState {}

class FoodLoading extends FoodState {}

class FoodLoaded extends FoodState {
  final List<FoodEntry> entries;
  final DateTime selectedDate;

  const FoodLoaded({required this.entries, required this.selectedDate});

  /// 当日总能量 (kJ)
  double get totalKj => entries.fold(0.0, (sum, item) => sum + item.kj);

  /// 当日总卡路里 (kcal)
  double get totalKcal => EnergyConverter.kjToKcal(totalKj);

  /// 当日总碳水化合物 (g)
  double get totalCarbs => entries.fold(0.0, (sum, item) => sum + item.carbs);

  /// 当日总蛋白质 (g)
  double get totalProtein =>
      entries.fold(0.0, (sum, item) => sum + item.protein);

  /// 当日总脂肪 (g)
  double get totalFat => entries.fold(0.0, (sum, item) => sum + item.fat);

  @override
  List<Object?> get props => [entries, selectedDate];
}

class FoodError extends FoodState {
  final String message;

  const FoodError(this.message);

  @override
  List<Object?> get props => [message];
}
