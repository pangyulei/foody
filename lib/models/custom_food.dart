import '../services/app_database.dart';
import 'food.dart';

/// 用户自定义食品：例如一盘菜、一个鸡蛋。
/// 营养数值按一份记录。
class CustomFood implements Food {
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

  @override
  DateTime lastUsedTime;

  CustomFood({
    this.id = 0,
    required this.name,
    required this.kj,
    required this.carbs,
    required this.protein,
    required this.fat,
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
      lastUsedTime: row.lastUsedTime,
    );
  }
}
