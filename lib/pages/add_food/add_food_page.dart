import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../l10n/app_strings.dart';
import '../../models/custom_food.dart';
import '../../models/food.dart';
import '../../models/meal.dart';
import '../../models/packaged_food.dart';
import '../../repositories/food_repository.dart';
import '../../repositories/meal_repository.dart';
import 'widgets/custom_meal_form.dart';
import 'widgets/packaged_meal_form.dart';

class AddFoodPage extends StatefulWidget {
  /// Edits an existing meal record.
  final Meal? initialMeal;

  /// Edits a saved catalogue food. When [catalogueMode] is true, no meal is
  /// written; only the food catalogue entry is created or updated.
  final Food? initialFood;
  final bool catalogueMode;

  /// Default date/time for a new meal, e.g. when adding from a history day.
  final DateTime? initialDate;

  const AddFoodPage({
    super.key,
    this.initialMeal,
    this.initialFood,
    this.catalogueMode = false,
    this.initialDate,
  });

  @override
  State<AddFoodPage> createState() => _AddFoodPageState();
}

class _AddFoodPageState extends State<AddFoodPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<PackagedMealFormState> _packagedFormKey = GlobalKey();
  final GlobalKey<CustomMealFormState> _customFormKey = GlobalKey();

  /// Food picked in a form's quick-add selector. It is applied by the form
  /// that owns its type once that form is the visible tab.
  Food? _pendingQuickFood;

  bool _packagedDirty = false;
  bool _customDirty = false;
  bool _isConfirmingPop = false;

  /// Editing a saved food keeps its type, so only one form is shown.
  bool get _isEditingCatalogueFood =>
      widget.catalogueMode && widget.initialFood != null;

  /// Only edits are guarded; new entries are discarded like before.
  bool get _isEditing =>
      widget.initialMeal != null ||
      (widget.catalogueMode && widget.initialFood != null);

  bool get _isDirty => _packagedDirty || _customDirty;

  int get _initialTabIndex {
    if (widget.catalogueMode && widget.initialFood is CustomFood) return 1;
    if (widget.initialMeal is CustomMeal) return 1;
    return 0;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: _initialTabIndex,
    )..addListener(_handleTabChanged);
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

  /// A package selection goes to the packaged tab, a custom selection to the
  /// custom tab, so the two food kinds never cross-fill.
  void _handleQuickFoodSelected(Food food) {
    final targetIndex = food is CustomFood ? 1 : 0;
    setState(() => _pendingQuickFood = food);
    if (!_isEditingCatalogueFood && _tabController.index != targetIndex) {
      _tabController.animateTo(targetIndex);
    }
  }

  void _clearPendingQuickFood() {
    if (_pendingQuickFood == null) return;
    setState(() => _pendingQuickFood = null);
  }

  /// Asks the user what to do when leaving an edited form with unsaved input.
  Future<void> _handlePopInvoked(bool didPop, Object? result) async {
    if (didPop || _isConfirmingPop) return;
    _isConfirmingPop = true;

    final t = AppStrings.of(context);
    final action = await showDialog<_LeaveAction>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(t.unsavedChangesTitle),
        content: Text(t.unsavedChangesMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(t.cancel),
          ),
          TextButton(
            onPressed: () =>
                Navigator.of(dialogContext).pop(_LeaveAction.discard),
            child: Text(t.discardChanges),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(_LeaveAction.save),
            child: Text(t.saveChanges),
          ),
        ],
      ),
    );
    _isConfirmingPop = false;

    if (!mounted || action == null) return;
    switch (action) {
      case _LeaveAction.discard:
        Navigator.of(context).pop();
      case _LeaveAction.save:
        _saveDirtyForm();
    }
  }

  /// Submits the form that holds the edits. When those edits live on the
  /// hidden tab, switch to it first so the form is built before submitting.
  void _saveDirtyForm() {
    final activeIndex = _isEditingCatalogueFood
        ? _initialTabIndex
        : _tabController.index;
    final targetIndex = _packagedDirty == _customDirty
        ? activeIndex
        : (_packagedDirty ? 0 : 1);

    if (!_isEditingCatalogueFood && _tabController.index != targetIndex) {
      _tabController.animateTo(targetIndex);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _submitFormAt(targetIndex);
      });
      return;
    }

    _submitFormAt(targetIndex);
  }

  void _submitFormAt(int index) {
    if (index == 0) {
      _packagedFormKey.currentState?.submitForm();
    } else {
      _customFormKey.currentState?.submitForm();
    }
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
        messenger.showSnackBar(
          SnackBar(
            content: Text(t.foodSaved),
            duration: const Duration(seconds: 2),
          ),
        );
        navigator.pop();
        return;
      }

      final mealRepository = context.read<MealRepository>();

      final originalMeal = widget.initialMeal;
      final originalFood = originalMeal?.food;
      final sameFoodType =
          originalFood != null &&
          ((originalFood is PackagedFood && food is PackagedFood) ||
              (originalFood is CustomFood && food is CustomFood));
      final sameMealType =
          originalMeal != null &&
          ((originalMeal is PackagedMeal && meal is PackagedMeal) ||
              (originalMeal is CustomMeal && meal is CustomMeal));

      if (sameFoodType && food.id == 0) {
        food.id = originalFood.id;
      }
      if (originalMeal != null && !sameMealType) {
        // The two meal kinds use separate tables and id sequences.
        meal.id = 0;
      }

      food.lastUsedTime = DateTime.now();
      await foodRepository.saveFood(food);
      await mealRepository.saveMeal(meal);
      if (originalMeal != null && !sameMealType) {
        await mealRepository.deleteMeal(originalMeal);
      }
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            widget.initialMeal == null ? t.addedSuccess : t.updatedSuccess,
          ),
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
        ? (widget.initialFood == null
              ? t.addCatalogueFoodTitle
              : t.editCatalogueFoodTitle)
        : (isEditing ? t.editFoodTitle : t.addFoodTitle);

    final forms = <Widget>[
      PackagedMealForm(
        key: _packagedFormKey,
        initialMeal: widget.initialMeal,
        initialFood: widget.initialFood,
        catalogueMode: widget.catalogueMode,
        initialDate: widget.initialDate,
        onSubmit: _handleSubmitted,
        onQuickFoodSelected: _handleQuickFoodSelected,
        pendingQuickFood: _pendingQuickFood,
        onQuickFoodConsumed: _clearPendingQuickFood,
        onDirtyChanged: (dirty) {
          if (_packagedDirty == dirty) return;
          setState(() => _packagedDirty = dirty);
        },
      ),
      CustomMealForm(
        key: _customFormKey,
        initialMeal: widget.initialMeal,
        initialFood: widget.initialFood,
        catalogueMode: widget.catalogueMode,
        initialDate: widget.initialDate,
        onSubmit: _handleSubmitted,
        onQuickFoodSelected: _handleQuickFoodSelected,
        pendingQuickFood: _pendingQuickFood,
        onQuickFoodConsumed: _clearPendingQuickFood,
        onDirtyChanged: (dirty) {
          if (_customDirty == dirty) return;
          setState(() => _customDirty = dirty);
        },
      ),
    ];

    return PopScope<Object?>(
      canPop: !_isEditing || !_isDirty,
      onPopInvokedWithResult: _handlePopInvoked,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          bottom: _isEditingCatalogueFood
              ? null
              : TabBar(
                  controller: _tabController,
                  tabs: [
                    Tab(
                      icon: const Icon(Icons.receipt_long),
                      text: t.tabPackaged,
                    ),
                    Tab(icon: const Icon(Icons.edit_note), text: t.tabCustom),
                  ],
                ),
        ),
        body: _isEditingCatalogueFood
            ? forms[_initialTabIndex]
            : TabBarView(controller: _tabController, children: forms),
      ),
    );
  }
}

enum _LeaveAction { save, discard }
