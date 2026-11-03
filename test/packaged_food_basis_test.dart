import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foody/models/meal.dart';
import 'package:foody/models/packaged_food.dart';
import 'package:foody/pages/add_food/add_food_page.dart';
import 'package:foody/pages/add_food/widgets/packaged_meal_form.dart';
import 'package:foody/repositories/food_repository.dart';
import 'package:foody/repositories/meal_repository.dart';
import 'package:foody/services/app_database.dart';

void main() {
  testWidgets('packaged form has no label basis field', (tester) async {
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
        child: const MaterialApp(home: AddFoodPage()),
      ),
    );
    await tester.pumpAndSettle();

    // Nutrition is entered per 100 without any basis field to fill in.
    expect(find.text('Label basis'), findsNothing);
    expect(find.widgetWithText(TextFormField, '100'), findsNothing);

    Future<void> enter(String label, String text) async {
      await tester.enterText(find.widgetWithText(TextFormField, label), text);
      await tester.pump();
    }

    await enter('Food name', '牛奶');
    await enter('Net content', '200');
    await enter('Energy (kJ)', '300');
    await enter('Carbohydrates (g)', '10');
    await enter('Protein (g)', '5');
    await enter('Fat (g)', '5');

    final scrollable = find
        .descendant(
          of: find.byType(PackagedMealForm),
          matching: find.byType(Scrollable),
        )
        .first;
    await tester.scrollUntilVisible(
      find.text('Save'),
      300,
      scrollable: scrollable,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    // Nutrition entered per 100 is stored per package for a 200 ml package.
    final food = (await foodRepository.getAllFoods())
        .whereType<PackagedFood>()
        .single;
    expect(food.basisAmount, 100);
    expect(food.netContent, 200);
    expect(food.kj, closeTo(600, 0.001));
    expect(food.carbs, closeTo(20, 0.001));
    expect(food.protein, closeTo(10, 0.001));
    expect(food.fat, closeTo(10, 0.001));

    final meal = (await mealRepository.getAllMeals()).single as PackagedMeal;
    expect(meal.quantity, 1);
    expect(meal.totalKj, closeTo(600, 0.001));
  });
}
