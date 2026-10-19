import '../models/diet_log.dart';
import '../utils/energy_converter.dart';

/// 一组进食记录的统计。
extension DietLogStatistics on List<DietLog> {
  double get totalKj => fold(0.0, (sum, log) => sum + log.kj);

  double get totalKcal => EnergyConverter.kjToKcal(totalKj);

  double get totalCarbs => fold(0.0, (sum, log) => sum + log.carbs);

  double get totalProtein => fold(0.0, (sum, log) => sum + log.protein);

  double get totalFat => fold(0.0, (sum, log) => sum + log.fat);
}
