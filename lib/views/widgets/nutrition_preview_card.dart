import 'package:flutter/material.dart';

import '../../l10n/app_strings.dart';
import '../../utils/energy_converter.dart';

/// 两种输入方式共用的“实际摄入总量”预览卡片。
class NutritionPreviewCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final double totalKj;
  final double totalCarbs;
  final double totalProtein;
  final double totalFat;

  const NutritionPreviewCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.totalKj,
    required this.totalCarbs,
    required this.totalProtein,
    required this.totalFat,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppStrings.of(context);
    final totalKcal = EnergyConverter.kjToKcal(totalKj);

    return Card(
      color: Theme.of(context).colorScheme.primaryContainer.withAlpha(180),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      if (subtitle != null && subtitle!.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  t.intakeCalories,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Text(
                  '${totalKcal.toStringAsFixed(1)} kcal',
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
                _MacroChip(label: t.shortCarbs, value: totalCarbs),
                _MacroChip(label: t.shortProtein, value: totalProtein),
                _MacroChip(label: t.shortFat, value: totalFat),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MacroChip extends StatelessWidget {
  final String label;
  final double value;

  const _MacroChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: CircleAvatar(
        child: Text(
          label.substring(0, 1),
          style: const TextStyle(fontSize: 10),
        ),
      ),
      label: Text('$label: ${value.toStringAsFixed(1)}g'),
      visualDensity: VisualDensity.compact,
    );
  }
}
