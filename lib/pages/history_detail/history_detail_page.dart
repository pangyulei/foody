import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../l10n/app_strings.dart';
import '../../repositories/food_repository.dart';
import '../../repositories/meal_repository.dart';
import '../../widgets/day_log_content.dart';
import '../../widgets/error_view.dart';
import '../../widgets/quick_add_sheet.dart';
import '../add_food/add_food_page.dart';
import 'history_detail_bloc.dart';
import 'history_detail_event.dart';
import 'history_detail_state.dart';

class HistoryDetailPage extends StatelessWidget {
  final DateTime date;

  const HistoryDetailPage({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HistoryDetailBloc(
        repository: context.read<MealRepository>(),
        foodRepository: context.read<FoodRepository>(),
        date: date,
      )..add(const LoadHistoryDetail()),
      child: const _HistoryDetailView(),
    );
  }
}

class _HistoryDetailView extends StatelessWidget {
  const _HistoryDetailView();

  /// Selecting a day closes the picker immediately.
  Future<void> _pickDate(BuildContext context, DateTime currentDate) async {
    final picked = await showDialog<DateTime>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 24,
          ),
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: SizedBox(
            width: 340,
            height: 440,
            child: CalendarDatePicker(
              initialDate: currentDate,
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
              onDateChanged: (date) => Navigator.of(dialogContext).pop(date),
            ),
          ),
        );
      },
    );

    if (picked != null && context.mounted) {
      context.read<HistoryDetailBloc>().add(SelectHistoryDetailDate(picked));
    }
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryDetailBloc, HistoryDetailState>(
      builder: (context, state) {
        final t = AppStrings.of(context);
        final dateText = DateFormat('yyyy-MM-dd').format(state.date);

        final Widget body;
        if (state is HistoryDetailLoading || state is HistoryDetailInitial) {
          body = const Center(child: CircularProgressIndicator());
        } else if (state is HistoryDetailError) {
          body = LoadErrorView(
            detail: state.message,
            onRetry: () {
              context.read<HistoryDetailBloc>().add(const LoadHistoryDetail());
            },
          );
        } else if (state is HistoryDetailLoaded) {
          body = DayLogContentView(
            meals: state.meals,
            summaryTitle: t.intakeThatDay,
            emptyMessage: t.emptyHistory,
            onDeleteLog: (meal) {
              context.read<HistoryDetailBloc>().add(
                DeleteHistoryDetailMeal(meal),
              );
            },
          );
        } else {
          body = const SizedBox.shrink();
        }

        return Scaffold(
          appBar: AppBar(
            title: InkWell(
              onTap: () => _pickDate(context, state.date),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _isToday(state.date)
                          ? t.todayWithDate(dateText)
                          : dateText,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_drop_down, size: 22),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              FloatingActionButton(
                heroTag: 'historyDetailQuickAddFab',
                tooltip: t.quickAdd,
                onPressed: () => showQuickAddSheet(context, state.date),
                child: const Icon(Icons.bolt),
              ),
              const SizedBox(height: 12),
              FloatingActionButton.extended(
                heroTag: 'historyDetailAddMealFab',
                onPressed: () {
                  final now = DateTime.now();
                  final initialDate = DateTime(
                    state.date.year,
                    state.date.month,
                    state.date.day,
                    now.hour,
                    now.minute,
                  );
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => AddFoodPage(initialDate: initialDate),
                    ),
                  );
                },
                icon: const Icon(Icons.add),
                label: Text(t.addMeal),
              ),
            ],
          ),
          body: body,
        );
      },
    );
  }
}
