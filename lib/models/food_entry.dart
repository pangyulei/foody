import 'package:objectbox/objectbox.dart';

@Entity()
class FoodEntry {
  @Id()
  int id;

  String name;

  @Property(type: PropertyType.date)
  DateTime createTime;

  /// 能量 (千焦 kJ) - 数据库保存单位
  double kj;

  /// 碳水化合物 (克 g)
  double carbs;

  /// 蛋白质 (克 g)
  double protein;

  /// 脂肪 (克 g)
  double fat;

  /// 记录模式：'direct' (直接输入) 或 'table' (成分表记录)
  String inputMode;

  /// 数量 (默认 1.0)
  double quantity;

  /// 备注 (如 "200ml", "1包" 等)
  String? note;

  FoodEntry({
    this.id = 0,
    required this.name,
    required this.createTime,
    required this.kj,
    required this.carbs,
    required this.protein,
    required this.fat,
    this.inputMode = 'direct',
    this.quantity = 1.0,
    this.note,
  });

  /// 换算为卡路里 (千卡 kcal)
  /// 1 千卡 (kcal) ≈ 4.184 千焦 (kJ)
  double get calories => kj / 4.184;
}
