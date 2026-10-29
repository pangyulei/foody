import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../l10n/app_strings.dart';
import '../../../models/custom_food.dart';
import '../../../models/food.dart';
import '../../../models/meal.dart';
import '../../../models/packaged_food.dart';
import 'nutrition_preview_card.dart';
import 'quick_food_selector.dart';

/// 自定义食品按每 100 ml/g 记录成分表数值，并单独填写实际净含量。
class CustomMealForm extends StatefulWidget {
  final Meal? initialMeal;
  final Food? initialFood;
  final bool catalogueMode;
  final DateTime? initialDate;
  final Function(Food food, Meal meal) onSubmit;

  /// Called when a food is picked in the quick-add selector so the page can
  /// switch to the matching tab. Falls back to filling this form directly.
  final ValueChanged<Food>? onQuickFoodSelected;

  /// Food picked in the quick-add selector. The page switches to the matching
  /// tab and passes it down; this form only consumes custom foods.
  final Food? pendingQuickFood;

  /// Called after [pendingQuickFood] has been applied.
  final VoidCallback? onQuickFoodConsumed;

  const CustomMealForm({
    super.key,
    this.initialMeal,
    this.initialFood,
    this.catalogueMode = false,
    this.initialDate,
    required this.onSubmit,
    this.onQuickFoodSelected,
    this.pendingQuickFood,
    this.onQuickFoodConsumed,
  });

  @override
  State<CustomMealForm> createState() => _CustomMealFormState();
}

class _CustomMealFormState extends State<CustomMealForm> {
  /// 自定义食品的成分表固定按 100 ml/g 录入。
  static const double _basisAmount = 100;

  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _netContentController;
  late TextEditingController _kjController;
  late TextEditingController _carbsController;
  late TextEditingController _proteinController;
  late TextEditingController _fatController;
  late TextEditingController _noteController;

  String _unitName = 'g';
  late DateTime _selectedDateTime;
  Food? _selectedFood;

  @override
  void initState() {
    super.initState();
    final meal = widget.initialMeal;
    final food = widget.initialFood;
    _selectedFood = food;
    _nameController = TextEditingController(
      text: food?.name ?? meal?.foodName ?? '',
    );
    _netContentController = TextEditingController(
      text: _formatNumber(_basisAmount),
    );
    _kjController = TextEditingController();
    _carbsController = TextEditingController();
    _proteinController = TextEditingController();
    _fatController = TextEditingController();
    _noteController = TextEditingController(text: meal?.note ?? '');
    _selectedDateTime =
        meal?.createTime ?? widget.initialDate ?? DateTime.now();

    if (meal != null) {
      _applyMeal(meal);
    }
    if (food != null) {
      _applyFood(food);
    }

    _netContentController.addListener(() => setState(() {}));
    _kjController.addListener(() => setState(() {}));
    _carbsController.addListener(() => setState(() {}));
    _proteinController.addListener(() => setState(() {}));
    _fatController.addListener(() => setState(() {}));
    _schedulePendingQuickFood(widget.pendingQuickFood);
  }

  @override
  void didUpdateWidget(covariant CustomMealForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.pendingQuickFood != oldWidget.pendingQuickFood) {
      _schedulePendingQuickFood(widget.pendingQuickFood);
    }
  }

  /// Applies a quick-add selection once the form is on screen and laid out.
  void _schedulePendingQuickFood(Food? food) {
    // Packaged foods belong to the packaged tab.
    if (food is! CustomFood) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _populateFromHistory(food);
      widget.onQuickFoodConsumed?.call();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _netContentController.dispose();
    _kjController.dispose();
    _carbsController.dispose();
    _proteinController.dispose();
    _fatController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  String _formatNumber(double value) {
    if (value == 0) return '0';
    // Remove floating point noise from the per-100 <-> per-portion conversion.
    final rounded = double.parse(value.toStringAsFixed(4));
    if (rounded == rounded.roundToDouble()) return rounded.toInt().toString();
    return rounded.toString();
  }

  String _validUnit(String unit) => unit == 'ml' || unit == 'g' ? unit : 'g';

  /// 自定义食品直接存每 100 ml/g；包装食品换算回每 100。
  void _applyFood(Food food) {
    _selectedFood = food;
    _nameController.text = food.name;
    _unitName = _validUnit(food.unitName);

    switch (food) {
      case CustomFood():
        _netContentController.text = _formatNumber(_basisAmount);
        _kjController.text = _formatNumber(food.kj);
        _carbsController.text = _formatNumber(food.carbs);
        _proteinController.text = _formatNumber(food.protein);
        _fatController.text = _formatNumber(food.fat);
      case PackagedFood():
        final netContent = food.netContent > 0 ? food.netContent : _basisAmount;
        final basis = food.basisAmount > 0 ? food.basisAmount : _basisAmount;
        final ratio = basis / netContent;
        _netContentController.text = _formatNumber(netContent);
        _kjController.text = _formatNumber(food.kj * ratio);
        _carbsController.text = _formatNumber(food.carbs * ratio);
        _proteinController.text = _formatNumber(food.protein * ratio);
        _fatController.text = _formatNumber(food.fat * ratio);
      default:
        throw ArgumentError('Unsupported food type: ${food.runtimeType}');
    }
  }

  /// 从历史记录还原表单。
  void _applyMeal(Meal meal) {
    _applyFood(meal.food);
    switch (meal) {
      case CustomMeal():
        _netContentController.text = _formatNumber(meal.netContent);
      case PackagedMeal():
        _netContentController.text = _formatNumber(
          meal.food.netContent * meal.quantity,
        );
    }
  }

  /// 快速导入历史食物
  void _populateFromHistory(Food food) {
    setState(() {
      _applyFood(food);
      _noteController.text = '';
    });

    final t = AppStrings.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(t.filledFromHistory(food.name)),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (date == null) return;

    if (!mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
    );
    if (time == null) return;

    setState(() {
      _selectedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final netContent =
          double.tryParse(_netContentController.text.trim()) ?? _basisAmount;
      final rawKj = double.tryParse(_kjController.text.trim()) ?? 0.0;
      final rawCarbs = double.tryParse(_carbsController.text.trim()) ?? 0.0;
      final rawProtein = double.tryParse(_proteinController.text.trim()) ?? 0.0;
      final rawFat = double.tryParse(_fatController.text.trim()) ?? 0.0;

      // 自定义食品固定存每 100 ml/g 数值。
      final existingFood = _selectedFood;
      final food = CustomFood(
        id: existingFood is CustomFood ? existingFood.id : 0,
        name: _nameController.text.trim(),
        kj: rawKj,
        carbs: rawCarbs,
        protein: rawProtein,
        fat: rawFat,
        basisAmount: _basisAmount,
        unitName: _unitName,
        lastUsedTime: existingFood?.lastUsedTime,
      );

      final meal = Meal.fromFood(
        id: widget.initialMeal?.id ?? 0,
        food: food,
        netContent: netContent,
        createTime: _selectedDateTime,
        note: _noteController.text.trim().isEmpty
            ? null
            : _noteController.text.trim(),
      );

      widget.onSubmit(food, meal);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppStrings.of(context);
    final unitLabel = _unitName;
    final netContent =
        double.tryParse(_netContentController.text.trim()) ?? 0.0;
    final multiplier = netContent / _basisAmount;

    final rawKj = double.tryParse(_kjController.text.trim()) ?? 0.0;
    final rawCarbs = double.tryParse(_carbsController.text.trim()) ?? 0.0;
    final rawProtein = double.tryParse(_proteinController.text.trim()) ?? 0.0;
    final rawFat = double.tryParse(_fatController.text.trim()) ?? 0.0;

    final totalKj = rawKj * multiplier;
    final totalCarbs = rawCarbs * multiplier;
    final totalProtein = rawProtein * multiplier;
    final totalFat = rawFat * multiplier;

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          if (!widget.catalogueMode)
            QuickFoodSelector(
              onFoodSelected:
                  widget.onQuickFoodSelected ?? _populateFromHistory,
            ),

          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: t.foodName,
              hintText: t.foodNameHint,
              prefixIcon: const Icon(Icons.fastfood_outlined),
              border: const OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return t.requiredName;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // 1. 净含量与单位
          Card(
            elevation: 0,
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.catalogueMode ? t.unitSection : t.servingSection,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SegmentedButton<String>(
                    segments: [
                      ButtonSegment(value: 'ml', label: Text(t.unitMl)),
                      ButtonSegment(value: 'g', label: Text(t.unitG)),
                    ],
                    selected: {_unitName},
                    onSelectionChanged: (set) {
                      setState(() {
                        _unitName = set.first;
                      });
                    },
                    style: const ButtonStyle(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                  if (!widget.catalogueMode) ...[
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _netContentController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        labelText: t.servingSize,
                        hintText: t.servingSizeHint,
                        suffixText: unitLabel,
                        prefixIcon: const Icon(Icons.scale_outlined),
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return t.requiredServingSize;
                        }
                        final amount = double.tryParse(value.trim());
                        if (amount == null || amount <= 0) {
                          return t.invalidNumber;
                        }
                        return null;
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 2. 营养成分表数值（固定每 100 ml/g）
          Card(
            elevation: 0,
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.nutritionValuesTitle,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    t.nutritionValuesSubtitle(
                      _formatNumber(_basisAmount),
                      unitLabel,
                    ),
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _kjController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: t.energyKj,
                      hintText: t.tableEnergyHint,
                      prefixIcon: const Icon(
                        Icons.local_fire_department_outlined,
                      ),
                      suffixText: 'kJ',
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return t.requiredEnergy;
                      }
                      if (double.tryParse(value.trim()) == null) {
                        return t.invalidNumber;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _carbsController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: t.carbsLabel,
                      hintText: t.tableCarbsHint,
                      prefixIcon: const Icon(Icons.grain),
                      suffixText: 'g',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _proteinController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: t.proteinLabel,
                      hintText: t.tableProteinHint,
                      prefixIcon: const Icon(Icons.fitness_center),
                      suffixText: 'g',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _fatController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: t.fatLabel,
                      hintText: t.tableFatHint,
                      prefixIcon: const Icon(Icons.opacity),
                      suffixText: 'g',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          NutritionPreviewCard(
            title: t.calculatedIntakeTitle,
            subtitle: widget.catalogueMode
                ? t.nutritionValuesSubtitle(
                    _formatNumber(_basisAmount),
                    unitLabel,
                  )
                : t.calculatedIntakeSubtitle(
                    _formatNumber(netContent),
                    unitLabel,
                    multiplier.toStringAsFixed(2),
                  ),
            totalKj: totalKj,
            totalCarbs: totalCarbs,
            totalProtein: totalProtein,
            totalFat: totalFat,
          ),
          if (!widget.catalogueMode) ...[
            const SizedBox(height: 16),

            TextFormField(
              controller: _noteController,
              decoration: InputDecoration(
                labelText: t.noteOptional,
                hintText: t.noteHint,
                prefixIcon: const Icon(Icons.note_outlined),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            ListTile(
              tileColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              leading: const Icon(Icons.access_time),
              title: Text(t.recordTime),
              subtitle: Text(
                DateFormat('yyyy-MM-dd HH:mm').format(_selectedDateTime),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: _pickDateTime,
            ),
          ],
          const SizedBox(height: 24),

          FilledButton.icon(
            onPressed: _submit,
            icon: const Icon(Icons.check),
            label: Text(
              widget.catalogueMode
                  ? (widget.initialFood == null ? t.saveFood : t.updateFood)
                  : (widget.initialMeal == null
                        ? t.saveRecord
                        : t.updateRecord),
            ),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ],
      ),
    );
  }
}
