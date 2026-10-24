import 'package:drift/drift.dart';

import '../models/custom_food.dart';
import '../models/daily_summary.dart';
import '../models/food.dart';
import '../models/packaged_food.dart';
import '../services/app_database.dart';

/// Maintains the materialized per-day nutrition totals.
class DailySummaryRepository {
  final AppDatabase _db;

  DailySummaryRepository(this._db);

  /// All summaries, newest day first.
  Future<List<DailySummary>> getAll() async {
    final rows = await (_db.select(
      _db.dailySummaries,
    )..orderBy([(t) => OrderingTerm.desc(t.day)])).get();
    return rows.map(_mapRow).toList();
  }

  /// Recomputes and stores the totals for one local calendar day.
  Future<void> refreshDay(DateTime date) async {
    final day = DateTime(date.year, date.month, date.day);
    final startOfDay = day;
    final endOfDay = DateTime(day.year, day.month, day.day, 23, 59, 59, 999);
    final variables = [
      Variable.withDateTime(startOfDay),
      Variable.withDateTime(endOfDay),
    ];

    final packaged = await _db
        .customSelect(_packagedTotalsSql, variables: variables)
        .getSingle();
    final custom = await _db
        .customSelect(_customTotalsSql, variables: variables)
        .getSingle();

    final mealCount =
        packaged.read<int>('meal_count') + custom.read<int>('meal_count');

    if (mealCount == 0) {
      await (_db.delete(
        _db.dailySummaries,
      )..where((t) => t.day.equals(_dayKey(day)))).go();
      return;
    }

    await _db
        .into(_db.dailySummaries)
        .insertOnConflictUpdate(
          DailySummariesCompanion.insert(
            day: _dayKey(day),
            totalKj:
                packaged.read<double>('total_kj') +
                custom.read<double>('total_kj'),
            totalCarbs:
                packaged.read<double>('total_carbs') +
                custom.read<double>('total_carbs'),
            totalProtein:
                packaged.read<double>('total_protein') +
                custom.read<double>('total_protein'),
            totalFat:
                packaged.read<double>('total_fat') +
                custom.read<double>('total_fat'),
            mealCount: mealCount,
          ),
        );
  }

  /// Recomputes the totals for every distinct day in [dates].
  Future<void> refreshDays(Iterable<DateTime> dates) async {
    final days = <String, DateTime>{};
    for (final date in dates) {
      final day = DateTime(date.year, date.month, date.day);
      days[_dayKey(day)] = day;
    }
    for (final day in days.values) {
      await refreshDay(day);
    }
  }

  /// Recomputes every day that references [food].
  Future<void> refreshDaysForFood(Food food) async {
    final days = <DateTime>[];
    switch (food) {
      case PackagedFood():
        final rows = await (_db.select(
          _db.packagedMeals,
        )..where((t) => t.packagedFoodId.equals(food.id))).get();
        days.addAll(rows.map((row) => row.createTime));
      case CustomFood():
        final rows = await (_db.select(
          _db.customMeals,
        )..where((t) => t.customFoodId.equals(food.id))).get();
        days.addAll(rows.map((row) => row.createTime));
    }
    await refreshDays(days);
  }

  /// Drops and rebuilds every summary row.
  Future<void> rebuildAll() async {
    await _db.delete(_db.dailySummaries).go();

    final days = <DateTime>[];
    final packaged = await _db.select(_db.packagedMeals).get();
    days.addAll(packaged.map((row) => row.createTime));
    final custom = await _db.select(_db.customMeals).get();
    days.addAll(custom.map((row) => row.createTime));

    await refreshDays(days);
  }

  DailySummary _mapRow(DailySummaryRow row) {
    return DailySummary(
      day: _parseDay(row.day),
      totalKj: row.totalKj,
      totalCarbs: row.totalCarbs,
      totalProtein: row.totalProtein,
      totalFat: row.totalFat,
      mealCount: row.mealCount,
    );
  }

  static const _packagedTotalsSql = '''
    SELECT
      COUNT(*) AS meal_count,
      CAST(COALESCE(SUM(f.kj * m.quantity), 0) AS REAL) AS total_kj,
      CAST(COALESCE(SUM(f.carbs * m.quantity), 0) AS REAL) AS total_carbs,
      CAST(COALESCE(SUM(f.protein * m.quantity), 0) AS REAL) AS total_protein,
      CAST(COALESCE(SUM(f.fat * m.quantity), 0) AS REAL) AS total_fat
    FROM packaged_meals m
    JOIN packaged_foods f ON f.id = m.packaged_food_id
    WHERE m.create_time BETWEEN ? AND ?
  ''';

  static const _customTotalsSql = '''
    SELECT
      COUNT(*) AS meal_count,
      CAST(COALESCE(SUM(f.kj * m.net_content /
        CASE WHEN f.basis_amount > 0 THEN f.basis_amount ELSE 100 END), 0)
        AS REAL) AS total_kj,
      CAST(COALESCE(SUM(f.carbs * m.net_content /
        CASE WHEN f.basis_amount > 0 THEN f.basis_amount ELSE 100 END), 0)
        AS REAL) AS total_carbs,
      CAST(COALESCE(SUM(f.protein * m.net_content /
        CASE WHEN f.basis_amount > 0 THEN f.basis_amount ELSE 100 END), 0)
        AS REAL) AS total_protein,
      CAST(COALESCE(SUM(f.fat * m.net_content /
        CASE WHEN f.basis_amount > 0 THEN f.basis_amount ELSE 100 END), 0)
        AS REAL) AS total_fat
    FROM custom_meals m
    JOIN custom_foods f ON f.id = m.custom_food_id
    WHERE m.create_time BETWEEN ? AND ?
  ''';

  String _dayKey(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  DateTime _parseDay(String value) {
    final parts = value.split('-');
    return DateTime(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
  }
}
