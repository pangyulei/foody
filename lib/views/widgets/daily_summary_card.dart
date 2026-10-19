import 'package:flutter/material.dart';

import '../../utils/energy_converter.dart';

class DailySummaryCard extends StatelessWidget {
  final double totalKj;
  final double totalCarbs;
  final double totalProtein;
  final double totalFat;

  const DailySummaryCard({
    super.key,
    required this.totalKj,
    required this.totalCarbs,
    required this.totalProtein,
    required this.totalFat,
  });

  @override
  Widget build(BuildContext context) {
    final totalKcal = EnergyConverter.kjToKcal(totalKj);

    // 计算三大营养素热量占比 (碳水 4kcal/g, 蛋白质 4kcal/g, 脂肪 9kcal/g)
    final carbsKcal = totalCarbs * 4.0;
    final proteinKcal = totalProtein * 4.0;
    final fatKcal = totalFat * 9.0;
    final macroTotalKcal = carbsKcal + proteinKcal + fatKcal;

    final carbsRatio = macroTotalKcal > 0 ? (carbsKcal / macroTotalKcal) : 0.0;
    final proteinRatio = macroTotalKcal > 0
        ? (proteinKcal / macroTotalKcal)
        : 0.0;
    final fatRatio = macroTotalKcal > 0 ? (fatKcal / macroTotalKcal) : 0.0;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 主卡路里数值
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '今日已摄入',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          totalKcal.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'kcal (卡路里)',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 三大营养素进度条
            if (macroTotalKcal > 0) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: SizedBox(
                  height: 8,
                  child: Row(
                    children: [
                      if (carbsRatio > 0)
                        Expanded(
                          flex: (carbsRatio * 100).round(),
                          child: Container(color: Colors.blue),
                        ),
                      if (proteinRatio > 0)
                        Expanded(
                          flex: (proteinRatio * 100).round(),
                          child: Container(color: Colors.orange),
                        ),
                      if (fatRatio > 0)
                        Expanded(
                          flex: (fatRatio * 100).round(),
                          child: Container(color: Colors.redAccent),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // 营养素数据三元组
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMacroItem(
                  context,
                  label: '碳水化合物',
                  value: '${totalCarbs.toStringAsFixed(1)} g',
                  color: Colors.blue,
                ),
                _buildMacroItem(
                  context,
                  label: '蛋白质',
                  value: '${totalProtein.toStringAsFixed(1)} g',
                  color: Colors.orange,
                ),
                _buildMacroItem(
                  context,
                  label: '脂肪',
                  value: '${totalFat.toStringAsFixed(1)} g',
                  color: Colors.redAccent,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroItem(
    BuildContext context, {
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
