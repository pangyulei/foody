import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../l10n/app_strings.dart';
import '../../models/custom_food.dart';
import '../../models/food.dart';
import '../../models/food_source.dart';
import '../../models/meal.dart';
import '../../repositories/food_repository.dart';
import '../../repositories/meal_repository.dart';
import 'widgets/direct_input_form.dart';
import 'widgets/nutrition_table_form.dart';

class AddFoodPage extends StatefulWidget {
  /// Edits an existing meal record.
  final Meal? initialMeal;

  /// Edits a saved catalogue food. When [catalogueMode] is true, no meal is
  /// written; only the food catalogue entry is created or updated.
  final Food? initialFood;
  final bool catalogueMode;

  /// Default date/time for a new meal, e.g. when adding from a history day.
  final DateTime? initialDate;

  const AddFoodPage({super.key, this.initialMeal, this.initialFood, this.catalogueMode = false, this.initialDate});

  @override
  State<AddFoodPage> createState() => _AddFoodPageState();
}

class _AddFoodPageState extends State<AddFoodPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  /// Editing a saved food keeps its type, so only one form is shown.
  bool get _isEditingCatalogueFood => widget.catalogueMode && widget.initialFood != null;

  int get _initialTabIndex {
    if (widget.catalogueMode && widget.initialFood is CustomFood) return 1;
    if (widget.initialMeal?.foodSource == FoodSource.custom) return 1;
    return 0;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: _initialTabIndex)
      ..addListener(_handleTabChanged);
  }

  /// The hidden form would otherwise keep the keyboard and cursor attached to
  /// an input the user can no longer see.
  void _handleTabChanged() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmitted(Food food, Meal meal) async {
    final t = AppStrings.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final foodRepository = context.read<FoodRepository>();

    try {
      if (widget.catalogueMode) {
        if (widget.initialFood == null) {
          food.lastUsedTime = DateTime.now();
        }
        await foodRepository.saveFood(food);
        if (!mounted) return;
        messenger.showSnackBar(SnackBar(content: Text(t.foodSaved), duration: const Duration(seconds: 2)));
        navigator.pop();
        return;
      }

      final mealRepository = context.read<MealRepository>();

      // A new meal always adds/updates its food in the quick-input catalogue.
      // Editing an old meal must not create a catalogue entry unless the user
      // explicitly selected an existing food.
      if (widget.initialMeal == null || food.id > 0) {
        food.lastUsedTime = DateTime.now();
        await foodRepository.saveFood(food);
      }
      await mealRepository.saveMeal(meal);
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text(widget.initialMeal == null ? t.addedSuccess : t.updatedSuccess),
          duration: const Duration(seconds: 2),
        ),
      );
      navigator.pop();
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppStrings.of(context);
    final isEditing = widget.initialMeal != null;

    final title = widget.catalogueMode
        ? (widget.initialFood == null ? t.addCatalogueFoodTitle : t.editCatalogueFoodTitle)
        : (isEditing ? t.editFoodTitle : t.addFoodTitle);

    final forms = <Widget>[
      NutritionTableForm(
        initialMeal: widget.initialMeal,
        initialFood: widget.initialFood,
        catalogueMode: widget.catalogueMode,
        initialDate: widget.initialDate,
        onSubmit: _handleSubmitted,
      ),
      DirectInputForm(
        initialMeal: widget.initialMeal,
        initialFood: widget.initialFood,
        catalogueMode: widget.catalogueMode,
        initialDate: widget.initialDate,
        onSubmit: _handleSubmitted,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        bottom: _isEditingCatalogueFood
            ? null
            : TabBar(
                controller: _tabController,
                tabs: [
                  Tab(icon: const Icon(Icons.receipt_long), text: t.tabPackaged),
                  Tab(icon: const Icon(Icons.edit_note), text: t.tabCustom),
                ],
              ),
      ),
      body: _isEditingCatalogueFood ? forms[_initialTabIndex] : TabBarView(controller: _tabController, children: forms),
    );
  }
}
