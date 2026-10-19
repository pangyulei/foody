/// Where a [DietLog] snapshot originally came from.
enum FoodSource {
  /// A packaged/premade food entered from a nutrition label.
  premade(0),

  /// A user-defined food entered directly.
  custom(1);

  const FoodSource(this.value);

  /// Raw integer stored in the database (`diet_logs.raw_food_source`).
  final int value;

  static FoodSource fromValue(int value) {
    for (final source in values) {
      if (source.value == value) return source;
    }
    return FoodSource.custom;
  }
}
