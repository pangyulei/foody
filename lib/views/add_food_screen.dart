import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/food_bloc.dart';
import '../bloc/food_event.dart';
import '../models/food_entry.dart';
import 'widgets/direct_input_form.dart';
import 'widgets/nutrition_table_form.dart';

class AddFoodScreen extends StatefulWidget {
  final FoodEntry? initialEntry;

  const AddFoodScreen({super.key, this.initialEntry});

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    final initialIndex = widget.initialEntry?.inputMode == 'direct' ? 1 : 0;
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

  void _handleSubmitted(FoodEntry entry) {
    final foodBloc = BlocProvider.of<FoodBloc>(context);
    if (widget.initialEntry != null && widget.initialEntry!.id > 0) {
      foodBloc.add(UpdateFoodEntry(entry));
    } else {
      foodBloc.add(AddFoodEntry(entry));
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(widget.initialEntry == null ? '添加成功！' : '更新成功！'),
        duration: const Duration(seconds: 2),
      ),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialEntry != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? '编辑食物记录' : '添加食物记录'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.receipt_long), text: '按成分表记录'),
            Tab(icon: Icon(Icons.edit_note), text: '直接输入'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          NutritionTableForm(
            initialEntry: widget.initialEntry,
            onSubmit: _handleSubmitted,
          ),
          DirectInputForm(
            initialEntry: widget.initialEntry,
            onSubmit: _handleSubmitted,
          ),
        ],
      ),
    );
  }
}
