import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foody/models/custom_food.dart';
import 'package:foody/models/diet_log.dart';
import 'package:foody/pages/history/history_bloc.dart';
import 'package:foody/pages/history/history_event.dart';
import 'package:foody/pages/history/history_state.dart';
import 'package:foody/pages/today/today_bloc.dart';
import 'package:foody/pages/today/today_event.dart';
import 'package:foody/pages/today/today_state.dart';
import 'package:foody/repositories/diet_log_repository.dart';
import 'package:foody/services/app_database.dart';

void main() {
  test('Today and History blocs refresh when diet logs change', () async {
    final database = AppDatabase(NativeDatabase.memory());
    final dietLogRepository = DietLogRepository(database);
    final todayBloc = TodayBloc(repository: dietLogRepository);
    final historyBloc = HistoryBloc(repository: dietLogRepository);

    addTearDown(() async {
      await todayBloc.close();
      await historyBloc.close();
      await dietLogRepository.dispose();
      await database.close();
    });

    final initialToday = todayBloc.stream.firstWhere(
      (state) => state is TodayLoaded && state.logs.isEmpty,
    );
    final initialHistory = historyBloc.stream.firstWhere(
      (state) => state is HistoryLoaded && state.summaries.isEmpty,
    );
    todayBloc.add(const LoadTodayLogs());
    historyBloc.add(const LoadHistoryLogs());
    await Future.wait([initialToday, initialHistory]);

    final todayHasLog = todayBloc.stream.firstWhere(
      (state) => state is TodayLoaded && state.logs.isNotEmpty,
    );
    final historyHasLog = historyBloc.stream.firstWhere(
      (state) => state is HistoryLoaded && state.summaries.isNotEmpty,
    );

    final log = DietLog.fromFood(
      food: CustomFood(name: '鸡蛋', kj: 300, carbs: 1, protein: 6, fat: 5),
      createTime: DateTime.now(),
    );
    await dietLogRepository.saveDietLog(log);
    await Future.wait([todayHasLog, historyHasLog]);

    final todayEmptyAgain = todayBloc.stream.firstWhere(
      (state) => state is TodayLoaded && state.logs.isEmpty,
    );
    final historyEmptyAgain = historyBloc.stream.firstWhere(
      (state) => state is HistoryLoaded && state.summaries.isEmpty,
    );
    await dietLogRepository.deleteDietLog(log.id);
    await Future.wait([todayEmptyAgain, historyEmptyAgain]);
  });
}
