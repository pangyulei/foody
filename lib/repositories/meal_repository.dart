import 'dart:async';

import 'package:drift/drift.dart';

import '../models/meal.dart';
import '../services/app_database.dart';

/// Handles one-time meal records.
class MealRepository {
  final AppDatabase _db;
  final StreamController<void> _changes = StreamController<void>.broadcast();

  MealRepository(this._db);

  /// Emits after a successful save or delete so pages can refresh.
  Stream<void> get changes => _changes.stream;

  /// Meals for a day, newest first.
  Future<List<Meal>> getMealsForDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59, 999);

    final rows =
        await (_db.select(_db.meals)
              ..where((t) => t.createTime.isBetweenValues(startOfDay, endOfDay))
              ..orderBy([(t) => OrderingTerm.desc(t.createTime)]))
            .get();

    return rows.map(_mapRow).toList();
  }

  /// All meals, newest first.
  Future<List<Meal>> getAllMeals() async {
    final rows = await (_db.select(
      _db.meals,
    )..orderBy([(t) => OrderingTerm.desc(t.createTime)])).get();
    return rows.map(_mapRow).toList();
  }

  /// Notifies listeners after an external data replacement (backup import).
  void notifyChanged() => _changes.add(null);

  /// Every day that has meals, newest day first. Each inner list contains
  /// that day's meals in newest-first order.
  Future<List<List<Meal>>> getMealsByDay() async {
    final rows = await (_db.select(
      _db.meals,
    )..orderBy([(t) => OrderingTerm.desc(t.createTime)])).get();

    final mealsByDay = <DateTime, List<Meal>>{};
    for (final row in rows) {
      final meal = _mapRow(row);
      final day = DateTime(
        meal.createTime.year,
        meal.createTime.month,
        meal.createTime.day,
      );
      mealsByDay.putIfAbsent(day, () => <Meal>[]).add(meal);
    }

    final days = mealsByDay.keys.toList()..sort((a, b) => b.compareTo(a));
    return days.map((day) => mealsByDay[day]!).toList();
  }

  Meal _mapRow(MealRow row) {
    return Meal(
      id: row.id,
      foodName: row.foodName,
      kj: row.kj,
      carbs: row.carbs,
      protein: row.protein,
      fat: row.fat,
      rawFoodSource: row.rawFoodSource,
      netContent: row.netContent,
      basisAmount: row.basisAmount,
      unitName: row.unitName,
      quantity: row.quantity,
      createTime: row.createTime,
      note: row.note,
    );
  }

  /// Saves a meal. The meal already contains a snapshot of the food.
  Future<int> saveMeal(Meal meal) async {
    final values = MealsCompanion(
      foodName: Value(meal.foodName),
      kj: Value(meal.kj),
      carbs: Value(meal.carbs),
      protein: Value(meal.protein),
      fat: Value(meal.fat),
      rawFoodSource: Value(meal.rawFoodSource),
      netContent: Value(meal.netContent),
      basisAmount: Value(meal.basisAmount),
      unitName: Value(meal.unitName),
      quantity: Value(meal.quantity),
      createTime: Value(meal.createTime),
      note: Value(meal.note),
    );

    if (meal.id > 0) {
      await (_db.update(
        _db.meals,
      )..where((t) => t.id.equals(meal.id))).write(values);
      _changes.add(null);
      return meal.id;
    }

    final id = await _db.into(_db.meals).insert(values);
    meal.id = id;
    _changes.add(null);
    return id;
  }

  /// Deletes a meal. Food catalogue entries are not touched.
  Future<bool> deleteMeal(int id) async {
    final count = await (_db.delete(
      _db.meals,
    )..where((t) => t.id.equals(id))).go();
    if (count > 0) _changes.add(null);
    return count > 0;
  }

  Future<void> dispose() => _changes.close();
}
