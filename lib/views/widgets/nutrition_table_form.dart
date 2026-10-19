import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/food_entry.dart';
import '../../utils/energy_converter.dart';
import 'quick_food_selector.dart';

class NutritionTableForm extends StatefulWidget {
  final FoodEntry? initialEntry;
  final Function(FoodEntry entry) onSubmit;

  const NutritionTableForm({
    super.key,
    this.initialEntry,
    required this.onSubmit,
  });

  @override
  State<NutritionTableForm> createState() => _NutritionTableFormState();
}

class _NutritionTableFormState extends State<NutritionTableForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _totalAmountController; // 食用总量 (如 200)
  late TextEditingController _unitAmountController; // 参考份量 (如 100)
  late TextEditingController _carbsController; // 每参考份量碳水
  late TextEditingController _proteinController; // 每参考份量蛋白质
  late TextEditingController _fatController; // 每参考份量脂肪
  late TextEditingController _kjController; // 每参考份量能量
  late TextEditingController _quantityController; // 食品数量 (如 1.0, 2.0)
  late TextEditingController _noteController;

  String _unitName = 'ml'; // ml / g / 份
  late DateTime _selectedDateTime;

  @override
  void initState() {
    super.initState();
    final entry = widget.initialEntry;
    _nameController = TextEditingController(text: entry?.name ?? '');
    _totalAmountController = TextEditingController(text: '200');
    _unitAmountController = TextEditingController(text: '100');
    _carbsController = TextEditingController();
    _proteinController = TextEditingController();
    _fatController = TextEditingController();
    _kjController = TextEditingController();
    _quantityController = TextEditingController(
      text: entry?.quantity.toString() ?? '1.0',
    );
    _noteController = TextEditingController(text: entry?.note ?? '');
    _selectedDateTime = entry?.createTime ?? DateTime.now();

    // 如果编辑现有条目
    if (entry != null && entry.inputMode == 'table') {
      _kjController.text = entry.kj.toString();
      _carbsController.text = entry.carbs.toString();
      _proteinController.text = entry.protein.toString();
      _fatController.text = entry.fat.toString();
      _totalAmountController.text = '100';
      _unitAmountController.text = '100';
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

  void _populateFromHistory(FoodEntry history) {
    setState(() {
      _nameController.text = history.name;
      _kjController.text = history.kj.toStringAsFixed(1);
      _carbsController.text = history.carbs.toStringAsFixed(1);
      _proteinController.text = history.protein.toStringAsFixed(1);
      _fatController.text = history.fat.toStringAsFixed(1);
      _totalAmountController.text = '100';
      _unitAmountController.text = '100';
      _quantityController.text = '1.0';
      _noteController.text = history.note ?? '';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('已自动填入历史成分表食品: ${history.name}'),
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
      final totalAmount =
          double.tryParse(_totalAmountController.text.trim()) ?? 100.0;
      final unitAmount =
          double.tryParse(_unitAmountController.text.trim()) ?? 100.0;
      final quantity = double.tryParse(_quantityController.text.trim()) ?? 1.0;

      // 综合消耗总量 = 单次容量/份量 * 数量
      final totalConsumedAmount = totalAmount * quantity;
      final multiplier = unitAmount > 0
          ? totalConsumedAmount / unitAmount
          : 1.0;

      final rawCarbs = double.tryParse(_carbsController.text.trim()) ?? 0.0;
      final rawProtein = double.tryParse(_proteinController.text.trim()) ?? 0.0;
      final rawFat = double.tryParse(_fatController.text.trim()) ?? 0.0;
      final rawKj = double.tryParse(_kjController.text.trim()) ?? 0.0;

      final calculatedKj = rawKj * multiplier;
      final calculatedCarbs = rawCarbs * multiplier;
      final calculatedProtein = rawProtein * multiplier;
      final calculatedFat = rawFat * multiplier;

      final noteText = _noteController.text.trim().isNotEmpty
          ? _noteController.text.trim()
          : '食用${totalConsumedAmount.toStringAsFixed(0)}$_unitName (${totalAmount.toStringAsFixed(0)}$_unitName/份 × $quantity份)';

      final entry = FoodEntry(
        id: widget.initialEntry?.id ?? 0,
        name: _nameController.text.trim(),
        createTime: _selectedDateTime,
        kj: calculatedKj,
        carbs: calculatedCarbs,
        protein: calculatedProtein,
        fat: calculatedFat,
        inputMode: 'table',
        quantity: quantity,
        note: noteText,
      );

      widget.onSubmit(entry);
    }
  }

  @override
  Widget build(BuildContext context) {
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
    final calculatedKcal = EnergyConverter.kjToKcal(calculatedKj);
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
            decoration: const InputDecoration(
              labelText: '食品名称',
              hintText: '如：特仑苏纯牛奶、无糖酸奶',
              prefixIcon: Icon(Icons.shopping_bag_outlined),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '1. 单份与计量单位',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      SegmentedButton<String>(
                        segments: const [
                          ButtonSegment(value: 'ml', label: Text('ml')),
                          ButtonSegment(value: 'g', label: Text('g')),
                          ButtonSegment(value: '份', label: Text('份')),
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
                    ],
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
                            labelText: '单份容量/重量',
                            hintText: '例：200',
                            suffixText: _unitName,
                            border: const OutlineInputBorder(),
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return '请输入容量';
                            if (double.tryParse(v.trim()) == null) {
                              return '请输入有效数字';
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
                            labelText: '成分表基准份量',
                            hintText: '例：100',
                            suffixText: _unitName,
                            border: const OutlineInputBorder(),
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return '请输入基准';
                            if (double.tryParse(v.trim()) == null) {
                              return '请输入有效数字';
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
                    '2. 营养成分表数值 (按每 ${_unitAmountController.text.isEmpty ? "100" : _unitAmountController.text}$_unitName 标注的数值输入)',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 能量 (独占一行)
                  TextFormField(
                    controller: _kjController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: '能量 (kJ)',
                      hintText: '输入成分表上的能量数值',
                      suffixText: 'kJ',
                      prefixIcon: Icon(Icons.local_fire_department_outlined),
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return '请输入能量';
                      if (double.tryParse(v.trim()) == null) return '请输入有效数字';
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
                    decoration: const InputDecoration(
                      labelText: '碳水化合物 (g)',
                      hintText: '输入成分表上的碳水化合物克数',
                      prefixIcon: Icon(Icons.grain),
                      suffixText: 'g',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 蛋白质 (独占一行)
                  TextFormField(
                    controller: _proteinController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: '蛋白质 (g)',
                      hintText: '输入成分表上的蛋白质克数',
                      prefixIcon: Icon(Icons.fitness_center),
                      suffixText: 'g',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 脂肪 (独占一行)
                  TextFormField(
                    controller: _fatController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: '脂肪 (g)',
                      hintText: '输入成分表上的脂肪克数',
                      prefixIcon: Icon(Icons.opacity),
                      suffixText: 'g',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 实时换算预览卡片
          Card(
            color: Theme.of(context).colorScheme.primaryContainer
                .withAlpha(180),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.analytics_outlined,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '自动换算实际摄入总量 (共 ${totalConsumedAmount.toStringAsFixed(0)}$_unitName, 倍率: ${multiplier.toStringAsFixed(2)}x)',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const Divider(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '摄入卡路里:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      Text(
                        '${calculatedKcal.toStringAsFixed(1)} kcal',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 12,
                    children: [
                      Chip(
                        avatar: const CircleAvatar(
                          child: Text('碳', style: TextStyle(fontSize: 10)),
                        ),
                        label: Text(
                          '碳水: ${calculatedCarbs.toStringAsFixed(1)}g',
                        ),
                        visualDensity: VisualDensity.compact,
                      ),
                      Chip(
                        avatar: const CircleAvatar(
                          child: Text('蛋', style: TextStyle(fontSize: 10)),
                        ),
                        label: Text(
                          '蛋白质: ${calculatedProtein.toStringAsFixed(1)}g',
                        ),
                        visualDensity: VisualDensity.compact,
                      ),
                      Chip(
                        avatar: const CircleAvatar(
                          child: Text('脂', style: TextStyle(fontSize: 10)),
                        ),
                        label: Text('脂肪: ${calculatedFat.toStringAsFixed(1)}g'),
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 备注
          TextFormField(
            controller: _noteController,
            decoration: const InputDecoration(
              labelText: '自定义备注 (可选)',
              hintText: '如不填则自动生成',
              prefixIcon: Icon(Icons.edit_note),
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
