import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../l10n/app_strings.dart';
import '../../../models/custom_food.dart';
import '../../../models/diet_log.dart';
import '../../../models/food.dart';
import 'nutrition_preview_card.dart';
import 'quick_food_selector.dart';

class DirectInputForm extends StatefulWidget {
  final DietLog? initialLog;
  final Food? initialFood;
  final bool catalogueMode;
  final DateTime? initialDate;
  final Function(Food food, DietLog log) onSubmit;

  const DirectInputForm({
    super.key,
    this.initialLog,
    this.initialFood,
    this.catalogueMode = false,
    this.initialDate,
    required this.onSubmit,
  });

  @override
  State<DirectInputForm> createState() => _DirectInputFormState();
}

class _DirectInputFormState extends State<DirectInputForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _kjController;
  late TextEditingController _carbsController;
  late TextEditingController _proteinController;
  late TextEditingController _fatController;
  late TextEditingController _quantityController;
  late TextEditingController _noteController;

  late DateTime _selectedDateTime;
  Food? _selectedFood;

  @override
  void initState() {
    super.initState();
    final log = widget.initialLog;
    final food = widget.initialFood;
    _selectedFood = food;
    _nameController = TextEditingController(
      text: food?.name ?? log?.foodName ?? '',
    );
    _kjController = TextEditingController(
      text: food != null
          ? _formatNumber(food.kj)
          : (log == null ? '' : _formatNumber(log.kj)),
    );
    _carbsController = TextEditingController(
      text: food != null
          ? _formatNumber(food.carbs)
          : (log == null ? '' : _formatNumber(log.carbs)),
    );
    _proteinController = TextEditingController(
      text: food != null
          ? _formatNumber(food.protein)
          : (log == null ? '' : _formatNumber(log.protein)),
    );
    _fatController = TextEditingController(
      text: food != null
          ? _formatNumber(food.fat)
          : (log == null ? '' : _formatNumber(log.fat)),
    );
    _quantityController = TextEditingController(
      text: _formatNumber(log?.quantity ?? 1.0),
    );
    _noteController = TextEditingController(text: log?.note ?? '');
    _selectedDateTime = log?.createTime ?? widget.initialDate ?? DateTime.now();

    _kjController.addListener(() => setState(() {}));
    _quantityController.addListener(() => setState(() {}));
    _carbsController.addListener(() => setState(() {}));
    _proteinController.addListener(() => setState(() {}));
    _fatController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _kjController.dispose();
    _carbsController.dispose();
    _proteinController.dispose();
    _fatController.dispose();
    _quantityController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  String _formatNumber(double value) {
    if (value == 0) return '0';
    if (value == value.roundToDouble()) return value.toInt().toString();
    return value.toString();
  }

  /// 快速导入历史食物
  void _populateFromHistory(Food food) {
    setState(() {
      _selectedFood = food;
      _nameController.text = food.name;
      _kjController.text = _formatNumber(food.kj);
      _carbsController.text = _formatNumber(food.carbs);
      _proteinController.text = _formatNumber(food.protein);
      _fatController.text = _formatNumber(food.fat);
      _quantityController.text = '1';
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

  void _updateQuantity(int delta) {
    final current = int.tryParse(_quantityController.text.trim()) ?? 1;
    final updated = current + delta;
    setState(() {
      _quantityController.text = (updated < 1 ? 1 : updated).toString();
    });
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final unitKj = double.tryParse(_kjController.text.trim()) ?? 0.0;
      final unitCarbs = double.tryParse(_carbsController.text.trim()) ?? 0.0;
      final unitProtein =
          double.tryParse(_proteinController.text.trim()) ?? 0.0;
      final unitFat = double.tryParse(_fatController.text.trim()) ?? 0.0;
      final quantity = int.tryParse(_quantityController.text.trim()) ?? 1;

      final existingFood = _selectedFood;
      final food = CustomFood(
        id: existingFood is CustomFood ? existingFood.id : 0,
        name: _nameController.text.trim(),
        kj: unitKj,
        carbs: unitCarbs,
        protein: unitProtein,
        fat: unitFat,
        lastUsedTime: existingFood?.lastUsedTime,
      );

      final log = DietLog.fromFood(
        id: widget.initialLog?.id ?? 0,
        food: food,
        quantity: quantity.toDouble(),
        createTime: _selectedDateTime,
        note: _noteController.text.trim().isEmpty
            ? null
            : _noteController.text.trim(),
      );

      widget.onSubmit(food, log);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppStrings.of(context);
    final unitKj = double.tryParse(_kjController.text.trim()) ?? 0.0;
    final unitCarbs = double.tryParse(_carbsController.text.trim()) ?? 0.0;
    final unitProtein = double.tryParse(_proteinController.text.trim()) ?? 0.0;
    final unitFat = double.tryParse(_fatController.text.trim()) ?? 0.0;
    final quantity = double.tryParse(_quantityController.text.trim()) ?? 1.0;
    final totalKj = unitKj * quantity;
    final totalCarbs = unitCarbs * quantity;
    final totalProtein = unitProtein * quantity;
    final totalFat = unitFat * quantity;

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          if (!widget.catalogueMode)
            QuickFoodSelector(onFoodSelected: _populateFromHistory),

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

          if (!widget.catalogueMode) ...[
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
                      onPressed: () => _updateQuantity(-1),
                    ),
                    SizedBox(
                      width: 72,
                      child: TextFormField(
                        controller: _quantityController,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
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
                    IconButton.filledTonal(
                      icon: const Icon(Icons.add),
                      onPressed: () => _updateQuantity(1),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // 营养成分数值 (每份)
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
                    t.directNutritionSection,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    t.directNutritionSubtitle,
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
                      hintText: t.energyPerServingHint,
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
                      hintText: t.carbsHint,
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
                      hintText: t.proteinHint,
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
                      hintText: t.fatHint,
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
                : t.directCalculatedIntakeSubtitle(_formatNumber(quantity)),
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
                  : (widget.initialLog == null ? t.saveRecord : t.updateRecord),
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
