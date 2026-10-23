import 'dart:ui';

/// 应用设置：语言、主题色、每日营养目标、备份选项
class AppSettings {
  /// Settings JSON schema version. Older files without this key are still read.
  static const int currentVersion = 1;

  static const int defaultAutoBackupLimit = 3;
  static const int minAutoBackupLimit = 1;
  static const int maxAutoBackupLimit = 10;

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

  /// 'zh' 或 'en'
  final String languageCode;

  /// Local folder used for automatic and manual backups.
  final String? backupFolder;

  /// How many of the latest automatic backups are kept.
  ///
  /// Only enforced when [backupFolder] is set. Always within
  /// [minAutoBackupLimit]..[maxAutoBackupLimit].
  final int autoBackupLimit;

  const AppSettings({
    this.languageCode = 'zh',
    this.themeColorValue = 0xFF009688,
    this.weightKg = 0,
    this.carbsFactor = 3.0,
    this.proteinFactor = 1.5,
    this.fatFactor = 1.0,
    this.backupFolder,
    this.autoBackupLimit = defaultAutoBackupLimit,
  });

  Color get themeColor => Color(themeColorValue);

  /// Whether all values needed to calculate daily goals are present.
  bool get hasCompleteGoalData => weightKg > 0 && carbsFactor > 0 && proteinFactor > 0 && fatFactor > 0;

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
    String? backupFolder,
    int? autoBackupLimit,
  }) {
    return AppSettings(
      languageCode: languageCode ?? this.languageCode,
      themeColorValue: themeColorValue ?? this.themeColorValue,
      weightKg: weightKg ?? this.weightKg,
      carbsFactor: carbsFactor ?? this.carbsFactor,
      proteinFactor: proteinFactor ?? this.proteinFactor,
      fatFactor: fatFactor ?? this.fatFactor,
      backupFolder: backupFolder ?? this.backupFolder,
      autoBackupLimit: autoBackupLimit ?? this.autoBackupLimit,
    );
  }

  Map<String, dynamic> toJson() => {
    'version': currentVersion,
    'languageCode': languageCode,
    'themeColorValue': themeColorValue,
    'weightKg': weightKg,
    'carbsFactor': carbsFactor,
    'proteinFactor': proteinFactor,
    'fatFactor': fatFactor,
    'backupFolder': backupFolder,
    'autoBackupLimit': autoBackupLimit,
  };

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      languageCode: json['languageCode'] as String? ?? 'zh',
      themeColorValue: (json['themeColorValue'] as num?)?.toInt() ?? 0xFF009688,
      weightKg: (json['weightKg'] as num?)?.toDouble() ?? 0,
      carbsFactor: (json['carbsFactor'] as num?)?.toDouble() ?? 3.0,
      proteinFactor: (json['proteinFactor'] as num?)?.toDouble() ?? 1.5,
      fatFactor: (json['fatFactor'] as num?)?.toDouble() ?? 1.0,
      backupFolder: json['backupFolder'] as String?,
      autoBackupLimit: clampAutoBackupLimit(json['autoBackupLimit']),
    );
  }

  /// Parses a stored limit, falling back to [defaultAutoBackupLimit] for
  /// missing or invalid values and clamping to the supported range.
  static int clampAutoBackupLimit(dynamic value) {
    final parsed = value is num ? value.toInt() : int.tryParse('$value');
    if (parsed == null) return defaultAutoBackupLimit;
    return parsed.clamp(minAutoBackupLimit, maxAutoBackupLimit).toInt();
  }
}
