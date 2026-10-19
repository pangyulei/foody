import 'package:drift/drift.dart';

import '../models/custom_food.dart';
import '../models/diet_log.dart';
import '../models/premade_food.dart';
import '../services/app_database.dart';
import 'food_repository.dart';

/// Handles one-time eating records (diet logs).
class DietLogRepository {
  final AppDatabase _db;
  final FoodRepository _foodRepository;

  DietLogRepository(this._db, this._foodRepository);

  /// Diet logs for a day, newest first.
  Future<List<DietLog>> getDietLogsForDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59, 999);

    final query =
        _db.select(_db.dietLogs).join([
            leftOuterJoin(
              _db.premadeFoods,
              _db.premadeFoods.id.equalsExp(_db.dietLogs.premadeFoodId),
            ),
            leftOuterJoin(
              _db.customFoods,
              _db.customFoods.id.equalsExp(_db.dietLogs.customFoodId),
            ),
          ])
          ..where(_db.dietLogs.createTime.isBetweenValues(startOfDay, endOfDay))
          ..orderBy([OrderingTerm.desc(_db.dietLogs.createTime)]);

    final rows = await query.get();
    return rows.map((row) {
      final logRow = row.readTable(_db.dietLogs);
      final premadeRow = row.readTableOrNull(_db.premadeFoods);
      final customRow = row.readTableOrNull(_db.customFoods);
      return DietLog(
        id: logRow.id,
        premadeFood: premadeRow == null
            ? null
            : PremadeFood.fromRow(premadeRow),
        customFood: customRow == null ? null : CustomFood.fromRow(customRow),
        quantity: logRow.quantity,
        createTime: logRow.createTime,
        note: logRow.note,
      );
    }).toList();
  }

  /// Saves a diet log and its referenced food.
  Future<int> saveDietLog(DietLog log) async {
    int? premadeFoodId;
    int? customFoodId;
    final food = log.food;
    final now = DateTime.now();

    if (food is PremadeFood) {
      food.lastUsedTime = now;
      premadeFoodId = await _foodRepository.saveFood(food);
    } else if (food is CustomFood) {
      food.lastUsedTime = now;
      customFoodId = await _foodRepository.saveFood(food);
    }

    final values = DietLogsCompanion(
      premadeFoodId: Value(premadeFoodId),
      customFoodId: Value(customFoodId),
      quantity: Value(log.quantity),
      createTime: Value(log.createTime),
      note: Value(log.note),
    );

    if (log.id > 0) {
      await (_db.update(
        _db.dietLogs,
      )..where((t) => t.id.equals(log.id))).write(values);
      return log.id;
    }

    final id = await _db.into(_db.dietLogs).insert(values);
    log.id = id;
    return id;
  }

  /// Deletes a diet log; the referenced pure food is kept.
  Future<bool> deleteDietLog(int id) async {
    final count = await (_db.delete(
      _db.dietLogs,
    )..where((t) => t.id.equals(id))).go();
    return count > 0;
  }
}
