import 'dart:async';

import 'package:drift/drift.dart';

import '../models/custom_food.dart';
import '../models/food.dart';
import '../models/packaged_food.dart';
import '../services/app_database.dart';

/// Handles the pure food catalogue (packaged and custom foods).
class FoodRepository {
  final AppDatabase _db;
  final StreamController<void> _changes = StreamController<void>.broadcast();

  FoodRepository(this._db);

  /// Emits after a food is saved or deleted so the catalogue can refresh.
  Stream<void> get changes => _changes.stream;

  /// Notifies listeners after an external data replacement (backup import).
  void notifyChanged() => _changes.add(null);

  /// All pure foods in the catalogue, newest first.
  Future<List<Food>> getAllFoods() async {
    final packagedRows = await (_db.select(
      _db.packagedFoods,
    )..orderBy([(t) => OrderingTerm.desc(t.lastUsedTime)])).get();
    final customRows = await (_db.select(_db.customFoods)..orderBy([(t) => OrderingTerm.desc(t.lastUsedTime)])).get();

    return <Food>[...packagedRows.map(PackagedFood.fromRow), ...customRows.map(CustomFood.fromRow)]
      ..sort((a, b) => b.lastUsedTime.compareTo(a.lastUsedTime));
  }

  /// Recently used pure foods, for the quick-add selector.
  Future<List<Food>> getQuickAddFoods({int limit = 20}) async {
    final foods = await getAllFoods();
    return foods.take(limit).toList();
  }

  /// Inserts a new food or updates an existing one, returning its id.
  Future<int> saveFood(Food food) async {
    final id = switch (food) {
      PackagedFood() => await _savePackagedFood(food),
      CustomFood() => await _saveCustomFood(food),
      _ => throw ArgumentError('Unsupported food type: ${food.runtimeType}'),
    };
    _changes.add(null);
    return id;
  }

  /// Deletes a food from the catalogue. Diet meals keep their snapshots.
  Future<bool> deleteFood(Food food) async {
    final count = switch (food) {
      PackagedFood() => await (_db.delete(_db.packagedFoods)..where((t) => t.id.equals(food.id))).go(),
      CustomFood() => await (_db.delete(_db.customFoods)..where((t) => t.id.equals(food.id))).go(),
      _ => throw ArgumentError('Unsupported food type: ${food.runtimeType}'),
    };
    if (count > 0) _changes.add(null);
    return count > 0;
  }

  Future<void> dispose() => _changes.close();

  Future<int> _savePackagedFood(PackagedFood food) async {
    final values = PackagedFoodsCompanion(
      name: Value(food.name),
      kj: Value(food.kj),
      carbs: Value(food.carbs),
      protein: Value(food.protein),
      fat: Value(food.fat),
      netContent: Value(food.netContent),
      basisAmount: Value(food.basisAmount),
      unitName: Value(food.unitName),
      lastUsedTime: Value(food.lastUsedTime),
    );

    if (food.id > 0) {
      await (_db.update(_db.packagedFoods)..where((t) => t.id.equals(food.id))).write(values);
      return food.id;
    }

    final id = await _db.into(_db.packagedFoods).insert(values);
    food.id = id;
    return id;
  }

  Future<int> _saveCustomFood(CustomFood food) async {
    final values = CustomFoodsCompanion(
      name: Value(food.name),
      kj: Value(food.kj),
      carbs: Value(food.carbs),
      protein: Value(food.protein),
      fat: Value(food.fat),
      lastUsedTime: Value(food.lastUsedTime),
    );

    if (food.id > 0) {
      await (_db.update(_db.customFoods)..where((t) => t.id.equals(food.id))).write(values);
      return food.id;
    }

    final id = await _db.into(_db.customFoods).insert(values);
    food.id = id;
    return id;
  }
}
