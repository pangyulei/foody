import 'package:drift/drift.dart';

import '../models/custom_food.dart';
import '../models/food.dart';
import '../models/premade_food.dart';
import '../services/app_database.dart';

/// Handles the pure food catalogue (premade and custom foods).
class FoodRepository {
  final AppDatabase _db;

  FoodRepository(this._db);

  /// Recently used pure foods, for the quick-add selector.
  Future<List<Food>> getRecentFoods({int limit = 20}) async {
    final premadeRows = await (_db.select(
      _db.premadeFoods,
    )..orderBy([(t) => OrderingTerm.desc(t.lastUsedTime)])).get();
    final customRows = await (_db.select(
      _db.customFoods,
    )..orderBy([(t) => OrderingTerm.desc(t.lastUsedTime)])).get();

    final foods = <Food>[
      ...premadeRows.map(PremadeFood.fromRow),
      ...customRows.map(CustomFood.fromRow),
    ]..sort((a, b) => b.lastUsedTime.compareTo(a.lastUsedTime));
    return foods.take(limit).toList();
  }

  /// Inserts a new food or updates an existing one, returning its id.
  Future<int> saveFood(Food food) {
    if (food is PremadeFood) {
      return _savePremadeFood(food);
    }
    if (food is CustomFood) {
      return _saveCustomFood(food);
    }
    throw ArgumentError('Unsupported food type: ${food.runtimeType}');
  }

  Future<int> _savePremadeFood(PremadeFood food) async {
    final values = PremadeFoodsCompanion(
      name: Value(food.name),
      kj: Value(food.kj),
      carbs: Value(food.carbs),
      protein: Value(food.protein),
      fat: Value(food.fat),
      servingAmount: Value(food.servingAmount),
      basisAmount: Value(food.basisAmount),
      unitName: Value(food.unitName),
      lastUsedTime: Value(food.lastUsedTime),
    );

    if (food.id > 0) {
      await (_db.update(
        _db.premadeFoods,
      )..where((t) => t.id.equals(food.id))).write(values);
      return food.id;
    }

    final id = await _db.into(_db.premadeFoods).insert(values);
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
      await (_db.update(
        _db.customFoods,
      )..where((t) => t.id.equals(food.id))).write(values);
      return food.id;
    }

    final id = await _db.into(_db.customFoods).insert(values);
    food.id = id;
    return id;
  }
}
