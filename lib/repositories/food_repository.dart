import 'package:drift/drift.dart';

import '../models/custom_food.dart';
import '../models/diet_log.dart';
import '../models/food.dart';
import '../models/premade_food.dart';
import '../services/app_database.dart';

class FoodRepository {
  final AppDatabase _db;

  FoodRepository(this._db);

  /// 获取指定日期的进食记录，时间越靠近的排在前面
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
        premadeFood: premadeRow == null ? null : _mapPremadeFood(premadeRow),
        customFood: customRow == null ? null : _mapCustomFood(customRow),
        quantity: logRow.quantity,
        createTime: logRow.createTime,
        note: logRow.note,
      );
    }).toList();
  }

  /// 最近使用过的纯食物 (用于快速选择)
  Future<List<Food>> getRecentFoods({int limit = 20}) async {
    final premadeRows = await (_db.select(
      _db.premadeFoods,
    )..orderBy([(t) => OrderingTerm.desc(t.lastUsedTime)])).get();
    final customRows = await (_db.select(
      _db.customFoods,
    )..orderBy([(t) => OrderingTerm.desc(t.lastUsedTime)])).get();

    final foods = <Food>[
      ...premadeRows.map(_mapPremadeFood),
      ...customRows.map(_mapCustomFood),
    ]..sort((a, b) => b.lastUsedTime.compareTo(a.lastUsedTime));
    return foods.take(limit).toList();
  }

  /// 保存一条进食记录，同时保存/更新它引用的食物。
  Future<int> saveDietLog(DietLog log) async {
    int? premadeFoodId;
    int? customFoodId;
    final food = log.food;
    final now = DateTime.now();

    if (food is PremadeFood) {
      food.lastUsedTime = now;
      premadeFoodId = await _savePremadeFood(food);
    } else if (food is CustomFood) {
      food.lastUsedTime = now;
      customFoodId = await _saveCustomFood(food);
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

  /// 删除某条进食记录（纯食物保留）
  Future<bool> deleteDietLog(int id) async {
    final count = await (_db.delete(
      _db.dietLogs,
    )..where((t) => t.id.equals(id))).go();
    return count > 0;
  }

  /// 清空记录与食物 (可选功能)
  Future<void> deleteAll() async {
    await _db.transaction(() async {
      await _db.delete(_db.dietLogs).go();
      await _db.delete(_db.premadeFoods).go();
      await _db.delete(_db.customFoods).go();
    });
  }

  PremadeFood _mapPremadeFood(PremadeFoodRow row) {
    return PremadeFood(
      id: row.id,
      name: row.name,
      kj: row.kj,
      carbs: row.carbs,
      protein: row.protein,
      fat: row.fat,
      servingAmount: row.servingAmount,
      basisAmount: row.basisAmount,
      unitName: row.unitName,
      lastUsedTime: row.lastUsedTime,
    );
  }

  CustomFood _mapCustomFood(CustomFoodRow row) {
    return CustomFood(
      id: row.id,
      name: row.name,
      kj: row.kj,
      carbs: row.carbs,
      protein: row.protein,
      fat: row.fat,
      lastUsedTime: row.lastUsedTime,
    );
  }
}
