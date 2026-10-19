import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../l10n/app_strings.dart';
import '../../repositories/meal_repository.dart';
import '../../widgets/day_log_content.dart';
import '../../widgets/error_view.dart';
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
          TodayBloc(repository: context.read<MealRepository>())
            ..add(const LoadTodayMeals()),
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
              context.read<TodayBloc>().add(const LoadTodayMeals());
            },
          );
        }

        if (state is! TodayLoaded) {
          return const SizedBox.shrink();
        }

        return BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, settingsState) {
            final t = AppStrings.of(context);
            return DayLogContentView(
              meals: state.meals,
              date: DateTime.now(),
              summaryTitle: t.intakeToday,
              emptyMessage: t.emptyToday,
              goals: settingsState.settings,
              onDeleteLog: (id) {
                context.read<TodayBloc>().add(DeleteTodayMeal(id));
              },
            );
          },
        );
      },
    );
  }
}
