import '../utils/energy_converter.dart';
import 'custom_food.dart';
import 'food.dart';
import 'packaged_food.dart';

/// A one-time meal record linked to a catalogue food.
///
/// The meal only stores which food was eaten and how much. Nutrition is read
/// from the referenced [Food], so editing a food also updates its meal history.
sealed class Meal {
  int id;

  final DateTime createTime;

  final String? note;

  Meal({this.id = 0, required this.createTime, this.note});

  /// Creates a meal pointing at [food].
  ///
  /// For a [CustomFood], [quantity] multiplies the food's basis amount (the
  /// quick-add portion count); [netContent] overrides the consumed amount.
  factory Meal.fromFood({
    int id = 0,
    required Food food,
    double quantity = 1.0,
    double? netContent,
    required DateTime createTime,
    String? note,
  }) {
    return switch (food) {
      CustomFood() => CustomMeal(
        id: id,
        food: food,
        netContent: netContent ?? food.basisAmount * quantity,
        createTime: createTime,
        note: note,
      ),
      PackagedFood() => PackagedMeal(
        id: id,
        food: food,
        quantity: quantity,
        createTime: createTime,
        note: note,
      ),
      _ => throw ArgumentError('Unsupported food type: ${food.runtimeType}'),
    };
  }

  Food get food;

  String get foodName => food.name;

  /// Total energy for this meal (kJ)
  double get totalKj;

  /// Total calories for this meal (kcal)
  double get calories => EnergyConverter.kjToKcal(totalKj);

  /// Total carbohydrates for this meal (g)
  double get totalCarbs;

  /// Total protein for this meal (g)
  double get totalProtein;

  /// Total fat for this meal (g)
  double get totalFat;
}

class PackagedMeal extends Meal {
  @override
  final PackagedFood food;

  /// Number of packages eaten.
  final double quantity;

  PackagedMeal({
    super.id,
    required this.food,
    required this.quantity,
    required super.createTime,
    super.note,
  });

  @override
  double get totalKj => food.kj * quantity;

  @override
  double get totalCarbs => food.carbs * quantity;

  @override
  double get totalProtein => food.protein * quantity;

  @override
  double get totalFat => food.fat * quantity;
}

class CustomMeal extends Meal {
  @override
  final CustomFood food;

  /// Amount eaten in the food's unit.
  final double netContent;

  CustomMeal({
    super.id,
    required this.food,
    required this.netContent,
    required super.createTime,
    super.note,
  });

  double get _multiplier =>
      food.basisAmount > 0 ? netContent / food.basisAmount : 0;

  @override
  double get totalKj => food.kj * _multiplier;

  @override
  double get totalCarbs => food.carbs * _multiplier;

  @override
  double get totalProtein => food.protein * _multiplier;

  @override
  double get totalFat => food.fat * _multiplier;
}
