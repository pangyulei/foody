/// Where a [Meal] snapshot originally came from.
enum FoodSource {
  /// A packaged food entered from a nutrition label.
  packaged(0),

  /// A user-defined food entered directly.
  custom(1);

  const FoodSource(this.value);

  /// Raw integer stored in the database (`meals.raw_food_source`).
  /// The values are part of the persisted data contract: `packaged = 0`,
  /// `custom = 1`. Renaming the enum constants must not change them.
  final int value;

  static FoodSource fromValue(int value) => value == packaged.value ? packaged : custom;
}
