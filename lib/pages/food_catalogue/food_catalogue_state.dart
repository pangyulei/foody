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

  const FoodCatalogueLoaded({required this.foods});

  @override
  List<Object?> get props => [foods];
}

class FoodCatalogueError extends FoodCatalogueState {
  final String message;

  const FoodCatalogueError(this.message);

  @override
  List<Object?> get props => [message];
}
