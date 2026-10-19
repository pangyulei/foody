import '../models/food_entry.dart';
import '../objectbox.g.dart';
import '../services/objectbox_service.dart';

class FoodRepository {
  final ObjectBoxService _objectBoxService;

  FoodRepository(this._objectBoxService);

  Box<FoodEntry> get _box => _objectBoxService.foodBox;

  /// 获取所有饮食记录 (按时间倒序)
  List<FoodEntry> getAllFoodEntries() {
    final query = _box.query()
      ..order(FoodEntry_.createTime, flags: Order.descending);
    final builder = query.build();
    final entries = builder.find();
    builder.close();
    return entries;
  }

  /// 获取指定日期的饮食记录 (00:00:00 至 23:59:59)
  List<FoodEntry> getFoodEntriesForDate(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day, 0, 0, 0);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59, 999);

    final query = _box.query(
      FoodEntry_.createTime.betweenDate(startOfDay, endOfDay),
    )..order(FoodEntry_.createTime, flags: Order.descending);

    final builder = query.build();
    final entries = builder.find();
    builder.close();
    return entries;
  }

  /// 获取历史记录过的去重食品列表 (用于快速选择)
  List<FoodEntry> getRecentUniqueFoods({int limit = 20}) {
    final query = _box.query()
      ..order(FoodEntry_.createTime, flags: Order.descending);
    final builder = query.build();
    final allEntries = builder.find();
    builder.close();

    final uniqueMap = <String, FoodEntry>{};
    for (final entry in allEntries) {
      final nameKey = entry.name.trim();
      if (nameKey.isNotEmpty && !uniqueMap.containsKey(nameKey)) {
        uniqueMap[nameKey] = entry;
      }
      if (uniqueMap.length >= limit) break;
    }

    return uniqueMap.values.toList();
  }

  /// 添加或更新饮食记录
  int saveFoodEntry(FoodEntry entry) {
    return _box.put(entry);
  }

  /// 删除某条饮食记录
  bool deleteFoodEntry(int id) {
    return _box.remove(id);
  }

  /// 清空记录 (可选功能)
  int deleteAll() {
    return _box.removeAll();
  }
}
