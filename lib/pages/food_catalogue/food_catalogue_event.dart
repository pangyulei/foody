import 'package:equatable/equatable.dart';

import '../../models/food.dart';
import '../../models/premade_food.dart';

abstract class FoodCatalogueEvent extends Equatable {
  const FoodCatalogueEvent();

  @override
  List<Object?> get props => [];
}

/// Initial load; shows a loading indicator.
class LoadFoodCatalogue extends FoodCatalogueEvent {
  const LoadFoodCatalogue();
}

/// Silent refresh after the repository reports a change.
class RefreshFoodCatalogue extends FoodCatalogueEvent {
  const RefreshFoodCatalogue();
}

/// Removes a food from the catalogue. Meals are not affected.
class DeleteFoodCatalogueEntry extends FoodCatalogueEvent {
  final Food food;

  const DeleteFoodCatalogueEntry(this.food);

  @override
  List<Object?> get props => [food.id, food is PremadeFood];
}
