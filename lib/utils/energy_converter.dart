class EnergyConverter {
  /// 1 千卡 (kcal) = 4.184 千焦 (kJ)
  static const double kjPerKcal = 4.184;

  /// 千焦 (kJ) 转换为 卡路里/千卡 (kcal)
  static double kjToKcal(double kj) {
    if (kj <= 0) return 0.0;
    return kj / kjPerKcal;
  }

  /// 卡路里/千卡 (kcal) 转换为 千焦 (kJ)
  static double kcalToKj(double kcal) {
    if (kcal <= 0) return 0.0;
    return kcal * kjPerKcal;
  }

  /// 格式化卡路里显示，如 "250 kcal" 或 "250 千卡"
  static String formatKcal(double kj, {int fractionDigits = 1}) {
    final kcal = kjToKcal(kj);
    return '${kcal.toStringAsFixed(fractionDigits)} 千卡';
  }

  /// 格式化千焦显示，如 "1046 kJ"
  static String formatKj(double kj, {int fractionDigits = 0}) {
    return '${kj.toStringAsFixed(fractionDigits)} kJ';
  }

  /// 格式化营养素克数
  static String formatGrams(double grams, {int fractionDigits = 1}) {
    return '${grams.toStringAsFixed(fractionDigits)} g';
  }
}
