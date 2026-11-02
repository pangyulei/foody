import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foody/models/custom_food.dart';
import 'package:foody/models/meal.dart';
import 'package:foody/pages/add_food/add_food_page.dart';
import 'package:foody/pages/add_food/widgets/custom_meal_form.dart';
import 'package:foody/repositories/food_repository.dart';
import 'package:foody/repositories/meal_repository.dart';
import 'package:foody/services/app_database.dart';

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

  Future<Meal> seedMeal() async {
    final food = CustomFood(name: '鸡蛋', kj: 300, carbs: 1, protein: 6, fat: 5);
    await foodRepository.saveFood(food);
    final meal = Meal.fromFood(
      food: food,
      netContent: 100,
      createTime: DateTime(2026, 10, 19, 8),
    );
    await mealRepository.saveMeal(meal);
    return meal;
  }

  Future<void> openEditPage(WidgetTester tester, Meal meal) async {
    await tester.pumpWidget(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(value: foodRepository),
          RepositoryProvider.value(value: mealRepository),
        ],
        child: MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => AddFoodPage(initialMeal: meal),
                  ),
                ),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.byType(AddFoodPage), findsOneWidget);
  }

  Future<void> editName(WidgetTester tester, String name) async {
    final nameField = find
        .descendant(
          of: find.byType(CustomMealForm),
          matching: find.byType(TextFormField),
        )
        .first;
    await tester.enterText(nameField, name);
    await tester.pumpAndSettle();
  }

  testWidgets('prompts before discarding unsaved edits', (tester) async {
    final meal = await seedMeal();
    await openEditPage(tester, meal);

    await editName(tester, '鸡蛋2');

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    expect(find.text('Unsaved changes'), findsOneWidget);

    // Cancelling keeps the user on the page with the edits intact.
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.byType(AddFoodPage), findsOneWidget);

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Discard'));
    await tester.pumpAndSettle();

    expect(find.byType(AddFoodPage), findsNothing);
    expect((await mealRepository.getAllMeals()).single.foodName, '鸡蛋');
  });

  testWidgets('saves the edits when choosing save in the prompt', (
    tester,
  ) async {
    final meal = await seedMeal();
    await openEditPage(tester, meal);

    await editName(tester, '鸡蛋2');

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save & leave'));
    await tester.pumpAndSettle();

    expect(find.byType(AddFoodPage), findsNothing);
    expect((await mealRepository.getAllMeals()).single.foodName, '鸡蛋2');
  });

  testWidgets('leaves without prompting when nothing changed', (tester) async {
    final meal = await seedMeal();
    await openEditPage(tester, meal);

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    expect(find.text('Unsaved changes'), findsNothing);
    expect(find.byType(AddFoodPage), findsNothing);
  });

  testWidgets('keeps edits across tab switches and still warns on back', (
    tester,
  ) async {
    final meal = await seedMeal();
    await openEditPage(tester, meal);

    await editName(tester, '鸡蛋2');

    // Leave and return to the custom tab; the input must survive.
    await tester.tap(find.byIcon(Icons.receipt_long));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.edit_note));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(TextFormField, '鸡蛋2'), findsOneWidget);

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.text('Unsaved changes'), findsOneWidget);
  });
}
