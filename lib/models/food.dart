import '../utils/energy_converter.dart';

/// 纯食物的公共基类。
///
/// 具体分为：
/// - [PackagedFood]：包装食品，营养数值按净含量一份记录
/// - [CustomFood]：用户自定义食品，营养数值按 100 ml/g 记录
abstract class Food {
  int get id;
  set id(int value);

  String get name;

  /// 能量 (kJ)。包装食品按净含量一份；自定义食品按 100 ml/g。
  double get kj;

  /// 碳水化合物 (g)。包装食品按净含量一份；自定义食品按 100 ml/g。
  double get carbs;

  /// 蛋白质 (g)。包装食品按净含量一份；自定义食品按 100 ml/g。
  double get protein;

  /// 脂肪 (g)。包装食品按净含量一份；自定义食品按 100 ml/g。
  double get fat;

  /// 成分表基准份量。自定义食品固定为 100。
  double get basisAmount;

  /// 计量单位：ml / g
  String get unitName;

  /// 最近一次使用时间
  DateTime get lastUsedTime;
  set lastUsedTime(DateTime value);
}

extension FoodEnergy on Food {
  /// 每份卡路里 (kcal)
  double get calories => EnergyConverter.kjToKcal(kj);
}
