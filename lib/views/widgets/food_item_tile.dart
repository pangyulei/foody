import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/food_entry.dart';
import '../../utils/energy_converter.dart';

class FoodItemTile extends StatelessWidget {
  final FoodEntry entry;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const FoodItemTile({
    super.key,
    required this.entry,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final formattedTime = DateFormat('HH:mm').format(entry.createTime);
    final isTableMode = entry.inputMode == 'table';
    final hasQuantity =
        entry.quantity > 0 && (entry.quantity - 1.0).abs() > 0.01;

    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        onTap: onTap,
        title: Row(
          children: [
            Expanded(
              child: Text(
                hasQuantity
                    ? '${entry.name} × ${entry.quantity % 1 == 0 ? entry.quantity.toInt() : entry.quantity}'
                    : entry.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: isTableMode
                    ? Colors.teal.withAlpha(40)
                    : Colors.deepOrange.withAlpha(40),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                isTableMode ? '成分表' : '直接输入',
                style: TextStyle(
                  fontSize: 11,
                  color: isTableMode
                      ? Colors.teal[800]
                      : Colors.deepOrange[800],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            // 只显示转换后的卡路里 (kcal)
            Row(
              children: [
                Text(
                  EnergyConverter.formatKcal(entry.kj),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const Spacer(),
                Text(
                  formattedTime,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            // 营养元素明细
            Text(
              '碳水: ${entry.carbs.toStringAsFixed(1)}g · 蛋白质: ${entry.protein.toStringAsFixed(1)}g · 脂肪: ${entry.fat.toStringAsFixed(1)}g',
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            if (entry.note != null && entry.note!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                '备注: ${entry.note}',
                style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            ],
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.grey),
          onPressed: () {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('确认删除'),
                content: Text('确定要删除“${entry.name}”的记录吗？'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: const Text('取消'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      onDelete();
                    },
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                    child: const Text('删除'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
