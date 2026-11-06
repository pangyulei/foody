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

import 'package:foody/models/meal.dart';

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

  Future<void> openEditPage(WidgetTester tester, Meal meal) async {
    await tester.pumpWidget(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(value: foodRepository),
          RepositoryProvider.value(value: mealRepository),
        ],
        child: MaterialApp(home: AddFoodPage(initialMeal: meal)),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
    'packaged meal edit formats float numbers like 15.000000000004 to 15',
    (tester) async {
      // 37.5g protein per 250g package -> ratio 100/250 = 0.4 -> 37.5 * 0.4 = 15.0
      final food = PackagedFood(
        name: 'Milk 1',
        kj: 600,
        carbs: 25,
        protein: 37.5, // 15.0 per 100g
        fat: 10,
        netContent: 250,
      );
      await foodRepository.saveFood(food);
      final meal = Meal.fromFood(
        food: food,
        quantity: 1,
        createTime: DateTime.now(),
      );

      await openEditPage(tester, meal);

      final form = find.byType(PackagedMealForm);
      final scrollable = find
          .descendant(of: form, matching: find.byType(Scrollable))
          .first;
      final proteinField = find.descendant(
        of: form,
        matching: find.widgetWithText(TextFormField, '15'),
      );
      await tester.scrollUntilVisible(
        proteinField,
        300,
        scrollable: scrollable,
      );
      expect(proteinField, findsOneWidget);
    },
  );

  testWidgets('packaged meal edit formats 15.10 to 15.1', (tester) async {
    // 37.75g protein per 250g package -> 37.75 * 0.4 = 15.10 per 100g
    final food = PackagedFood(
      name: 'Milk 2',
      kj: 600,
      carbs: 25,
      protein: 37.75, // 15.1 per 100g
      fat: 10,
      netContent: 250,
    );
    await foodRepository.saveFood(food);
    final meal = Meal.fromFood(
      food: food,
      quantity: 1,
      createTime: DateTime.now(),
    );

    await openEditPage(tester, meal);

    final form = find.byType(PackagedMealForm);
    final scrollable = find
        .descendant(of: form, matching: find.byType(Scrollable))
        .first;
    final proteinField = find.descendant(
      of: form,
      matching: find.widgetWithText(TextFormField, '15.1'),
    );
    await tester.scrollUntilVisible(proteinField, 300, scrollable: scrollable);
    expect(proteinField, findsOneWidget);
  });

  testWidgets('packaged meal edit formats 15.12 float to 15.12', (
    tester,
  ) async {
    // 37.8g protein per 250g package -> 37.8 * 0.4 = 15.12 per 100g
    final food = PackagedFood(
      name: 'Milk 3',
      kj: 600,
      carbs: 25,
      protein: 37.8, // 15.12 per 100g
      fat: 10,
      netContent: 250,
    );
    await foodRepository.saveFood(food);
    final meal = Meal.fromFood(
      food: food,
      quantity: 1,
      createTime: DateTime.now(),
    );

    await openEditPage(tester, meal);

    final form = find.byType(PackagedMealForm);
    final scrollable = find
        .descendant(of: form, matching: find.byType(Scrollable))
        .first;
    final proteinField = find.descendant(
      of: form,
      matching: find.widgetWithText(TextFormField, '15.12'),
    );
    await tester.scrollUntilVisible(proteinField, 300, scrollable: scrollable);
    expect(proteinField, findsOneWidget);
  });

  testWidgets(
    'custom meal edit formats float numbers like 15.000000000004 to 15',
    (tester) async {
      final food = CustomFood(
        name: 'Food 1',
        kj: 200,
        carbs: 10,
        protein: 15.000000000004,
        fat: 5,
      );
      await foodRepository.saveFood(food);
      final meal = Meal.fromFood(
        food: food,
        netContent: 100,
        createTime: DateTime.now(),
      );

      await openEditPage(tester, meal);

      final form = find.byType(CustomMealForm);
      final scrollable = find
          .descendant(of: form, matching: find.byType(Scrollable))
          .first;
      final proteinField = find.descendant(
        of: form,
        matching: find.widgetWithText(TextFormField, '15'),
      );
      await tester.scrollUntilVisible(
        proteinField,
        300,
        scrollable: scrollable,
      );
      expect(proteinField, findsOneWidget);
    },
  );

  testWidgets('custom meal edit formats 15.10 to 15.1', (tester) async {
    final food = CustomFood(
      name: 'Food 2',
      kj: 200,
      carbs: 10,
      protein: 15.10,
      fat: 5,
    );
    await foodRepository.saveFood(food);
    final meal = Meal.fromFood(
      food: food,
      netContent: 100,
      createTime: DateTime.now(),
    );

    await openEditPage(tester, meal);

    final form = find.byType(CustomMealForm);
    final scrollable = find
        .descendant(of: form, matching: find.byType(Scrollable))
        .first;
    final proteinField = find.descendant(
      of: form,
      matching: find.widgetWithText(TextFormField, '15.1'),
    );
    await tester.scrollUntilVisible(proteinField, 300, scrollable: scrollable);
    expect(proteinField, findsOneWidget);
  });

  testWidgets('custom meal edit formats 15.12 to 15.12', (tester) async {
    final food = CustomFood(
      name: 'Food 3',
      kj: 200,
      carbs: 10,
      protein: 15.12,
      fat: 5,
    );
    await foodRepository.saveFood(food);
    final meal = Meal.fromFood(
      food: food,
      netContent: 100,
      createTime: DateTime.now(),
    );

    await openEditPage(tester, meal);

    final form = find.byType(CustomMealForm);
    final scrollable = find
        .descendant(of: form, matching: find.byType(Scrollable))
        .first;
    final proteinField = find.descendant(
      of: form,
      matching: find.widgetWithText(TextFormField, '15.12'),
    );
    await tester.scrollUntilVisible(proteinField, 300, scrollable: scrollable);
    expect(proteinField, findsOneWidget);
  });
}
