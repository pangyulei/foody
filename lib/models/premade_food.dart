import 'package:objectbox/objectbox.dart';

import 'food.dart';

/// 包装食品：带有营养成分表、按“基准份量”标注营养数值的食物。
@Entity()
class PremadeFood implements Food {
  @Id()
  @override
  int id;

  @override
  String name;

  /// 每份能量 (kJ)
  @override
  double kj;

  /// 每份碳水化合物 (g)
  @override
  double carbs;

  /// 每份蛋白质 (g)
  @override
  double protein;

  /// 每份脂肪 (g)
  @override
  double fat;

  /// 单份容量/重量（例如 200）
  double servingAmount;

  /// 成分表基准份量（例如 100）
  double basisAmount;

  /// 计量单位：ml / g / 份
  String unitName;

  @override
  @Property(type: PropertyType.date)
  DateTime lastUsedTime;

  PremadeFood({
    this.id = 0,
    required this.name,
    required this.kj,
    required this.carbs,
    required this.protein,
    required this.fat,
    this.servingAmount = 100,
    this.basisAmount = 100,
    this.unitName = 'ml',
    DateTime? lastUsedTime,
  }) : lastUsedTime = lastUsedTime ?? DateTime.now();
}
