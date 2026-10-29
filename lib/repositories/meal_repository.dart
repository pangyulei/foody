import 'dart:async';

import 'package:drift/drift.dart';

import '../models/custom_food.dart';
import '../models/daily_summary.dart';
import '../models/meal.dart';
import '../models/packaged_food.dart';
import '../services/app_database.dart';
import 'daily_summary_repository.dart';

/// Handles one-time meal records linked to catalogue foods.
class MealRepository {
  final AppDatabase _db;
  final DailySummaryRepository _summaries;
  final StreamController<void> _changes = StreamController<void>.broadcast();

  MealRepository(this._db) : _summaries = DailySummaryRepository(_db);

  /// Emits after a successful save or delete so pages can refresh.
  Stream<void> get changes => _changes.stream;

  JoinedSelectStatement<HasResultSet, dynamic> _packagedMealsQuery() {
    return _db.select(_db.packagedMeals).join([
      innerJoin(
        _db.packagedFoods,
        _db.packagedFoods.id.equalsExp(_db.packagedMeals.packagedFoodId),
      ),
    ]);
  }

  JoinedSelectStatement<HasResultSet, dynamic> _customMealsQuery() {
    return _db.select(_db.customMeals).join([
      innerJoin(
        _db.customFoods,
        _db.customFoods.id.equalsExp(_db.customMeals.customFoodId),
      ),
    ]);
  }

  Future<List<Meal>> _loadMeals({
    DateTime? startOfDay,
    DateTime? endOfDay,
  }) async {
    final packagedQuery = _packagedMealsQuery();
    final customQuery = _customMealsQuery();

    if (startOfDay != null && endOfDay != null) {
      packagedQuery.where(
        _db.packagedMeals.createTime.isBetweenValues(startOfDay, endOfDay),
      );
      customQuery.where(
        _db.customMeals.createTime.isBetweenValues(startOfDay, endOfDay),
      );
    }

    final packagedRows = await packagedQuery.get();
    final customRows = await customQuery.get();

    final meals = <Meal>[
      for (final row in packagedRows)
        PackagedMeal(
          id: row.readTable(_db.packagedMeals).id,
          food: PackagedFood.fromRow(row.readTable(_db.packagedFoods)),
          quantity: row.readTable(_db.packagedMeals).quantity,
          createTime: row.readTable(_db.packagedMeals).createTime,
          note: row.readTable(_db.packagedMeals).note,
        ),
      for (final row in customRows)
        CustomMeal(
          id: row.readTable(_db.customMeals).id,
          food: CustomFood.fromRow(row.readTable(_db.customFoods)),
          netContent: row.readTable(_db.customMeals).netContent,
          createTime: row.readTable(_db.customMeals).createTime,
          note: row.readTable(_db.customMeals).note,
        ),
    ];

    // Newest first, ordered down to the second. Meals recorded within the
    // same second fall back to the id so the order stays stable.
    meals.sort((a, b) {
      final byTime = b.createTime.compareTo(a.createTime);
      if (byTime != 0) return byTime;
      final byType = a.runtimeType.toString().compareTo(
        b.runtimeType.toString(),
      );
      if (byType != 0) return byType;
      return b.id.compareTo(a.id);
    });
    return meals;
  }

  /// Meals for a day, newest first.
  Future<List<Meal>> getMealsForDate(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
    return _loadMeals(startOfDay: startOfDay, endOfDay: endOfDay);
  }

  /// All meals, newest first.
  Future<List<Meal>> getAllMeals() => _loadMeals();

  /// Materialized per-day totals used by the History list.
  Future<List<DailySummary>> getDailySummaries() => _summaries.getAll();

  /// Rebuilds every daily summary row from the meal tables.
  Future<void> rebuildDailySummaries() => _summaries.rebuildAll();

  /// Notifies listeners after an external data replacement (backup import).
  void notifyChanged() => _changes.add(null);

  /// Every day that has meals, newest day first. Each inner list contains
  /// that day's meals in newest-first order.
  Future<List<List<Meal>>> getMealsByDay() async {
    final meals = await _loadMeals();

    final mealsByDay = <DateTime, List<Meal>>{};
    for (final meal in meals) {
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

  /// Saves a meal. The referenced food must already be stored.
  Future<int> saveMeal(Meal meal) async {
    if (meal.food.id <= 0) {
      throw ArgumentError('Save the meal food before saving the meal');
    }

    final previousDay = meal.id > 0 ? await _existingMealDay(meal) : null;

    final id = await _db.transaction(() async {
      switch (meal) {
        case PackagedMeal():
          final values = PackagedMealsCompanion(
            packagedFoodId: Value(meal.food.id),
            quantity: Value(meal.quantity),
            createTime: Value(meal.createTime),
            note: Value(meal.note),
          );
          if (meal.id > 0) {
            await (_db.update(
              _db.packagedMeals,
            )..where((t) => t.id.equals(meal.id))).write(values);
          } else {
            meal.id = await _db.into(_db.packagedMeals).insert(values);
          }
        case CustomMeal():
          final values = CustomMealsCompanion(
            customFoodId: Value(meal.food.id),
            netContent: Value(meal.netContent),
            createTime: Value(meal.createTime),
            note: Value(meal.note),
          );
          if (meal.id > 0) {
            await (_db.update(
              _db.customMeals,
            )..where((t) => t.id.equals(meal.id))).write(values);
          } else {
            meal.id = await _db.into(_db.customMeals).insert(values);
          }
      }

      await _summaries.refreshDays([meal.createTime, ?previousDay]);
      return meal.id;
    });

    _changes.add(null);
    return id;
  }

  /// Deletes a meal. Food catalogue entries are not touched.
  Future<bool> deleteMeal(Meal meal) async {
    final day = await _existingMealDay(meal);

    final count = await _db.transaction(() async {
      final count = switch (meal) {
        PackagedMeal() => await (_db.delete(
          _db.packagedMeals,
        )..where((t) => t.id.equals(meal.id))).go(),
        CustomMeal() => await (_db.delete(
          _db.customMeals,
        )..where((t) => t.id.equals(meal.id))).go(),
      };
      if (count > 0 && day != null) {
        await _summaries.refreshDay(day);
      }
      return count;
    });

    if (count > 0) _changes.add(null);
    return count > 0;
  }

  Future<DateTime?> _existingMealDay(Meal meal) async {
    if (meal.id <= 0) return null;
    switch (meal) {
      case PackagedMeal():
        final row = await (_db.select(
          _db.packagedMeals,
        )..where((t) => t.id.equals(meal.id))).getSingleOrNull();
        return row?.createTime;
      case CustomMeal():
        final row = await (_db.select(
          _db.customMeals,
        )..where((t) => t.id.equals(meal.id))).getSingleOrNull();
        return row?.createTime;
    }
  }

  Future<void> dispose() => _changes.close();
}
