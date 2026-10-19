import 'package:flutter/material.dart';

import '../l10n/app_strings.dart';
import '../models/app_settings.dart';
import '../utils/energy_converter.dart';

class DailySummaryCard extends StatelessWidget {
  final double totalKj;
  final double totalCarbs;
  final double totalProtein;
  final double totalFat;
  final String title;

  /// 为空或未启用时不显示目标进度圆环
  final AppSettings? goals;

  const DailySummaryCard({
    super.key,
    required this.totalKj,
    required this.totalCarbs,
    required this.totalProtein,
    required this.totalFat,
    required this.title,
    this.goals,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppStrings.of(context);
    final totalKcal = EnergyConverter.kjToKcal(totalKj);
    final activeGoals = (goals?.hasGoals ?? false) ? goals : null;

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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
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
                          Flexible(
                            child: Text(
                              totalKcal.toStringAsFixed(1),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            t.kcalUnit,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (activeGoals != null && activeGoals.targetKcal > 0)
                  _GoalRing(
                    value: totalKcal,
                    target: activeGoals.targetKcal,
                    color: Theme.of(context).colorScheme.primary,
                    size: 46,
                    tooltip: t.goalCaloriesTooltip(activeGoals.targetKcal),
                    showPercent: true,
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

            // 营养素数据
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildMacroItem(
                    context,
                    t: t,
                    label: t.carbs,
                    amount: totalCarbs,
                    color: Colors.blue,
                    target: activeGoals?.targetCarbs,
                  ),
                ),
                Expanded(
                  child: _buildMacroItem(
                    context,
                    t: t,
                    label: t.protein,
                    amount: totalProtein,
                    color: Colors.orange,
                    target: activeGoals?.targetProtein,
                  ),
                ),
                Expanded(
                  child: _buildMacroItem(
                    context,
                    t: t,
                    label: t.fat,
                    amount: totalFat,
                    color: Colors.redAccent,
                    target: activeGoals?.targetFat,
                  ),
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
    required AppStrings t,
    required String label,
    required double amount,
    required Color color,
    required double? target,
  }) {
    final showGoal = target != null && target > 0;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                '${amount.toStringAsFixed(1)} g',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (showGoal) ...[
              const SizedBox(width: 6),
              _GoalRing(
                value: amount,
                target: target,
                color: color,
                size: 28,
                tooltip: t.goalTooltip(target),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

/// 小圆形目标进度
class _GoalRing extends StatelessWidget {
  final double value;
  final double target;
  final Color color;
  final double size;
  final String tooltip;
  final bool showPercent;

  const _GoalRing({
    required this.value,
    required this.target,
    required this.color,
    required this.size,
    required this.tooltip,
    this.showPercent = false,
  });

  @override
  Widget build(BuildContext context) {
    final progress = target > 0 ? (value / target).clamp(0.0, 1.0) : 0.0;

    return Tooltip(
      message: tooltip,
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: [
            CircularProgressIndicator(
              value: progress,
              strokeWidth: showPercent ? 4 : 3,
              backgroundColor: color.withAlpha(45),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
            if (showPercent)
              Center(
                child: Text(
                  '${(value / target * 100).clamp(0, 999).toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: size * 0.2,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
