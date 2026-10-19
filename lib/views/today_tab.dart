import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../bloc/food_bloc.dart';
import '../bloc/food_event.dart';
import '../bloc/food_state.dart';
import '../bloc/settings_cubit.dart';
import '../extensions/diet_log_extensions.dart';
import '../l10n/app_strings.dart';
import '../models/app_settings.dart';
import 'add_food_screen.dart';
import 'widgets/daily_summary_card.dart';
import 'widgets/error_view.dart';
import 'widgets/food_item_tile.dart';
import 'widgets/quick_add_sheet.dart';

class TodayTab extends StatelessWidget {
  const TodayTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodBloc, FoodState>(
      builder: (context, state) {
        if (state is FoodLoading || state is FoodInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is FoodError) {
          return LoadErrorView(
            detail: state.message,
            onRetry: () {
              context.read<FoodBloc>().add(const LoadDietLogs());
            },
          );
        }

        if (state is! FoodLoaded) {
          return const SizedBox.shrink();
        }

        return BlocBuilder<SettingsCubit, AppSettings>(
          builder: (context, settings) {
            final t = AppStrings.of(context);
            final now = DateTime.now();
            final logs = state.todayLogs;

            return CustomScrollView(
              slivers: [
                // 今天日期
                SliverToBoxAdapter(
                  child: Container(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest
                        .withAlpha(128),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.today, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          t.todayWithDate(DateFormat('yyyy-MM-dd').format(now)),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // 今日统计
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: DailySummaryCard(
                      totalKj: logs.totalKj,
                      totalCarbs: logs.totalCarbs,
                      totalProtein: logs.totalProtein,
                      totalFat: logs.totalFat,
                      title: t.intakeToday,
                      goals: settings,
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
                          onPressed: () => showQuickAddSheet(context, now),
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
                            t.emptyToday,
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
                              builder: (_) => AddFoodScreen(initialLog: log),
                            ),
                          );
                        },
                        onDelete: () {
                          context.read<FoodBloc>().add(DeleteDietLog(log.id));
                        },
                      );
                    }, childCount: logs.length),
                  ),

                const SliverPadding(padding: EdgeInsets.only(bottom: 88)),
              ],
            );
          },
        );
      },
    );
  }
}
