import '../utils/energy_converter.dart';
import 'food.dart';
import 'food_source.dart';
import 'packaged_food.dart';

/// A one-time meal record.
///
/// The food's attributes are copied into the meal, so editing or deleting a
/// [Food] later never changes historical records. Food is only a reusable
/// input/catalogue model.
class Meal {
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

  /// Net content metadata copied from a [PackagedFood]
  double netContent;

  /// Label basis metadata copied from a [PackagedFood]
  double basisAmount;

  /// Unit metadata copied from a [PackagedFood]
  String unitName;

  /// Number of servings eaten
  double quantity;

  DateTime createTime;

  String? note;

  Meal({
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

  /// Creates a meal by copying the food's current attributes.
  factory Meal.fromFood({
    int id = 0,
    required Food food,
    double quantity = 1.0,
    required DateTime createTime,
    String? note,
  }) {
    final packaged = food is PackagedFood ? food : null;
    return Meal(
      id: id,
      foodName: food.name,
      kj: food.kj,
      carbs: food.carbs,
      protein: food.protein,
      fat: food.fat,
      rawFoodSource: (packaged != null ? FoodSource.packaged : FoodSource.custom).value,
      netContent: packaged?.netContent ?? 1,
      basisAmount: packaged?.basisAmount ?? 1,
      unitName: packaged?.unitName ?? '份',
      quantity: quantity,
      createTime: createTime,
      note: note,
    );
  }

  /// Decoded source of this meal's snapshot.
  FoodSource get foodSource => FoodSource.fromValue(rawFoodSource);

  /// Total energy for this meal (kJ)
  double get totalKj => kj * quantity;

  /// Total calories for this meal (kcal)
  double get calories => EnergyConverter.kjToKcal(totalKj);

  /// Total carbohydrates for this meal (g)
  double get totalCarbs => carbs * quantity;

  /// Total protein for this meal (g)
  double get totalProtein => protein * quantity;

  /// Total fat for this meal (g)
  double get totalFat => fat * quantity;
}
