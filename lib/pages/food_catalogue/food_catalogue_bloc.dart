import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/food_repository.dart';
import 'food_catalogue_event.dart';
import 'food_catalogue_state.dart';

class FoodCatalogueBloc extends Bloc<FoodCatalogueEvent, FoodCatalogueState> {
  final FoodRepository repository;
  StreamSubscription<void>? _changesSubscription;

  FoodCatalogueBloc({required this.repository})
    : super(FoodCatalogueInitial()) {
    on<LoadFoodCatalogue>((event, emit) => _load(emit, showLoading: true));
    on<RefreshFoodCatalogue>((event, emit) => _load(emit, showLoading: false));
    on<DeleteFoodCatalogueEntry>(_onDelete);
    _changesSubscription = repository.changes.listen((_) {
      add(const RefreshFoodCatalogue());
    });
  }

  Future<void> _load(
    Emitter<FoodCatalogueState> emit, {
    required bool showLoading,
  }) async {
    if (showLoading) emit(FoodCatalogueLoading());
    try {
      final foods = await repository.getAllFoods();
      emit(FoodCatalogueLoaded(foods: foods));
    } catch (e) {
      emit(FoodCatalogueError(e.toString()));
    }
  }

  Future<void> _onDelete(
    DeleteFoodCatalogueEntry event,
    Emitter<FoodCatalogueState> emit,
  ) async {
    try {
      await repository.deleteFood(event.food);
      // The repository change stream triggers a refresh.
    } catch (e) {
      emit(FoodCatalogueError(e.toString()));
    }
  }

  @override
  Future<void> close() async {
    await _changesSubscription?.cancel();
    return super.close();
  }
}
