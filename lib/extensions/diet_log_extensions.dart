import '../models/diet_log.dart';
import '../utils/energy_converter.dart';

/// 一组进食记录的统计。
extension DietLogStatistics on List<DietLog> {
  double get totalKj => fold(0.0, (sum, log) => sum + log.totalKj);

  double get totalKcal => EnergyConverter.kjToKcal(totalKj);

  double get totalCarbs => fold(0.0, (sum, log) => sum + log.totalCarbs);

  double get totalProtein => fold(0.0, (sum, log) => sum + log.totalProtein);

  double get totalFat => fold(0.0, (sum, log) => sum + log.totalFat);
}
