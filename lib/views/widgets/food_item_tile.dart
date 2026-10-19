import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../l10n/app_strings.dart';
import '../../models/diet_log.dart';
import '../../models/premade_food.dart';
import '../../utils/energy_converter.dart';

class FoodItemTile extends StatelessWidget {
  final DietLog log;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const FoodItemTile({
    super.key,
    required this.log,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppStrings.of(context);
    final food = log.food;
    final name = food?.name ?? '';
    final formattedTime = DateFormat('HH:mm').format(log.createTime);
    final isPremade = food is PremadeFood;
    final hasQuantity = log.quantity > 0 && (log.quantity - 1.0).abs() > 0.01;

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
                    ? '$name × ${log.quantity % 1 == 0 ? log.quantity.toInt() : log.quantity}'
                    : name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: isPremade
                    ? Colors.teal.withAlpha(40)
                    : Colors.deepOrange.withAlpha(40),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                isPremade ? t.modeTable : t.modeDirect,
                style: TextStyle(
                  fontSize: 11,
                  color: isPremade ? Colors.teal[800] : Colors.deepOrange[800],
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
                  EnergyConverter.formatKcal(log.kj),
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
              t.macrosLine(log.carbs, log.protein, log.fat),
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            if (log.note != null && log.note!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                '${t.notePrefix}${log.note}',
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
