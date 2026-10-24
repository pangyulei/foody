import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../l10n/app_strings.dart';
import '../models/meal.dart';
import '../utils/energy_converter.dart';

class FoodItemTile extends StatelessWidget {
  final Meal meal;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const FoodItemTile({
    super.key,
    required this.meal,
    required this.onTap,
    required this.onDelete,
  });

  String _formatAmount(double value) {
    if (value == value.roundToDouble()) return value.toInt().toString();
    return value.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppStrings.of(context);
    final name = meal.foodName;
    final formattedTime = DateFormat('HH:mm').format(meal.createTime);
    final isPackaged = meal is PackagedMeal;
    final amountLabel = switch (meal) {
      PackagedMeal(:final quantity) =>
        quantity > 0 && (quantity - 1.0).abs() > 0.01
            ? ' × ${_formatAmount(quantity)}'
            : '',
      CustomMeal(:final netContent, :final food) =>
        ' · ${_formatAmount(netContent)}${food.unitName}',
    };

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
                '$name$amountLabel',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: isPackaged
                    ? Colors.teal.withAlpha(40)
                    : Colors.deepOrange.withAlpha(40),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                isPackaged ? t.foodTypePackaged : t.foodTypeCustom,
                style: TextStyle(
                  fontSize: 11,
                  color: isPackaged ? Colors.teal[800] : Colors.deepOrange[800],
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
                  EnergyConverter.formatKcal(meal.totalKj),
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
              t.macrosLine(meal.totalCarbs, meal.totalProtein, meal.totalFat),
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            if (meal.note != null && meal.note!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                '${t.notePrefix}${meal.note}',
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
                title: Text(t.confirmDelete),
                content: Text(t.deleteMessage(name)),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: Text(t.cancel),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      onDelete();
                    },
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                    child: Text(t.delete),
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
