import '../utils/energy_converter.dart';
import 'custom_food.dart';
import 'food.dart';
import 'premade_food.dart';

/// 一次进食记录：引用某个纯食物，加上数量、时间等信息。
class DietLog {
  int id;

  PremadeFood? premadeFood;

  CustomFood? customFood;

  /// 食用数量（份数）
  double quantity;

  DateTime createTime;

  String? note;

  DietLog({
    this.id = 0,
    this.premadeFood,
    this.customFood,
    this.quantity = 1.0,
    required this.createTime,
    this.note,
  });

  /// 创建一条引用纯食物的进食记录。
  factory DietLog.withFood({
    int id = 0,
    required Food food,
    double quantity = 1.0,
    required DateTime createTime,
    String? note,
  }) {
    final log = DietLog(
      id: id,
      quantity: quantity,
      createTime: createTime,
      note: note,
    );
    log.setFood(food);
    return log;
  }

  /// 当前引用的纯食物（包装食品或自定义食品）
  Food? get food => premadeFood ?? customFood;

  void setFood(Food? food) {
    premadeFood = food is PremadeFood ? food : null;
    customFood = food is CustomFood ? food : null;
  }

  /// 本次摄入能量 (kJ)
  double get kj => (food?.kj ?? 0) * quantity;

  /// 本次摄入卡路里 (kcal)
  double get calories => EnergyConverter.kjToKcal(kj);

  /// 本次摄入碳水化合物 (g)
  double get carbs => (food?.carbs ?? 0) * quantity;

  /// 本次摄入蛋白质 (g)
  double get protein => (food?.protein ?? 0) * quantity;

  /// 本次摄入脂肪 (g)
  double get fat => (food?.fat ?? 0) * quantity;
}
