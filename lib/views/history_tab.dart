import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../bloc/food_bloc.dart';
import '../bloc/food_event.dart';
import '../bloc/food_state.dart';
import '../extensions/diet_log_extensions.dart';
import '../l10n/app_strings.dart';
import 'add_food_screen.dart';
import 'widgets/daily_summary_card.dart';
import 'widgets/error_view.dart';
import 'widgets/food_item_tile.dart';
import 'widgets/quick_add_sheet.dart';

class HistoryTab extends StatelessWidget {
  const HistoryTab({super.key});

  Future<void> _selectDate(BuildContext context, DateTime currentDate) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (pickedDate != null && context.mounted) {
      context.read<FoodBloc>().add(SelectDate(pickedDate));
    }
  }

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

        final t = AppStrings.of(context);
        final selectedDate = state.selectedDate;
        final logs = state.selectedLogs;
        final isToday = _isToday(selectedDate);

        return CustomScrollView(
          slivers: [
            // 日期选择条
            SliverToBoxAdapter(
              child: Container(
                color: Theme.of(context).colorScheme.surfaceContainerHighest
                    .withAlpha(128),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: () {
                        context.read<FoodBloc>().add(
                          SelectDate(
                            selectedDate.subtract(const Duration(days: 1)),
                          ),
                        );
                      },
                    ),
                    InkWell(
                      onTap: () => _selectDate(context, selectedDate),
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 16),
                            const SizedBox(width: 8),
                            Text(
                              isToday
                                  ? t.todayWithDate(
                                      DateFormat('yyyy-MM-dd')
                                          .format(selectedDate),
                                    )
                                  : DateFormat('yyyy-MM-dd')
                                        .format(selectedDate),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: () {
                        context.read<FoodBloc>().add(
                          SelectDate(selectedDate.add(const Duration(days: 1))),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // 当日统计（历史页不显示目标圆环，因为目标会变）
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: DailySummaryCard(
                  totalKj: logs.totalKj,
                  totalCarbs: logs.totalCarbs,
                  totalProtein: logs.totalProtein,
                  totalFat: logs.totalFat,
                  title: t.intakeThatDay,
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
                      onPressed: () => showQuickAddSheet(context, selectedDate),
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
                        t.emptyHistory,
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

            const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
          ],
        );
      },
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}
