import 'package:flutter/material.dart';

import '../extensions/meal_extensions.dart';
import '../l10n/app_strings.dart';
import '../models/app_settings.dart';
import '../models/meal.dart';
import '../pages/add_food/add_food_page.dart';
import 'daily_summary_card.dart';
import 'food_item_tile.dart';
import 'quick_add_sheet.dart';

/// Shared day view used by Today and by a history day detail page.
class DayLogContentView extends StatelessWidget {
  final List<Meal> meals;
  final DateTime date;
  final String summaryTitle;
  final String emptyMessage;
  final AppSettings? goals;
  final ValueChanged<int> onDeleteLog;
  final double bottomPadding;

  const DayLogContentView({
    super.key,
    required this.meals,
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
              totalKj: meals.totalKj,
              totalCarbs: meals.totalCarbs,
              totalProtein: meals.totalProtein,
              totalFat: meals.totalFat,
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
                  t.mealCount(meals.length),
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
        if (meals.isEmpty)
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
              final meal = meals[index];
              return FoodItemTile(
                meal: meal,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => AddFoodPage(initialMeal: meal),
                    ),
                  );
                },
                onDelete: () => onDeleteLog(meal.id),
              );
            }, childCount: meals.length),
          ),

        SliverPadding(padding: EdgeInsets.only(bottom: bottomPadding)),
      ],
    );
  }
}
