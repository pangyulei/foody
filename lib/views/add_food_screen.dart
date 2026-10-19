import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/food_bloc.dart';
import '../bloc/food_event.dart';
import '../l10n/app_strings.dart';
import '../models/diet_log.dart';
import '../models/premade_food.dart';
import 'widgets/direct_input_form.dart';
import 'widgets/nutrition_table_form.dart';

class AddFoodScreen extends StatefulWidget {
  final DietLog? initialLog;

  const AddFoodScreen({super.key, this.initialLog});

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    final food = widget.initialLog?.food;
    final initialIndex = food is PremadeFood || food == null ? 0 : 1;
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: initialIndex,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleSubmitted(DietLog log) {
    final t = AppStrings.of(context);
    final foodBloc = context.read<FoodBloc>();
    if (widget.initialLog != null && widget.initialLog!.id > 0) {
      foodBloc.add(UpdateDietLog(log));
    } else {
      foodBloc.add(AddDietLog(log));
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.initialLog == null ? t.addedSuccess : t.updatedSuccess,
        ),
        duration: const Duration(seconds: 2),
      ),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppStrings.of(context);
    final isEditing = widget.initialLog != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? t.editFoodTitle : t.addFoodTitle),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: const Icon(Icons.receipt_long), text: t.tabLabelInput),
            Tab(icon: const Icon(Icons.edit_note), text: t.tabDirectInput),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          NutritionTableForm(
            initialLog: widget.initialLog,
            onSubmit: _handleSubmitted,
          ),
          DirectInputForm(
            initialLog: widget.initialLog,
            onSubmit: _handleSubmitted,
          ),
        ],
      ),
    );
  }
}
