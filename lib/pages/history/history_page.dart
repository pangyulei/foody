import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../extensions/meal_extensions.dart';
import '../../l10n/app_strings.dart';
import '../../repositories/meal_repository.dart';
import '../../widgets/error_view.dart';
import '../history_detail/history_detail_page.dart';
import 'history_bloc.dart';
import 'history_event.dart';
import 'history_state.dart';
import 'widgets/daily_meal_summary_tile.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          HistoryBloc(repository: context.read<MealRepository>())
            ..add(const LoadHistoryMeals()),
      child: const _HistoryView(),
    );
  }
}

class _HistoryView extends StatelessWidget {
  const _HistoryView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryBloc, HistoryState>(
      builder: (context, state) {
        if (state is HistoryLoading || state is HistoryInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is HistoryError) {
          return LoadErrorView(
            detail: state.message,
            onRetry: () {
              context.read<HistoryBloc>().add(const LoadHistoryMeals());
            },
          );
        }

        if (state is! HistoryLoaded) {
          return const SizedBox.shrink();
        }

        final t = AppStrings.of(context);

        if (state.days.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.calendar_month_outlined,
                  size: 64,
                  color: Theme.of(context).colorScheme.outline,
                ),
                const SizedBox(height: 16),
                Text(
                  t.emptyHistoryList,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.outline,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: state.days.length,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final meals = state.days[index];
            return DailyMealSummaryTile(
              meals: meals,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => HistoryDetailPage(date: meals.date),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
