import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foody/pages/history_detail/history_detail_page.dart';
import 'package:foody/repositories/food_repository.dart';
import 'package:foody/repositories/meal_repository.dart';
import 'package:foody/services/app_database.dart';

void main() {
  testWidgets('picking a day in the title closes the picker and switches day', (
    tester,
  ) async {
    final database = AppDatabase(NativeDatabase.memory());
    final foodRepository = FoodRepository(database);
    final repository = MealRepository(database);

    addTearDown(() async {
      await foodRepository.dispose();
      await repository.dispose();
      await database.close();
    });

    await tester.pumpWidget(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(value: foodRepository),
          RepositoryProvider.value(value: repository),
        ],
        child: MaterialApp(
          home: HistoryDetailPage(date: DateTime(2023, 5, 10)),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('2023-05-10'), findsOneWidget);

    await tester.tap(find.text('2023-05-10'));
    await tester.pumpAndSettle();
    expect(find.byType(CalendarDatePicker), findsOneWidget);

    await tester.tap(find.text('11'));
    await tester.pumpAndSettle();

    expect(find.byType(CalendarDatePicker), findsNothing);
    expect(find.text('2023-05-11'), findsOneWidget);
  });
}
