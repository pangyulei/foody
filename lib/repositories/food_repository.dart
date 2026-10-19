import '../models/custom_food.dart';
import '../models/diet_log.dart';
import '../models/food.dart';
import '../models/premade_food.dart';
import '../objectbox.g.dart';
import '../services/objectbox_service.dart';

class FoodRepository {
  final ObjectBoxService _objectBoxService;

  FoodRepository(this._objectBoxService);

  Box<DietLog> get _dietLogBox => _objectBoxService.dietLogBox;

  Box<PremadeFood> get _premadeFoodBox => _objectBoxService.premadeFoodBox;

  Box<CustomFood> get _customFoodBox => _objectBoxService.customFoodBox;

  /// 获取指定日期的进食记录 (00:00:00 至 23:59:59)，时间越靠近的排在前面
  List<DietLog> getDietLogsForDate(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day, 0, 0, 0);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59, 999);

    final query = _dietLogBox.query(
      DietLog_.createTime.betweenDate(startOfDay, endOfDay),
    )..order(DietLog_.createTime, flags: Order.descending);

    final builder = query.build();
    final logs = builder.find();
    builder.close();
    logs.sort((a, b) => b.createTime.compareTo(a.createTime));
    return logs;
  }

  /// 最近使用过的纯食物 (用于快速选择)
  List<Food> getRecentFoods({int limit = 20}) {
    final premadeQuery = _premadeFoodBox.query()
      ..order(PremadeFood_.lastUsedTime, flags: Order.descending);
    final premadeBuilder = premadeQuery.build();
    final premadeFoods = premadeBuilder.find();
    premadeBuilder.close();

    final customQuery = _customFoodBox.query()
      ..order(CustomFood_.lastUsedTime, flags: Order.descending);
    final customBuilder = customQuery.build();
    final customFoods = customBuilder.find();
    customBuilder.close();

    final foods = <Food>[...premadeFoods, ...customFoods]
      ..sort((a, b) => b.lastUsedTime.compareTo(a.lastUsedTime));
    return foods.take(limit).toList();
  }

  /// 保存一条进食记录，同时保存/更新它引用的食物。
  int saveDietLog(DietLog log) {
    final food = log.food;
    final now = DateTime.now();
    if (food is PremadeFood) {
      food.lastUsedTime = now;
      _premadeFoodBox.put(food);
      log.setFood(food);
    } else if (food is CustomFood) {
      food.lastUsedTime = now;
      _customFoodBox.put(food);
      log.setFood(food);
    }

    final id = _dietLogBox.put(log);
    log.id = id;
    return id;
  }

  /// 删除某条进食记录（纯食物保留）
  bool deleteDietLog(int id) {
    return _dietLogBox.remove(id);
  }

  /// 清空记录与食物 (可选功能)
  int deleteAll() {
    _dietLogBox.removeAll();
    _premadeFoodBox.removeAll();
    return _customFoodBox.removeAll();
  }
}
