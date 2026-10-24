import 'package:equatable/equatable.dart';

import '../../models/food.dart';

abstract class FoodCatalogueState extends Equatable {
  const FoodCatalogueState();

  @override
  List<Object?> get props => [];
}

class FoodCatalogueInitial extends FoodCatalogueState {}

class FoodCatalogueLoading extends FoodCatalogueState {}

class FoodCatalogueLoaded extends FoodCatalogueState {
  final List<Food> foods;

  /// Set when a delete was rejected because the food is used by a meal.
  final Food? blockedDelete;

  const FoodCatalogueLoaded({required this.foods, this.blockedDelete});

  @override
  List<Object?> get props => [foods, blockedDelete];
}

class FoodCatalogueError extends FoodCatalogueState {
  final String message;

  const FoodCatalogueError(this.message);

  @override
  List<Object?> get props => [message];
}
