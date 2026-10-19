import 'package:objectbox/objectbox.dart';

import '../utils/energy_converter.dart';
import 'custom_food.dart';
import 'food.dart';
import 'premade_food.dart';

/// 一次进食记录：引用某个纯食物，加上数量、时间等信息。
@Entity()
class DietLog {
  @Id()
  int id;

  final premadeFood = ToOne<PremadeFood>();

  final customFood = ToOne<CustomFood>();

  /// 食用数量（份数）
  double quantity;

  @Property(type: PropertyType.date)
  DateTime createTime;

  String? note;

  DietLog({
    this.id = 0,
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
  Food? get food => premadeFood.target ?? customFood.target;

  void setFood(Food? food) {
    if (food is PremadeFood) {
      premadeFood.target = food;
      customFood.target = null;
    } else if (food is CustomFood) {
      customFood.target = food;
      premadeFood.target = null;
    } else {
      premadeFood.target = null;
      customFood.target = null;
    }
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
