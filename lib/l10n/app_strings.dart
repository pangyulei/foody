import 'package:flutter/widgets.dart';

/// 轻量级中英文文案。语言由 MaterialApp 的 locale 决定。
class AppStrings {
  final String languageCode;

  const AppStrings._(this.languageCode);

  factory AppStrings.of(BuildContext context) =>
      AppStrings._(Localizations.localeOf(context).languageCode);

  bool get _en => languageCode == 'en';

  // 通用
  String get appTitle => 'Foody';
  String get navToday => _en ? 'Today' : '今日';
  String get navHistory => _en ? 'History' : '历史';
  String get navSettings => _en ? 'Settings' : '设置';
  String get historyTitle => _en ? 'History' : '历史记录';
  String get settingsTitle => _en ? 'Settings' : '设置';
  String get today => _en ? 'Today' : '今天';
  String get retry => _en ? 'Retry' : '重试';
  String get loadFailed => _en ? 'Failed to load data' : '加载数据失败';
  String todayWithDate(String date) => _en ? 'Today ($date)' : '今天 ($date)';

  // 今日 / 历史
  String get intakeToday => _en ? "Today's intake" : '今日已摄入';
  String get intakeThatDay => _en ? "Day's intake" : '当日已摄入';
  String get carbs => _en ? 'Carbs' : '碳水化合物';
  String get protein => _en ? 'Protein' : '蛋白质';
  String get fat => _en ? 'Fat' : '脂肪';
  String get kcalUnit => _en ? 'kcal' : 'kcal (卡路里)';
  String get emptyToday => _en
      ? 'No meals logged today. Tap the button below to add one.'
      : '今天还没有饮食记录，快点击下方按钮添加吧！';
  String get emptyHistory => _en ? 'No records for this date' : '该日期暂无记录';
  String get emptyHistoryList => _en ? 'No history yet' : '还没有历史记录';
  String entryCount(int count) =>
      _en ? '$count ${count == 1 ? 'item' : 'items'}' : '$count 项';
  String historyDayTitle(String date) => _en ? 'History · $date' : '历史 · $date';
  String mealCount(int count) => _en ? 'Meals ($count)' : '饮食记录 ($count项)';
  String get recentFoods => _en ? 'Recent foods' : '历史食品';
  String get addMeal => _en ? 'Meal' : '记一餐';
  String goalTooltip(double grams) => _en
      ? 'Goal: ${grams.toStringAsFixed(0)} g'
      : '目标: ${grams.toStringAsFixed(0)} g';
  String goalCaloriesTooltip(double kcal) => _en
      ? 'Goal: ${kcal.toStringAsFixed(0)} kcal'
      : '目标: ${kcal.toStringAsFixed(0)} kcal';

  // 快速添加
  String get quickAddTitle => _en ? 'Quick add from history' : '快速选择历史食品';
  String get tapToFill => _en ? 'Tap to fill' : '点击即填入';
  String quickAddSubtitle(String date) =>
      _en ? 'Tap to log directly to $date' : '选中后即可直接快速记录到 $date';
  String quickAdded(String name) => _en ? 'Logged "$name"!' : '已快速记入“$name”！';
  String get noRecentFoods => _en
      ? 'No history yet. Tap "Meal" to add food first.'
      : '暂无历史食物记录，请先“记一餐”添加食物';
  String selectTooltip(String name) => _en ? 'Select $name' : '选择 $name';
  String get logButton => _en ? 'Log' : '记录';

  // 记录明细
  String get modeTable => _en ? 'Label' : '成分表';
  String get modeDirect => _en ? 'Direct' : '直接输入';
  String get notePrefix => _en ? 'Note: ' : '备注: ';
  String macrosLine(double carbs, double protein, double fat) => _en
      ? 'Carbs: ${carbs.toStringAsFixed(1)}g · Protein: ${protein.toStringAsFixed(1)}g · Fat: ${fat.toStringAsFixed(1)}g'
      : '碳水: ${carbs.toStringAsFixed(1)}g · 蛋白质: ${protein.toStringAsFixed(1)}g · 脂肪: ${fat.toStringAsFixed(1)}g';
  String get confirmDelete => _en ? 'Delete record?' : '确认删除';
  String deleteMessage(String name) =>
      _en ? 'Delete the record "$name"?' : '确定要删除“$name”的记录吗？';
  String get cancel => _en ? 'Cancel' : '取消';
  String get delete => _en ? 'Delete' : '删除';

  // 添加 / 编辑页面
  String get addFoodTitle => _en ? 'Add Meal' : '添加饮食记录';
  String get editFoodTitle => _en ? 'Edit Meal' : '编辑饮食记录';
  String get tabLabelInput => _en ? 'By nutrition label' : '按成分表记录';
  String get tabDirectInput => _en ? 'Direct input' : '直接输入';
  String get addedSuccess => _en ? 'Added!' : '添加成功！';
  String get updatedSuccess => _en ? 'Updated!' : '更新成功！';

  // 直接输入表单
  String get foodName => _en ? 'Food name' : '食品名称';
  String get foodNameHint =>
      _en ? 'e.g. apple, grilled chicken, milk' : '如：苹果、烤鸡胸肉、牛奶';
  String get requiredName => _en ? 'Please enter a food name' : '请输入食品名称';
  String get servings => _en ? 'Servings' : '食用数量';
  String get energyKj => _en ? 'Energy (kJ)' : '能量 (kJ 千焦)';
  String get energyPerServingHint => _en ? 'Energy per serving' : '输入单份能量数值';
  String get requiredEnergy => _en ? 'Please enter energy' : '请输入能量';
  String get invalidNumber => _en ? 'Please enter a valid number' : '请输入有效数值';
  String get carbsLabel => _en ? 'Carbohydrates (g)' : '碳水化合物 (g)';
  String get carbsHint => _en ? 'Carbohydrate grams' : '输入碳水化合物克数';
  String get proteinLabel => _en ? 'Protein (g)' : '蛋白质 (g)';
  String get proteinHint => _en ? 'Protein grams' : '输入蛋白质克数';
  String get fatLabel => _en ? 'Fat (g)' : '脂肪 (g)';
  String get fatHint => _en ? 'Fat grams' : '输入脂肪克数';
  String get noteOptional => _en ? 'Note (optional)' : '备注 (可选)';
  String get noteHint => _en ? 'e.g. breakfast, 1 bag' : '如：早餐、1袋';
  String get recordTime => _en ? 'Recorded at' : '记录时间';
  String get saveRecord => _en ? 'Save' : '保存记录';
  String get updateRecord => _en ? 'Update' : '更新记录';
  String get directNutritionSection =>
      _en ? '1. Nutrition values' : '1. 营养成分数值';
  String get directNutritionSubtitle => _en ? 'per serving' : '每份';
  String get calculatedIntakeTitle => _en ? 'Calculated intake' : '实际摄入总量';
  String calculatedIntakeSubtitle(
    String total,
    String unit,
    String multiplier,
  ) => _en
      ? 'total $total $unit, ×$multiplier'
      : '共 $total$unit，倍率 $multiplier x';
  String directCalculatedIntakeSubtitle(String quantity) =>
      _en ? '$quantity servings' : '共 $quantity 份';
  String filledFromHistory(String name) =>
      _en ? 'Filled from history: $name' : '已自动填入历史食品: $name';

  // 成分表表单
  String filledFromHistoryTable(String name) =>
      _en ? 'Filled from history: $name' : '已自动填入历史成分表食品: $name';
  String get servingSection => _en ? '1. Net content & unit' : '1. 净含量与单位';
  String get unitMl => 'ml';
  String get unitG => 'g';
  String get unitServing => _en ? 'serving' : '份';
  String get servingSize => _en ? 'Net content' : '净含量';
  String get servingSizeHint => _en ? 'e.g. 200' : '例：200';
  String get requiredServingSize => _en ? 'Please enter net content' : '请输入净含量';
  String get labelBasis => _en ? 'Label basis' : '成分表基准份量';
  String get labelBasisHint => _en ? 'e.g. 100' : '例：100';
  String get requiredLabelBasis => _en ? 'Please enter label basis' : '请输入基准';
  String get nutritionValuesTitle => _en ? '2. Nutrition values' : '2. 营养成分表数值';
  String nutritionValuesSubtitle(String basis, String unit) =>
      _en ? 'per $basis $unit on the label' : '按每 $basis$unit 标注的数值输入';
  String get tableEnergyHint =>
      _en ? 'Energy value from the label' : '输入成分表上的能量数值';
  String get tableCarbsHint =>
      _en ? 'Carbohydrates on the label' : '输入成分表上的碳水化合物克数';
  String get tableProteinHint => _en ? 'Protein on the label' : '输入成分表上的蛋白质克数';
  String get tableFatHint => _en ? 'Fat on the label' : '输入成分表上的脂肪克数';
  String get intakeCalories => _en ? 'Calories:' : '摄入卡路里:';
  String get shortCarbs => _en ? 'Carbs' : '碳水';
  String get shortProtein => _en ? 'Protein' : '蛋白质';
  String get shortFat => _en ? 'Fat' : '脂肪';
  String get customNote => _en ? 'Custom note (optional)' : '自定义备注 (可选)';
  String get customNoteHint =>
      _en ? 'Generated automatically if empty' : '如不填则自动生成';
  String generatedNote(
    String total,
    String unit,
    String netContent,
    String unitName,
    String quantity,
    String servingWord,
  ) => _en
      ? '$total $unit consumed ($netContent $unitName / $servingWord × $quantity)'
      : '食用$total$unit ($netContent$unitName/份 × $quantity份)';

  // 设置
  String get language => _en ? 'Language' : '语言';
  String get languageChinese => '中文';
  String get languageEnglish => 'English';
  String get themeColor => _en ? 'Theme color' : '主题颜色';
  String get dailyGoals => _en ? 'Daily intake goals' : '每日摄入目标';
  String get editDailyGoals => _en ? 'Edit goals' : '编辑每日目标';
  String get clearGoals => _en ? 'Remove daily goals' : '清除每日目标';
  String get goalsCleared => _en ? 'Daily goals removed' : '已清除每日目标';
  String get quantityMinError => _en ? 'Whole number ≥ 1' : '请输入 ≥1 的整数';
  String get bodyWeight => _en ? 'Body weight (kg)' : '体重 (kg)';
  String get bodyWeightHint => _en ? 'e.g. 70' : '例如 70';
  String get carbsFactor => _en ? 'Carbs (g per kg)' : '碳水倍数 (g/kg 体重)';
  String get proteinFactor => _en ? 'Protein (g per kg)' : '蛋白质倍数 (g/kg 体重)';
  String get fatFactor => _en ? 'Fat (g per kg)' : '脂肪倍数 (g/kg 体重)';
  String get goalsHint => _en
      ? 'Target = body weight × factor. e.g. 70 kg × 3 g/kg → 210 g carbs.'
      : '目标 = 体重 × 倍数。例如 70kg、碳水 3g/kg → 碳水目标 210g。';
  String get dailyTargets => _en ? 'Daily targets' : '每日目标';
  String targetsLine(double carbs, double protein, double fat) => _en
      ? 'Carbs ${carbs.toStringAsFixed(0)} g · Protein ${protein.toStringAsFixed(0)} g · Fat ${fat.toStringAsFixed(0)} g'
      : '碳水 ${carbs.toStringAsFixed(0)} g · 蛋白质 ${protein.toStringAsFixed(0)} g · 脂肪 ${fat.toStringAsFixed(0)} g';
  String approxKcal(double kcal) => _en
      ? '≈ ${kcal.toStringAsFixed(0)} kcal'
      : '约 ${kcal.toStringAsFixed(0)} kcal';
  String get goalsNotSet =>
      _en ? 'Fill in weight and all three macro factors' : '请填写体重和三大营养素倍数';

  // 食物管理
  String get foodCatalogue => _en ? 'Food catalogue' : '食物管理';
  String get foodCatalogueSubtitle =>
      _en ? 'Add, edit or delete saved foods' : '添加、编辑或删除已保存的食物';
  String get addCatalogueFood => _en ? 'Add food' : '添加食物';
  String get addCatalogueFoodTitle => _en ? 'Add Food' : '添加食物';
  String get editCatalogueFoodTitle => _en ? 'Edit Food' : '编辑食物';
  String get noCatalogueFoods => _en ? 'No saved foods yet' : '还没有保存的食物';
  String foodCatalogueCount(int count) =>
      _en ? '$count saved ${count == 1 ? 'food' : 'foods'}' : '共 $count 种食物';
  String get foodTypePremade => _en ? 'Premade' : '包装食品';
  String get foodTypeCustom => _en ? 'Custom' : '自定义';
  String get confirmDeleteFood => _en ? 'Delete food?' : '删除食物？';
  String deleteFoodMessage(String name) => _en
      ? 'Delete "$name"? Existing meal records are kept.'
      : '确定要删除“$name”吗？已有的饮食记录不会受影响。';
  String get foodDeleted => _en ? 'Food deleted' : '已删除食物';
  String get foodSaved => _en ? 'Food saved' : '食物已保存';
  String get saveFood => _en ? 'Save food' : '保存食物';
  String get updateFood => _en ? 'Update food' : '更新食物';
}
