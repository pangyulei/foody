import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foody/models/custom_food.dart';
import 'package:foody/models/diet_log.dart';
import 'package:foody/pages/history_detail/history_detail_bloc.dart';
import 'package:foody/pages/history_detail/history_detail_event.dart';
import 'package:foody/pages/history_detail/history_detail_state.dart';
import 'package:foody/repositories/diet_log_repository.dart';
import 'package:foody/services/app_database.dart';

void main() {
  test('history detail switches days and refreshes on delete', () async {
    final database = AppDatabase(NativeDatabase.memory());
    final repository = DietLogRepository(database);
    final bloc = HistoryDetailBloc(
      repository: repository,
      date: DateTime(2026, 10, 18),
    );

    addTearDown(() async {
      await bloc.close();
      await repository.dispose();
      await database.close();
    });

    final food = CustomFood(name: '鸡蛋', kj: 300, carbs: 1, protein: 6, fat: 5);
    final selectedLog = DietLog.fromFood(
      food: food,
      createTime: DateTime(2026, 10, 18, 8),
    );
    final otherLog = DietLog.fromFood(
      food: food,
      createTime: DateTime(2026, 10, 19, 8),
    );
    await repository.saveDietLog(selectedLog);
    await repository.saveDietLog(otherLog);

    final loaded = bloc.stream.firstWhere(
      (state) => state is HistoryDetailLoaded && state.logs.length == 1,
    );
    bloc.add(const LoadHistoryDetail());
    final loadedState = await loaded as HistoryDetailLoaded;
    expect(loadedState.date, DateTime(2026, 10, 18));
    expect(loadedState.logs.single.id, selectedLog.id);

    final switchedToNextDay = bloc.stream.firstWhere(
      (state) =>
          state is HistoryDetailLoaded && state.date == DateTime(2026, 10, 19),
    );
    bloc.add(SelectHistoryDetailDate(DateTime(2026, 10, 19)));
    final nextDayState = await switchedToNextDay as HistoryDetailLoaded;
    expect(nextDayState.logs.single.id, otherLog.id);

    final switchedBack = bloc.stream.firstWhere(
      (state) =>
          state is HistoryDetailLoaded && state.date == DateTime(2026, 10, 18),
    );
    bloc.add(SelectHistoryDetailDate(DateTime(2026, 10, 18)));
    await switchedBack;

    final empty = bloc.stream.firstWhere(
      (state) => state is HistoryDetailLoaded && state.logs.isEmpty,
    );
    bloc.add(DeleteHistoryDetailLog(selectedLog.id));
    await empty;

    final remaining = await repository.getDietLogsForDate(
      DateTime(2026, 10, 19),
    );
    expect(remaining, hasLength(1));
    expect(remaining.single.id, otherLog.id);
  });
}
