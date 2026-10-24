import '../services/app_database.dart';
import 'food.dart';

/// 用户自定义食品：例如一盘菜、一个鸡蛋。
/// 营养成分固定按 100 ml/g（[basisAmount]）记录。
class CustomFood extends Food {
  @override
  int id;

  @override
  String name;

  /// 每 100 ml/g 能量 (kJ)
  @override
  double kj;

  /// 每 100 ml/g 碳水化合物 (g)
  @override
  double carbs;

  /// 每 100 ml/g 蛋白质 (g)
  @override
  double protein;

  /// 每 100 ml/g 脂肪 (g)
  @override
  double fat;

  /// 成分表基准份量（固定为 100）
  @override
  double basisAmount;

  /// 计量单位：ml / g
  @override
  String unitName;

  @override
  DateTime lastUsedTime;

  CustomFood({
    this.id = 0,
    required this.name,
    required this.kj,
    required this.carbs,
    required this.protein,
    required this.fat,
    this.basisAmount = 100,
    this.unitName = 'g',
    DateTime? lastUsedTime,
  }) : lastUsedTime = lastUsedTime ?? DateTime.now();

  factory CustomFood.fromRow(CustomFoodRow row) {
    return CustomFood(
      id: row.id,
      name: row.name,
      kj: row.kj,
      carbs: row.carbs,
      protein: row.protein,
      fat: row.fat,
      basisAmount: row.basisAmount,
      unitName: row.unitName,
      lastUsedTime: row.lastUsedTime,
    );
  }
}
