import 'dart:async';

import 'package:drift/drift.dart';

import '../models/daily_log_summary.dart';
import '../models/diet_log.dart';
import '../services/app_database.dart';

/// Handles one-time eating records (diet logs).
class DietLogRepository {
  final AppDatabase _db;
  final StreamController<void> _changes = StreamController<void>.broadcast();

  DietLogRepository(this._db);

  /// Emits after a successful save or delete so pages can refresh.
  Stream<void> get changes => _changes.stream;

  /// Diet logs for a day, newest first.
  Future<List<DietLog>> getDietLogsForDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59, 999);

    final rows =
        await (_db.select(_db.dietLogs)
              ..where((t) => t.createTime.isBetweenValues(startOfDay, endOfDay))
              ..orderBy([(t) => OrderingTerm.desc(t.createTime)]))
            .get();

    return rows.map(_mapRow).toList();
  }

  /// Every day that has diet logs, newest first, with daily totals.
  Future<List<DailyLogSummary>> getDailySummaries() async {
    final rows = await (_db.select(
      _db.dietLogs,
    )..orderBy([(t) => OrderingTerm.desc(t.createTime)])).get();

    final logsByDay = <DateTime, List<DietLog>>{};
    for (final row in rows) {
      final log = _mapRow(row);
      final day = DateTime(
        log.createTime.year,
        log.createTime.month,
        log.createTime.day,
      );
      logsByDay.putIfAbsent(day, () => <DietLog>[]).add(log);
    }

    final days = logsByDay.keys.toList()..sort((a, b) => b.compareTo(a));
    return days
        .map((day) => DailyLogSummary.fromLogs(day, logsByDay[day]!))
        .toList();
  }

  DietLog _mapRow(DietLogRow row) {
    return DietLog(
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

  /// Saves a diet log. The log already contains a snapshot of the food.
  Future<int> saveDietLog(DietLog log) async {
    final values = DietLogsCompanion(
      foodName: Value(log.foodName),
      kj: Value(log.kj),
      carbs: Value(log.carbs),
      protein: Value(log.protein),
      fat: Value(log.fat),
      rawFoodSource: Value(log.rawFoodSource),
      netContent: Value(log.netContent),
      basisAmount: Value(log.basisAmount),
      unitName: Value(log.unitName),
      quantity: Value(log.quantity),
      createTime: Value(log.createTime),
      note: Value(log.note),
    );

    if (log.id > 0) {
      await (_db.update(
        _db.dietLogs,
      )..where((t) => t.id.equals(log.id))).write(values);
      _changes.add(null);
      return log.id;
    }

    final id = await _db.into(_db.dietLogs).insert(values);
    log.id = id;
    _changes.add(null);
    return id;
  }

  /// Deletes a diet log. Food catalogue entries are not touched.
  Future<bool> deleteDietLog(int id) async {
    final count = await (_db.delete(
      _db.dietLogs,
    )..where((t) => t.id.equals(id))).go();
    if (count > 0) _changes.add(null);
    return count > 0;
  }

  Future<void> dispose() => _changes.close();
}
