import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../l10n/app_strings.dart';
import '../../../models/food.dart';
import '../../../models/food_source.dart';
import '../../../models/meal.dart';
import '../../../models/packaged_food.dart';
import 'nutrition_preview_card.dart';
import 'quick_food_selector.dart';

class NutritionTableForm extends StatefulWidget {
  final Meal? initialMeal;
  final Food? initialFood;
  final bool catalogueMode;
  final DateTime? initialDate;
  final Function(Food food, Meal meal) onSubmit;

  const NutritionTableForm({
    super.key,
    this.initialMeal,
    this.initialFood,
    this.catalogueMode = false,
    this.initialDate,
    required this.onSubmit,
  });

  @override
  State<NutritionTableForm> createState() => _NutritionTableFormState();
}

class _NutritionTableFormState extends State<NutritionTableForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _netContentController; // 净含量 (如 200)
  late TextEditingController _unitAmountController; // 成分表基准 (如 100)
  late TextEditingController _carbsController; // 每基准份量碳水
  late TextEditingController _proteinController; // 每基准份量蛋白质
  late TextEditingController _fatController; // 每基准份量脂肪
  late TextEditingController _kjController; // 每基准份量能量
  late TextEditingController _quantityController; // 食用数量
  late TextEditingController _noteController;

  String _unitName = 'ml'; // ml / g
  late DateTime _selectedDateTime;
  Food? _selectedFood;

  @override
  void initState() {
    super.initState();
    final meal = widget.initialMeal;
    final food = widget.initialFood;
    _selectedFood = food;
    _nameController = TextEditingController(text: meal?.foodName ?? '');
    _netContentController = TextEditingController(text: '200');
    _unitAmountController = TextEditingController(text: '100');
    _carbsController = TextEditingController();
    _proteinController = TextEditingController();
    _fatController = TextEditingController();
    _kjController = TextEditingController();
    _quantityController = TextEditingController(text: _formatNumber(meal?.quantity ?? 1.0));
    _noteController = TextEditingController(text: meal?.note ?? '');
    _selectedDateTime = meal?.createTime ?? widget.initialDate ?? DateTime.now();

    if (meal != null) {
      _applyMeal(meal);
    }
    if (food != null) {
      _applyFood(food);
    }

    _netContentController.addListener(() => setState(() {}));
    _unitAmountController.addListener(() => setState(() {}));
    _carbsController.addListener(() => setState(() {}));
    _proteinController.addListener(() => setState(() {}));
    _fatController.addListener(() => setState(() {}));
    _kjController.addListener(() => setState(() {}));
    _quantityController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _netContentController.dispose();
    _unitAmountController.dispose();
    _carbsController.dispose();
    _proteinController.dispose();
    _fatController.dispose();
    _kjController.dispose();
    _quantityController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  String _formatNumber(double value) {
    if (value == 0) return '0';
    if (value == value.roundToDouble()) return value.toInt().toString();
    return value.toString();
  }

  /// 把纯食物的“每份”营养换算回成分表基准值
  void _applyFood(Food food, {bool resetQuantity = false}) {
    _selectedFood = food;
    _nameController.text = food.name;

    final packaged = food is PackagedFood ? food : null;
    final netContent = (packaged != null && packaged.netContent > 0) ? packaged.netContent : 100.0;
    final basis = (packaged != null && packaged.basisAmount > 0) ? packaged.basisAmount : 100.0;
    if (packaged != null && (packaged.unitName == 'ml' || packaged.unitName == 'g')) {
      _unitName = packaged.unitName;
    } else {
      _unitName = 'ml';
    }

    final ratio = basis / netContent;
    _netContentController.text = _formatNumber(netContent);
    _unitAmountController.text = _formatNumber(basis);
    _kjController.text = _formatNumber(food.kj * ratio);
    _carbsController.text = _formatNumber(food.carbs * ratio);
    _proteinController.text = _formatNumber(food.protein * ratio);
    _fatController.text = _formatNumber(food.fat * ratio);

    if (resetQuantity) {
      _quantityController.text = '1';
      _noteController.text = '';
    }
  }

  /// 从历史记录的快照还原表单（不引用 Food 表）。
  void _applyMeal(Meal meal) {
    _nameController.text = meal.foodName;
    final isPackaged = meal.foodSource == FoodSource.packaged;
    final netContent = isPackaged && meal.netContent > 0 ? meal.netContent : 100.0;
    final basis = isPackaged && meal.basisAmount > 0 ? meal.basisAmount : 100.0;
    if (isPackaged && (meal.unitName == 'ml' || meal.unitName == 'g')) {
      _unitName = meal.unitName;
    } else {
      _unitName = 'ml';
    }

    final ratio = basis / netContent;
    _netContentController.text = _formatNumber(netContent);
    _unitAmountController.text = _formatNumber(basis);
    _kjController.text = _formatNumber(meal.kj * ratio);
    _carbsController.text = _formatNumber(meal.carbs * ratio);
    _proteinController.text = _formatNumber(meal.protein * ratio);
    _fatController.text = _formatNumber(meal.fat * ratio);
  }

  void _populateFromHistory(Food food) {
    setState(() {
      _applyFood(food, resetQuantity: true);
    });

    final t = AppStrings.of(context);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(t.filledFromHistoryTable(food.name)), duration: const Duration(seconds: 1)));
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
    final time = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(_selectedDateTime));
    if (time == null) return;

    setState(() {
      _selectedDateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  void _updateQuantity(int delta) {
    final current = int.tryParse(_quantityController.text.trim()) ?? 1;
    final updated = current + delta;
    setState(() {
      _quantityController.text = (updated < 1 ? 1 : updated).toString();
    });
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final t = AppStrings.of(context);
      final netContent = double.tryParse(_netContentController.text.trim()) ?? 100.0;
      final basisAmount = double.tryParse(_unitAmountController.text.trim()) ?? 100.0;
      final quantity = int.tryParse(_quantityController.text.trim()) ?? 1;

      // 每份营养 = 成分表数值 × (净含量 / 基准份量)
      final perServingMultiplier = basisAmount > 0 ? netContent / basisAmount : 1.0;

      final rawCarbs = double.tryParse(_carbsController.text.trim()) ?? 0.0;
      final rawProtein = double.tryParse(_proteinController.text.trim()) ?? 0.0;
      final rawFat = double.tryParse(_fatController.text.trim()) ?? 0.0;
      final rawKj = double.tryParse(_kjController.text.trim()) ?? 0.0;

      final existingFood = _selectedFood;
      final food = PackagedFood(
        id: existingFood is PackagedFood ? existingFood.id : 0,
        name: _nameController.text.trim(),
        kj: rawKj * perServingMultiplier,
        carbs: rawCarbs * perServingMultiplier,
        protein: rawProtein * perServingMultiplier,
        fat: rawFat * perServingMultiplier,
        netContent: netContent,
        basisAmount: basisAmount,
        unitName: _unitName,
        lastUsedTime: existingFood?.lastUsedTime,
      );

      final totalConsumedAmount = netContent * quantity;
      final unitLabel = _unitName;
      final noteText = _noteController.text.trim().isNotEmpty
          ? _noteController.text.trim()
          : t.generatedNote(
              totalConsumedAmount.toStringAsFixed(0),
              unitLabel,
              netContent.toStringAsFixed(0),
              unitLabel,
              quantity.toString(),
              t.unitServing,
            );

      final meal = Meal.fromFood(
        id: widget.initialMeal?.id ?? 0,
        food: food,
        quantity: quantity.toDouble(),
        createTime: _selectedDateTime,
        note: noteText,
      );

      widget.onSubmit(food, meal);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppStrings.of(context);
    final unitLabel = _unitName;
    final netContent = double.tryParse(_netContentController.text.trim()) ?? 0.0;
    final unitAmount = double.tryParse(_unitAmountController.text.trim()) ?? 100.0;
    final quantity = double.tryParse(_quantityController.text.trim()) ?? 1.0;

    final totalConsumedAmount = netContent * quantity;
    final multiplier = unitAmount > 0 ? totalConsumedAmount / unitAmount : 0.0;

    final rawCarbs = double.tryParse(_carbsController.text.trim()) ?? 0.0;
    final rawProtein = double.tryParse(_proteinController.text.trim()) ?? 0.0;
    final rawFat = double.tryParse(_fatController.text.trim()) ?? 0.0;
    final rawKj = double.tryParse(_kjController.text.trim()) ?? 0.0;

    final calculatedKj = rawKj * multiplier;
    final calculatedCarbs = rawCarbs * multiplier;
    final calculatedProtein = rawProtein * multiplier;
    final calculatedFat = rawFat * multiplier;

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // 历史食品快速选择器
          if (!widget.catalogueMode) QuickFoodSelector(onFoodSelected: _populateFromHistory),

          // 食品名称
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: t.foodName,
              hintText: t.foodNameHint,
              prefixIcon: const Icon(Icons.shopping_bag_outlined),
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

          // 数量选择器
          if (!widget.catalogueMode) ...[
            Card(
              elevation: 0,
              color: Theme.of(context).colorScheme.surfaceContainerLow,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    const Icon(Icons.format_list_numbered),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(t.servings, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    ),
                    IconButton.filledTonal(icon: const Icon(Icons.remove), onPressed: () => _updateQuantity(-1)),
                    SizedBox(
                      width: 72,
                      child: TextFormField(
                        controller: _quantityController,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 8),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          final quantity = int.tryParse(value?.trim() ?? '');
                          if (quantity == null || quantity < 1) {
                            return t.quantityMinError;
                          }
                          return null;
                        },
                      ),
                    ),
                    IconButton.filledTonal(icon: const Icon(Icons.add), onPressed: () => _updateQuantity(1)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // 1. 净含量与单位
          Card(
            elevation: 0,
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t.servingSection, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
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
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _netContentController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(
                            labelText: t.servingSize,
                            hintText: t.servingSizeHint,
                            suffixText: unitLabel,
                            border: const OutlineInputBorder(),
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return t.requiredServingSize;
                            }
                            if (double.tryParse(v.trim()) == null) {
                              return t.invalidNumber;
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _unitAmountController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(
                            labelText: t.labelBasis,
                            hintText: t.labelBasisHint,
                            suffixText: unitLabel,
                            border: const OutlineInputBorder(),
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return t.requiredLabelBasis;
                            }
                            if (double.tryParse(v.trim()) == null) {
                              return t.invalidNumber;
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 2. 营养成分表数值
          Card(
            elevation: 0,
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t.nutritionValuesTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(
                    t.nutritionValuesSubtitle(
                      _unitAmountController.text.isEmpty ? '100' : _unitAmountController.text,
                      unitLabel,
                    ),
                    style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _kjController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: t.energyKj,
                      hintText: t.tableEnergyHint,
                      suffixText: 'kJ',
                      prefixIcon: const Icon(Icons.local_fire_department_outlined),
                      border: const OutlineInputBorder(),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return t.requiredEnergy;
                      }
                      if (double.tryParse(v.trim()) == null) {
                        return t.invalidNumber;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _carbsController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
                ? t.directNutritionSubtitle
                : t.calculatedIntakeSubtitle(
                    totalConsumedAmount.toStringAsFixed(0),
                    unitLabel,
                    multiplier.toStringAsFixed(2),
                  ),
            totalKj: calculatedKj,
            totalCarbs: calculatedCarbs,
            totalProtein: calculatedProtein,
            totalFat: calculatedFat,
          ),
          if (!widget.catalogueMode) ...[
            const SizedBox(height: 16),

            TextFormField(
              controller: _noteController,
              decoration: InputDecoration(
                labelText: t.customNote,
                hintText: t.customNoteHint,
                prefixIcon: const Icon(Icons.edit_note),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            ListTile(
              tileColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              leading: const Icon(Icons.access_time),
              title: Text(t.recordTime),
              subtitle: Text(DateFormat('yyyy-MM-dd HH:mm').format(_selectedDateTime)),
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
                  : (widget.initialMeal == null ? t.saveRecord : t.updateRecord),
            ),
            style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
          ),
        ],
      ),
    );
  }
}
