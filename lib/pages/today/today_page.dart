import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../extensions/diet_log_extensions.dart';
import '../../l10n/app_strings.dart';
import '../../repositories/diet_log_repository.dart';
import '../../widgets/daily_summary_card.dart';
import '../../widgets/error_view.dart';
import '../../widgets/food_item_tile.dart';
import '../../widgets/quick_add_sheet.dart';
import '../add_food/add_food_page.dart';
import '../settings/settings_bloc.dart';
import '../settings/settings_state.dart';
import 'today_bloc.dart';
import 'today_event.dart';
import 'today_state.dart';

class TodayPage extends StatelessWidget {
  const TodayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          TodayBloc(repository: context.read<DietLogRepository>())
            ..add(const LoadTodayLogs()),
      child: const _TodayView(),
    );
  }
}

class _TodayView extends StatelessWidget {
  const _TodayView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodayBloc, TodayState>(
      builder: (context, state) {
        if (state is TodayLoading || state is TodayInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is TodayError) {
          return LoadErrorView(
            detail: state.message,
            onRetry: () {
              context.read<TodayBloc>().add(const LoadTodayLogs());
            },
          );
        }

        if (state is! TodayLoaded) {
          return const SizedBox.shrink();
        }

        return BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, settingsState) {
            final t = AppStrings.of(context);
            final now = DateTime.now();
            final logs = state.logs;

            return CustomScrollView(
              slivers: [
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
                      goals: settingsState.settings,
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
                              builder: (_) => AddFoodPage(initialLog: log),
                            ),
                          );
                        },
                        onDelete: () {
                          context.read<TodayBloc>().add(DeleteTodayLog(log.id));
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
