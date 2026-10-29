import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foody/models/custom_food.dart';
import 'package:foody/models/packaged_food.dart';
import 'package:foody/pages/add_food/add_food_page.dart';
import 'package:foody/pages/add_food/widgets/custom_meal_form.dart';
import 'package:foody/pages/add_food/widgets/packaged_meal_form.dart';
import 'package:foody/repositories/food_repository.dart';
import 'package:foody/repositories/meal_repository.dart';
import 'package:foody/services/app_database.dart';

void main() {
  testWidgets('quick add switches to the tab that owns the food type', (
    tester,
  ) async {
    final database = AppDatabase(NativeDatabase.memory());
    final foodRepository = FoodRepository(database);
    final mealRepository = MealRepository(database);

    addTearDown(() async {
      await mealRepository.dispose();
      await foodRepository.dispose();
      await database.close();
    });

    await foodRepository.saveFood(
      CustomFood(
        name: '鸡蛋',
        kj: 300,
        carbs: 1,
        protein: 6,
        fat: 5,
        lastUsedTime: DateTime(2026, 10, 19, 9),
      ),
    );
    await foodRepository.saveFood(
      PackagedFood(
        name: '牛奶',
        kj: 251,
        carbs: 10,
        protein: 6,
        fat: 8,
        netContent: 200,
        basisAmount: 100,
        unitName: 'ml',
        lastUsedTime: DateTime(2026, 10, 19, 8),
      ),
    );

    await tester.pumpWidget(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(value: foodRepository),
          RepositoryProvider.value(value: mealRepository),
        ],
        child: const MaterialApp(home: AddFoodPage()),
      ),
    );
    await tester.pumpAndSettle();

    // The packaged tab is shown first.
    expect(find.byType(PackagedMealForm), findsOneWidget);

    // Selecting a custom food jumps to the custom tab and fills that form.
    await tester.tap(find.byTooltip('Select 鸡蛋'));
    await tester.pumpAndSettle();

    expect(find.byType(CustomMealForm), findsOneWidget);
    expect(find.byType(PackagedMealForm), findsNothing);
    expect(
      find.descendant(
        of: find.byType(CustomMealForm),
        matching: find.text('鸡蛋'),
      ),
      findsOneWidget,
    );

    // Selecting a packaged food jumps back to the packaged tab.
    await tester.tap(find.byTooltip('Select 牛奶'));
    await tester.pumpAndSettle();

    expect(find.byType(PackagedMealForm), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(PackagedMealForm),
        matching: find.text('牛奶'),
      ),
      findsOneWidget,
    );
  });
}
