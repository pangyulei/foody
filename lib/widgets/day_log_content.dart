import 'package:flutter/material.dart';

import '../extensions/diet_log_extensions.dart';
import '../l10n/app_strings.dart';
import '../models/app_settings.dart';
import '../models/diet_log.dart';
import '../pages/add_food/add_food_page.dart';
import 'daily_summary_card.dart';
import 'food_item_tile.dart';
import 'quick_add_sheet.dart';

/// Shared day view used by Today and by a history day detail page.
class DayLogContentView extends StatelessWidget {
  final List<DietLog> logs;
  final DateTime date;
  final String summaryTitle;
  final String emptyMessage;
  final AppSettings? goals;
  final ValueChanged<int> onDeleteLog;
  final double bottomPadding;

  const DayLogContentView({
    super.key,
    required this.logs,
    required this.date,
    required this.summaryTitle,
    required this.emptyMessage,
    this.goals,
    required this.onDeleteLog,
    this.bottomPadding = 88,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppStrings.of(context);

    return CustomScrollView(
      slivers: [
        // 当日统计
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: DailySummaryCard(
              totalKj: logs.totalKj,
              totalCarbs: logs.totalCarbs,
              totalProtein: logs.totalProtein,
              totalFat: logs.totalFat,
              title: summaryTitle,
              goals: goals,
            ),
          ),
        ),

        // 记录标题栏
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  t.foodLogCount(logs.length),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  onPressed: () => showQuickAddSheet(context, date),
                  icon: const Icon(Icons.history, size: 18),
                  label: Text(t.recentFoods),
                ),
              ],
            ),
          ),
        ),

        // 记录列表 / 空状态
        if (logs.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.no_meals_outlined,
                    size: 64,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    emptyMessage,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.outline,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final log = logs[index];
              return FoodItemTile(
                log: log,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => AddFoodPage(initialLog: log),
                    ),
                  );
                },
                onDelete: () => onDeleteLog(log.id),
              );
            }, childCount: logs.length),
          ),

        SliverPadding(padding: EdgeInsets.only(bottom: bottomPadding)),
      ],
    );
  }
}
