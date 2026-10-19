import '../models/meal.dart';
import '../utils/energy_converter.dart';

/// 一组进食记录的统计。
extension MealStatistics on List<Meal> {
  double get totalKj => fold(0.0, (sum, meal) => sum + meal.totalKj);

  double get totalKcal => EnergyConverter.kjToKcal(totalKj);

  double get totalCarbs => fold(0.0, (sum, meal) => sum + meal.totalCarbs);

  double get totalProtein => fold(0.0, (sum, meal) => sum + meal.totalProtein);

  double get totalFat => fold(0.0, (sum, meal) => sum + meal.totalFat);
}

/// Convenience accessors for a non-empty list of meals from the same day.
extension DailyMealSummary on List<Meal> {
  /// The calendar day these meals belong to.
  DateTime get date {
    final firstMeal = first.createTime;
    return DateTime(firstMeal.year, firstMeal.month, firstMeal.day);
  }

  int get mealCount => length;
}
