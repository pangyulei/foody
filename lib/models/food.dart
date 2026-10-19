import '../utils/energy_converter.dart';

/// 纯食物的公共接口。
///
/// 具体分为：
/// - [PremadeFood]：包装食品，按营养成分表记录
/// - [CustomFood]：用户自定义食品，例如一盘菜、一个鸡蛋
abstract interface class Food {
  int get id;

  String get name;

  /// 每份能量 (kJ)
  double get kj;

  /// 每份碳水化合物 (g)
  double get carbs;

  /// 每份蛋白质 (g)
  double get protein;

  /// 每份脂肪 (g)
  double get fat;

  /// 最近一次使用时间
  DateTime get lastUsedTime;
  set lastUsedTime(DateTime value);
}

extension FoodEnergy on Food {
  /// 每份卡路里 (kcal)
  double get calories => EnergyConverter.kjToKcal(kj);
}
