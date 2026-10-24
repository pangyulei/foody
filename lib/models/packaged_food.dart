import '../services/app_database.dart';
import 'food.dart';

/// 包装食品：带有营养成分表、按“基准份量”标注营养数值的食物。
class PackagedFood extends Food {
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

  /// 净含量（例如 200）
  double netContent;

  /// 成分表基准份量（例如 100）
  @override
  double basisAmount;

  /// 计量单位：ml / g / 份
  @override
  String unitName;

  @override
  DateTime lastUsedTime;

  PackagedFood({
    this.id = 0,
    required this.name,
    required this.kj,
    required this.carbs,
    required this.protein,
    required this.fat,
    this.netContent = 100,
    this.basisAmount = 100,
    this.unitName = 'ml',
    DateTime? lastUsedTime,
  }) : lastUsedTime = lastUsedTime ?? DateTime.now();

  factory PackagedFood.fromRow(PackagedFoodRow row) {
    return PackagedFood(
      id: row.id,
      name: row.name,
      kj: row.kj,
      carbs: row.carbs,
      protein: row.protein,
      fat: row.fat,
      netContent: row.netContent,
      basisAmount: row.basisAmount,
      unitName: row.unitName,
      lastUsedTime: row.lastUsedTime,
    );
  }
}
