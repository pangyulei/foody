import '../utils/energy_converter.dart';

/// Aggregated nutrition for one local calendar day.
class DailySummary {
  final DateTime day;
  final double totalKj;
  final double totalCarbs;
  final double totalProtein;
  final double totalFat;
  final int mealCount;

  const DailySummary({
    required this.day,
    required this.totalKj,
    required this.totalCarbs,
    required this.totalProtein,
    required this.totalFat,
    required this.mealCount,
  });

  double get totalKcal => EnergyConverter.kjToKcal(totalKj);
}
