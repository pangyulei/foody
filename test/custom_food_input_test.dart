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
  testWidgets('custom food saves per-100 values with net content and unit', (
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
                onPressed: () => Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => const AddFoodPage())),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.edit_note));
    await tester.pumpAndSettle();

    final form = find.byType(CustomMealForm);
    final fields = find.descendant(
      of: form,
      matching: find.byType(TextFormField),
    );

    await tester.enterText(fields.at(0), '牛奶');
    await tester.tap(find.descendant(of: form, matching: find.text('ml')));
    await tester.pump();
    await tester.enterText(fields.at(1), '250');
    await tester.enterText(fields.at(2), '251');
    await tester.enterText(fields.at(3), '10');
    await tester.enterText(fields.at(4), '6');
    await tester.enterText(fields.at(5), '8');
    await tester.pump();

    final scrollable = find
        .descendant(of: form, matching: find.byType(Scrollable))
        .first;
    await tester.scrollUntilVisible(
      find.text('Save'),
      300,
      scrollable: scrollable,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    final food = (await foodRepository.getAllFoods())
        .whereType<CustomFood>()
        .single;
    expect(food.name, '牛奶');
    expect(food.basisAmount, 100);
    expect(food.unitName, 'ml');
    expect(food.kj, closeTo(251, 0.001));
    expect(food.carbs, closeTo(10, 0.001));
    expect(food.protein, closeTo(6, 0.001));
    expect(food.fat, closeTo(8, 0.001));

    final meal = (await mealRepository.getAllMeals()).single as CustomMeal;
    expect(meal.foodName, '牛奶');
    expect(meal.netContent, 250);
    expect(meal.food.basisAmount, 100);
    expect(meal.food.unitName, 'ml');
    expect(meal.food.kj, closeTo(251, 0.001));
    expect(meal.totalKj, closeTo(627.5, 0.001));
    expect(meal.totalCarbs, closeTo(25, 0.001));
    expect(meal.totalProtein, closeTo(15, 0.001));
    expect(meal.totalFat, closeTo(20, 0.001));
  });
}
