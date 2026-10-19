import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/food_entry.dart';
import '../../utils/energy_converter.dart';
import 'quick_food_selector.dart';

class DirectInputForm extends StatefulWidget {
  final FoodEntry? initialEntry;
  final Function(FoodEntry entry) onSubmit;

  const DirectInputForm({super.key, this.initialEntry, required this.onSubmit});

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

  @override
  void initState() {
    super.initState();
    final entry = widget.initialEntry;
    _nameController = TextEditingController(text: entry?.name ?? '');
    _kjController = TextEditingController(text: entry?.kj.toString() ?? '');
    _carbsController = TextEditingController(
      text: entry?.carbs.toString() ?? '',
    );
    _proteinController = TextEditingController(
      text: entry?.protein.toString() ?? '',
    );
    _fatController = TextEditingController(text: entry?.fat.toString() ?? '');
    _quantityController = TextEditingController(
      text: entry?.quantity.toString() ?? '1.0',
    );
    _noteController = TextEditingController(text: entry?.note ?? '');
    _selectedDateTime = entry?.createTime ?? DateTime.now();

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

  /// 快速导入历史食品
  void _populateFromHistory(FoodEntry history) {
    setState(() {
      _nameController.text = history.name;
      final histQty = history.quantity > 0 ? history.quantity : 1.0;
      _kjController.text = (history.kj / histQty).toStringAsFixed(1);
      _carbsController.text = (history.carbs / histQty).toStringAsFixed(1);
      _proteinController.text = (history.protein / histQty).toStringAsFixed(1);
      _fatController.text = (history.fat / histQty).toStringAsFixed(1);
      _noteController.text = history.note ?? '';
      _quantityController.text = '1.0';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('已自动填入历史食品: ${history.name}'),
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
      _quantityController.text = updated.toStringAsFixed(
        updated == updated.roundToDouble() ? 0 : 1,
      );
    });
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final unitKj = double.tryParse(_kjController.text.trim()) ?? 0.0;
      final unitCarbs = double.tryParse(_carbsController.text.trim()) ?? 0.0;
      final unitProtein =
          double.tryParse(_proteinController.text.trim()) ?? 0.0;
      final unitFat = double.tryParse(_fatController.text.trim()) ?? 0.0;
      final quantity = double.tryParse(_quantityController.text.trim()) ?? 1.0;

      final totalKj = unitKj * quantity;
      final totalCarbs = unitCarbs * quantity;
      final totalProtein = unitProtein * quantity;
      final totalFat = unitFat * quantity;

      final entry = FoodEntry(
        id: widget.initialEntry?.id ?? 0,
        name: _nameController.text.trim(),
        createTime: _selectedDateTime,
        kj: totalKj,
        carbs: totalCarbs,
        protein: totalProtein,
        fat: totalFat,
        inputMode: 'direct',
        quantity: quantity,
        note: _noteController.text.trim().isEmpty
            ? null
            : _noteController.text.trim(),
      );

      widget.onSubmit(entry);
    }
  }

  @override
  Widget build(BuildContext context) {
    final unitKj = double.tryParse(_kjController.text.trim()) ?? 0.0;
    final quantity = double.tryParse(_quantityController.text.trim()) ?? 1.0;
    final totalKj = unitKj * quantity;
    final totalKcal = EnergyConverter.kjToKcal(totalKj);

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
            decoration: const InputDecoration(
              labelText: '食品名称',
              hintText: '如：苹果、烤鸡胸肉、牛奶',
              prefixIcon: Icon(Icons.fastfood_outlined),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return '请输入食品名称';
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
                  const Expanded(
                    child: Text(
                      '食品数量',
                      style: TextStyle(
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

          // 1. 能量 (单份，独立占满一行)
          TextFormField(
            controller: _kjController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: '能量 (kJ 千焦)',
              hintText: '输入单份能量数值',
              prefixIcon: Icon(Icons.local_fire_department_outlined),
              suffixText: 'kJ',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return '请输入能量';
              }
              if (double.tryParse(value.trim()) == null) {
                return '请输入有效数值';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),

          // 预览卡路里换算
          Card(
            color: Theme.of(context).colorScheme.primaryContainer
                .withAlpha(150),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(
                    Icons.local_fire_department,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          quantity > 1
                              ? '卡路里小计 (单份 ${EnergyConverter.kjToKcal(unitKj).toStringAsFixed(1)} kcal × $quantity 份)'
                              : '换算卡路里',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${totalKcal.toStringAsFixed(1)} kcal',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 2. 碳水化合物 (独立占满一行)
          TextFormField(
            controller: _carbsController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: '碳水化合物 (g)',
              hintText: '输入碳水化合物克数',
              prefixIcon: Icon(Icons.grain),
              suffixText: 'g',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          // 3. 蛋白质 (独立占满一行)
          TextFormField(
            controller: _proteinController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: '蛋白质 (g)',
              hintText: '输入蛋白质克数',
              prefixIcon: Icon(Icons.fitness_center),
              suffixText: 'g',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          // 4. 脂肪 (独立占满一行)
          TextFormField(
            controller: _fatController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: '脂肪 (g)',
              hintText: '输入脂肪克数',
              prefixIcon: Icon(Icons.opacity),
              suffixText: 'g',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          // 备注
          TextFormField(
            controller: _noteController,
            decoration: const InputDecoration(
              labelText: '备注 (可选)',
              hintText: '如：早餐、1袋',
              prefixIcon: Icon(Icons.note_outlined),
              border: OutlineInputBorder(),
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
            title: const Text('记录时间'),
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
            label: Text(widget.initialEntry == null ? '保存记录' : '更新记录'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ],
      ),
    );
  }
}
