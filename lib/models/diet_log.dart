import '../utils/energy_converter.dart';
import 'food.dart';
import 'food_source.dart';
import 'premade_food.dart';

/// A one-time eating record.
///
/// The food's attributes are copied into the log, so editing or deleting a
/// [Food] later never changes historical records. Food is only a reusable
/// input/catalogue model.
class DietLog {
  int id;

  String foodName;

  /// Per-serving energy (kJ)
  double kj;

  /// Per-serving carbohydrates (g)
  double carbs;

  /// Per-serving protein (g)
  double protein;

  /// Per-serving fat (g)
  double fat;

  /// Raw [FoodSource] value stored in the database.
  int rawFoodSource;

  /// Net content metadata copied from a [PremadeFood]
  double netContent;

  /// Label basis metadata copied from a [PremadeFood]
  double basisAmount;

  /// Unit metadata copied from a [PremadeFood]
  String unitName;

  /// Number of servings eaten
  double quantity;

  DateTime createTime;

  String? note;

  DietLog({
    this.id = 0,
    required this.foodName,
    required this.kj,
    required this.carbs,
    required this.protein,
    required this.fat,
    required this.rawFoodSource,
    this.netContent = 1,
    this.basisAmount = 1,
    this.unitName = '份',
    this.quantity = 1.0,
    required this.createTime,
    this.note,
  });

  /// Creates a log by copying the food's current attributes.
  factory DietLog.fromFood({
    int id = 0,
    required Food food,
    double quantity = 1.0,
    required DateTime createTime,
    String? note,
  }) {
    final premade = food is PremadeFood ? food : null;
    return DietLog(
      id: id,
      foodName: food.name,
      kj: food.kj,
      carbs: food.carbs,
      protein: food.protein,
      fat: food.fat,
      rawFoodSource:
          (premade != null ? FoodSource.premade : FoodSource.custom).value,
      netContent: premade?.netContent ?? 1,
      basisAmount: premade?.basisAmount ?? 1,
      unitName: premade?.unitName ?? '份',
      quantity: quantity,
      createTime: createTime,
      note: note,
    );
  }

  /// Decoded source of this log's snapshot.
  FoodSource get foodSource => FoodSource.fromValue(rawFoodSource);

  /// Total energy for this log (kJ)
  double get totalKj => kj * quantity;

  /// Total calories for this log (kcal)
  double get calories => EnergyConverter.kjToKcal(totalKj);

  /// Total carbohydrates for this log (g)
  double get totalCarbs => carbs * quantity;

  /// Total protein for this log (g)
  double get totalProtein => protein * quantity;

  /// Total fat for this log (g)
  double get totalFat => fat * quantity;
}
