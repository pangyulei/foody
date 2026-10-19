import 'dart:ui';

/// 应用设置：语言、主题色、每日营养目标
class AppSettings {
  /// 'zh' 或 'en'
  final String languageCode;

  /// 主题种子颜色 ARGB 值
  final int themeColorValue;

  /// 体重 (kg)
  final double weightKg;

  /// 碳水目标倍数 (g / kg 体重)
  final double carbsFactor;

  /// 蛋白质目标倍数 (g / kg 体重)
  final double proteinFactor;

  /// 脂肪目标倍数 (g / kg 体重)
  final double fatFactor;

  const AppSettings({
    this.languageCode = 'zh',
    this.themeColorValue = 0xFF009688,
    this.weightKg = 0,
    this.carbsFactor = 3.0,
    this.proteinFactor = 1.5,
    this.fatFactor = 1.0,
  });

  Color get themeColor => Color(themeColorValue);

  /// Whether all values needed to calculate daily goals are present.
  bool get hasCompleteGoalData =>
      weightKg > 0 && carbsFactor > 0 && proteinFactor > 0 && fatFactor > 0;

  bool get hasGoals => hasCompleteGoalData;

  double get targetCarbs => weightKg * carbsFactor;

  double get targetProtein => weightKg * proteinFactor;

  double get targetFat => weightKg * fatFactor;

  /// 由三大营养素推算的每日热量目标 (kcal)：碳水 4、蛋白质 4、脂肪 9
  double get targetKcal => targetCarbs * 4 + targetProtein * 4 + targetFat * 9;

  AppSettings copyWith({
    String? languageCode,
    int? themeColorValue,
    double? weightKg,
    double? carbsFactor,
    double? proteinFactor,
    double? fatFactor,
  }) {
    return AppSettings(
      languageCode: languageCode ?? this.languageCode,
      themeColorValue: themeColorValue ?? this.themeColorValue,
      weightKg: weightKg ?? this.weightKg,
      carbsFactor: carbsFactor ?? this.carbsFactor,
      proteinFactor: proteinFactor ?? this.proteinFactor,
      fatFactor: fatFactor ?? this.fatFactor,
    );
  }

  Map<String, dynamic> toJson() => {
    'languageCode': languageCode,
    'themeColorValue': themeColorValue,
    'weightKg': weightKg,
    'carbsFactor': carbsFactor,
    'proteinFactor': proteinFactor,
    'fatFactor': fatFactor,
  };

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      languageCode: json['languageCode'] as String? ?? 'zh',
      themeColorValue: (json['themeColorValue'] as num?)?.toInt() ?? 0xFF009688,
      weightKg: (json['weightKg'] as num?)?.toDouble() ?? 0,
      carbsFactor: (json['carbsFactor'] as num?)?.toDouble() ?? 3.0,
      proteinFactor: (json['proteinFactor'] as num?)?.toDouble() ?? 1.5,
      fatFactor: (json['fatFactor'] as num?)?.toDouble() ?? 1.0,
    );
  }
}
