import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foody/pages/add_food/add_food_page.dart';
import 'package:foody/repositories/diet_log_repository.dart';
import 'package:foody/repositories/food_repository.dart';
import 'package:foody/services/app_database.dart';

void main() {
  testWidgets('switching input mode releases the previous field focus', (
    tester,
  ) async {
    final database = AppDatabase(NativeDatabase.memory());
    final foodRepository = FoodRepository(database);
    final dietLogRepository = DietLogRepository(database);

    addTearDown(() async {
      await dietLogRepository.dispose();
      await foodRepository.dispose();
      await database.close();
    });

    await tester.pumpWidget(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(value: foodRepository),
          RepositoryProvider.value(value: dietLogRepository),
        ],
        child: const MaterialApp(home: AddFoodPage()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(TextFormField).first);
    await tester.pump();
    expect(tester.testTextInput.isVisible, isTrue);

    await tester.tap(find.byIcon(Icons.edit_note));
    await tester.pumpAndSettle();

    expect(tester.testTextInput.isVisible, isFalse);
  });
}
