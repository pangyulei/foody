import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../extensions/meal_extensions.dart';
import '../../../l10n/app_strings.dart';
import '../../../models/meal.dart';

class DailyMealSummaryTile extends StatelessWidget {
  /// All meals from a single day.
  final List<Meal> meals;
  final VoidCallback onTap;

  const DailyMealSummaryTile({
    super.key,
    required this.meals,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppStrings.of(context);
    final date = DateFormat('yyyy-MM-dd').format(meals.date);

    return Card(
      elevation: 1,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _isToday(meals.date) ? t.todayWithDate(date) : date,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Text(
                    '${meals.totalKcal.toStringAsFixed(0)} kcal',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.chevron_right,
                    size: 20,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 4,
                      children: [
                        _MacroValue(
                          label: t.shortCarbs,
                          grams: meals.totalCarbs,
                          color: Colors.blue,
                        ),
                        _MacroValue(
                          label: t.shortProtein,
                          grams: meals.totalProtein,
                          color: Colors.orange,
                        ),
                        _MacroValue(
                          label: t.shortFat,
                          grams: meals.totalFat,
                          color: Colors.redAccent,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    t.entryCount(meals.mealCount),
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}

class _MacroValue extends StatelessWidget {
  final String label;
  final double grams;
  final Color color;

  const _MacroValue({
    required this.label,
    required this.grams,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          '$label ${grams.toStringAsFixed(1)}g',
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
