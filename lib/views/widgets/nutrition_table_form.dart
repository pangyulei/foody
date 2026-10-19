import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../l10n/app_strings.dart';
import '../../models/diet_log.dart';
import '../../models/food.dart';
import '../../models/premade_food.dart';
import 'nutrition_preview_card.dart';
import 'quick_food_selector.dart';

class NutritionTableForm extends StatefulWidget {
  final DietLog? initialLog;
  final Function(DietLog log) onSubmit;

  const NutritionTableForm({
    super.key,
    this.initialLog,
    required this.onSubmit,
  });

  @override
  State<NutritionTableForm> createState() => _NutritionTableFormState();
}

class _NutritionTableFormState extends State<NutritionTableForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _totalAmountController; // 单份容量 (如 200)
  late TextEditingController _unitAmountController; // 成分表基准 (如 100)
  late TextEditingController _carbsController; // 每基准份量碳水
  late TextEditingController _proteinController; // 每基准份量蛋白质
  late TextEditingController _fatController; // 每基准份量脂肪
  late TextEditingController _kjController; // 每基准份量能量
  late TextEditingController _quantityController; // 食用数量
  late TextEditingController _noteController;

  String _unitName = 'ml'; // ml / g / 份
  late DateTime _selectedDateTime;
  Food? _selectedFood;

  @override
  void initState() {
    super.initState();
    final log = widget.initialLog;
    final food = log?.food;
    _selectedFood = food;
    _nameController = TextEditingController(text: food?.name ?? '');
    _totalAmountController = TextEditingController(text: '200');
    _unitAmountController = TextEditingController(text: '100');
    _carbsController = TextEditingController();
    _proteinController = TextEditingController();
    _fatController = TextEditingController();
    _kjController = TextEditingController();
    _quantityController = TextEditingController(
      text: _formatNumber(log?.quantity ?? 1.0),
    );
    _noteController = TextEditingController(text: log?.note ?? '');
    _selectedDateTime = log?.createTime ?? DateTime.now();

    if (food != null) {
      _applyFood(food);
    }

    _totalAmountController.addListener(() => setState(() {}));
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
    _totalAmountController.dispose();
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

    final premade = food is PremadeFood ? food : null;
    final serving = (premade != null && premade.servingAmount > 0)
        ? premade.servingAmount
        : 100.0;
    final basis = (premade != null && premade.basisAmount > 0)
        ? premade.basisAmount
        : 100.0;
    if (premade != null &&
        (premade.unitName == 'ml' ||
            premade.unitName == 'g' ||
            premade.unitName == '份')) {
      _unitName = premade.unitName;
    } else {
      _unitName = '份';
    }

    final ratio = basis / serving;
    _totalAmountController.text = _formatNumber(serving);
    _unitAmountController.text = _formatNumber(basis);
    _kjController.text = _formatNumber(food.kj * ratio);
    _carbsController.text = _formatNumber(food.carbs * ratio);
    _proteinController.text = _formatNumber(food.protein * ratio);
    _fatController.text = _formatNumber(food.fat * ratio);

    if (resetQuantity) {
      _quantityController.text = '1.0';
      _noteController.text = '';
    }
  }

  void _populateFromHistory(Food food) {
    setState(() {
      _applyFood(food, resetQuantity: true);
    });

    final t = AppStrings.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(t.filledFromHistoryTable(food.name)),
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

  void _updateQuantity(double delta) {
    final current = double.tryParse(_quantityController.text.trim()) ?? 1.0;
    final updated = (current + delta).clamp(0.1, 99.0);
    setState(() {
      _quantityController.text = _formatNumber(updated);
    });
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final t = AppStrings.of(context);
      final servingAmount =
          double.tryParse(_totalAmountController.text.trim()) ?? 100.0;
      final basisAmount =
          double.tryParse(_unitAmountController.text.trim()) ?? 100.0;
      final quantity = double.tryParse(_quantityController.text.trim()) ?? 1.0;

      // 单份营养 = 成分表数值 × (单份容量 / 基准份量)
      final perServingMultiplier = basisAmount > 0
          ? servingAmount / basisAmount
          : 1.0;

      final rawCarbs = double.tryParse(_carbsController.text.trim()) ?? 0.0;
      final rawProtein = double.tryParse(_proteinController.text.trim()) ?? 0.0;
      final rawFat = double.tryParse(_fatController.text.trim()) ?? 0.0;
      final rawKj = double.tryParse(_kjController.text.trim()) ?? 0.0;

      final existingFood = _selectedFood;
      final food = PremadeFood(
        id: existingFood is PremadeFood ? existingFood.id : 0,
        name: _nameController.text.trim(),
        kj: rawKj * perServingMultiplier,
        carbs: rawCarbs * perServingMultiplier,
        protein: rawProtein * perServingMultiplier,
        fat: rawFat * perServingMultiplier,
        servingAmount: servingAmount,
        basisAmount: basisAmount,
        unitName: _unitName,
      );

      final totalConsumedAmount = servingAmount * quantity;
      final unitLabel = _unitName == '份' ? t.unitServing : _unitName;
      final noteText = _noteController.text.trim().isNotEmpty
          ? _noteController.text.trim()
          : t.generatedNote(
              totalConsumedAmount.toStringAsFixed(0),
              unitLabel,
              servingAmount.toStringAsFixed(0),
              unitLabel,
              quantity.toString(),
              t.unitServing,
            );

      final log = DietLog.withFood(
        id: widget.initialLog?.id ?? 0,
        food: food,
        quantity: quantity,
        createTime: _selectedDateTime,
        note: noteText,
      );

      widget.onSubmit(log);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppStrings.of(context);
    final unitLabel = _unitName == '份' ? t.unitServing : _unitName;
    final totalAmount =
        double.tryParse(_totalAmountController.text.trim()) ?? 0.0;
    final unitAmount =
        double.tryParse(_unitAmountController.text.trim()) ?? 100.0;
    final quantity = double.tryParse(_quantityController.text.trim()) ?? 1.0;

    final totalConsumedAmount = totalAmount * quantity;
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
          QuickFoodSelector(onFoodSelected: _populateFromHistory),

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
          Card(
            elevation: 0,
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  const Icon(Icons.format_list_numbered),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      t.servings,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  IconButton.filledTonal(
                    icon: const Icon(Icons.remove),
                    onPressed: () => _updateQuantity(-0.5),
                  ),
                  SizedBox(
                    width: 60,
                    child: TextFormField(
                      controller: _quantityController,
                      textAlign: TextAlign.center,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 8),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton.filledTonal(
                    icon: const Icon(Icons.add),
                    onPressed: () => _updateQuantity(0.5),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 1. 份量与计量单位
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
                    t.servingSection,
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
                      ButtonSegment(value: '份', label: Text(t.unitServing)),
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
                          controller: _totalAmountController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
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
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
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

          // 2. 营养成分表数值 (能量, 碳水, 蛋白质, 脂肪 每一个独占一行，竖着排)
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
                      _unitAmountController.text.isEmpty
                          ? '100'
                          : _unitAmountController.text,
                      unitLabel,
                    ),
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 能量 (独占一行)
                  TextFormField(
                    controller: _kjController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: t.energyKj,
                      hintText: t.tableEnergyHint,
                      suffixText: 'kJ',
                      prefixIcon: const Icon(
                        Icons.local_fire_department_outlined,
                      ),
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

                  // 碳水化合物 (独占一行)
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

                  // 蛋白质 (独占一行)
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

                  // 脂肪 (独占一行)
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

          // 底部实际摄入总量预览
          NutritionPreviewCard(
            title: t.calculatedIntakeTitle,
            subtitle: t.calculatedIntakeSubtitle(
              totalConsumedAmount.toStringAsFixed(0),
              unitLabel,
              multiplier.toStringAsFixed(2),
            ),
            totalKj: calculatedKj,
            totalCarbs: calculatedCarbs,
            totalProtein: calculatedProtein,
            totalFat: calculatedFat,
          ),
          const SizedBox(height: 16),

          // 备注
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

          // 时间选择
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
          const SizedBox(height: 24),

          // 提交按钮
          FilledButton.icon(
            onPressed: _submit,
            icon: const Icon(Icons.check),
            label: Text(
              widget.initialLog == null ? t.saveRecord : t.updateRecord,
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
