/// Where a [Meal] snapshot originally came from.
enum FoodSource {
  /// A packaged/premade food entered from a nutrition label.
  premade(0),

  /// A user-defined food entered directly.
  custom(1);

  const FoodSource(this.value);

  /// Raw integer stored in the database (`meals.raw_food_source`).
  final int value;

  static FoodSource fromValue(int value) =>
      value == premade.value ? premade : custom;
}
