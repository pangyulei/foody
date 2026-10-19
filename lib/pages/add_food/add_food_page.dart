import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../l10n/app_strings.dart';
import '../../models/custom_food.dart';
import '../../models/diet_log.dart';
import '../../models/food.dart';
import '../../models/food_source.dart';
import '../../repositories/diet_log_repository.dart';
import '../../repositories/food_repository.dart';
import 'widgets/direct_input_form.dart';
import 'widgets/nutrition_table_form.dart';

class AddFoodPage extends StatefulWidget {
  /// Edits an existing meal record.
  final DietLog? initialLog;

  /// Edits a saved catalogue food. When [catalogueMode] is true, no diet log
  /// is written; only the food catalogue entry is created or updated.
  final Food? initialFood;
  final bool catalogueMode;

  const AddFoodPage({
    super.key,
    this.initialLog,
    this.initialFood,
    this.catalogueMode = false,
  });

  @override
  State<AddFoodPage> createState() => _AddFoodPageState();
}

class _AddFoodPageState extends State<AddFoodPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  /// Editing a saved food keeps its type, so only one form is shown.
  bool get _isEditingCatalogueFood =>
      widget.catalogueMode && widget.initialFood != null;

  int get _initialTabIndex {
    if (widget.catalogueMode && widget.initialFood is CustomFood) return 1;
    if (widget.initialLog?.foodSource == FoodSource.custom) return 1;
    return 0;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: _initialTabIndex,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmitted(Food food, DietLog log) async {
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

      final dietLogRepository = context.read<DietLogRepository>();

      // A new log always adds/updates its food in the quick-input catalogue.
      // Editing an old log must not create a catalogue entry unless the user
      // explicitly selected an existing food.
      if (widget.initialLog == null || food.id > 0) {
        food.lastUsedTime = DateTime.now();
        await foodRepository.saveFood(food);
      }
      await dietLogRepository.saveDietLog(log);
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            widget.initialLog == null ? t.addedSuccess : t.updatedSuccess,
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
    final isEditing = widget.initialLog != null;

    final title = widget.catalogueMode
        ? (widget.initialFood == null
              ? t.addCatalogueFoodTitle
              : t.editCatalogueFoodTitle)
        : (isEditing ? t.editFoodTitle : t.addFoodTitle);

    final forms = <Widget>[
      NutritionTableForm(
        initialLog: widget.initialLog,
        initialFood: widget.initialFood,
        catalogueMode: widget.catalogueMode,
        onSubmit: _handleSubmitted,
      ),
      DirectInputForm(
        initialLog: widget.initialLog,
        initialFood: widget.initialFood,
        catalogueMode: widget.catalogueMode,
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
                  Tab(
                    icon: const Icon(Icons.receipt_long),
                    text: t.tabLabelInput,
                  ),
                  Tab(
                    icon: const Icon(Icons.edit_note),
                    text: t.tabDirectInput,
                  ),
                ],
              ),
      ),
      body: _isEditingCatalogueFood
          ? forms[_initialTabIndex]
          : TabBarView(controller: _tabController, children: forms),
    );
  }
}
