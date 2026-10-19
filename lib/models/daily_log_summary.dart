import '../extensions/diet_log_extensions.dart';
import 'diet_log.dart';

/// Aggregated totals for every diet log on a single day.
class DailyLogSummary {
  final DateTime date;
  final int logCount;
  final double totalKj;
  final double totalCarbs;
  final double totalProtein;
  final double totalFat;

  const DailyLogSummary({
    required this.date,
    required this.logCount,
    required this.totalKj,
    required this.totalCarbs,
    required this.totalProtein,
    required this.totalFat,
  });

  factory DailyLogSummary.fromLogs(DateTime date, List<DietLog> logs) {
    return DailyLogSummary(
      date: date,
      logCount: logs.length,
      totalKj: logs.totalKj,
      totalCarbs: logs.totalCarbs,
      totalProtein: logs.totalProtein,
      totalFat: logs.totalFat,
    );
  }
}
