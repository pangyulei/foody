import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foody/models/custom_food.dart';
import 'package:foody/models/meal.dart';
import 'package:foody/models/packaged_food.dart';
import 'package:foody/repositories/food_repository.dart';
import 'package:foody/repositories/meal_repository.dart';
import 'package:foody/services/app_database.dart';
import 'package:foody/widgets/quick_add_sheet.dart';

void main() {
  late AppDatabase database;
  late FoodRepository foodRepository;
  late MealRepository mealRepository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    foodRepository = FoodRepository(database);
    mealRepository = MealRepository(database);
  });

  tearDown(() async {
    await mealRepository.dispose();
    await foodRepository.dispose();
    await database.close();
  });

  Future<void> openSheet(WidgetTester tester, DateTime day) async {
    await tester.pumpWidget(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(value: foodRepository),
          RepositoryProvider.value(value: mealRepository),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () => showQuickAddSheet(context, day),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  testWidgets('custom food asks for a net content instead of a quantity', (
    tester,
  ) async {
    final food = CustomFood(
      name: '鸡蛋',
      kj: 300,
      carbs: 1,
      protein: 6,
      fat: 5,
      basisAmount: 100,
      unitName: 'g',
    );
    await foodRepository.saveFood(food);

    await openSheet(tester, DateTime(2026, 10, 19));

    // No [-]/[+] stepper for custom foods.
    expect(find.byIcon(Icons.add_circle_outline), findsNothing);
    expect(find.byType(TextField), findsOneWidget);

    await tester.enterText(find.byType(TextField), '250');
    await tester.pump();

    // 300 kJ per 100 g at 250 g = 750 kJ ≈ 179.3 kcal
    expect(find.text('179.3 kcal'), findsOneWidget);

    await tester.tap(find.text('Log'));
    await tester.pumpAndSettle();

    final meal = (await mealRepository.getAllMeals()).single as CustomMeal;
    expect(meal.netContent, 250);
    expect(meal.totalKj, closeTo(750, 0.001));
  });

  testWidgets('custom food cannot be logged without a valid net content', (
    tester,
  ) async {
    final food = CustomFood(name: '鸡蛋', kj: 300, carbs: 1, protein: 6, fat: 5);
    await foodRepository.saveFood(food);

    await openSheet(tester, DateTime(2026, 10, 19));

    await tester.enterText(find.byType(TextField), '0');
    await tester.pump();

    final logButton = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Log'),
    );
    expect(logButton.onPressed, isNull);
    expect(find.text('Please enter a valid number'), findsOneWidget);
  });

  testWidgets('packaged food keeps the quantity stepper', (tester) async {
    final food = PackagedFood(
      name: '牛奶',
      kj: 251,
      carbs: 10,
      protein: 6,
      fat: 8,
      netContent: 200,
      basisAmount: 100,
      unitName: 'ml',
    );
    await foodRepository.saveFood(food);

    await openSheet(tester, DateTime(2026, 10, 19));

    expect(find.byType(TextField), findsNothing);
    expect(find.byIcon(Icons.add_circle_outline), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add_circle_outline));
    await tester.pump();
    await tester.tap(find.byIcon(Icons.add_circle_outline));
    await tester.pump();
    expect(find.text('3'), findsOneWidget);

    await tester.tap(find.text('Log'));
    await tester.pumpAndSettle();

    final meal = (await mealRepository.getAllMeals()).single as PackagedMeal;
    expect(meal.quantity, 3);
  });
}
