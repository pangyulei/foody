import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../l10n/app_strings.dart';
import '../models/custom_food.dart';
import '../models/food.dart';
import '../models/meal.dart';
import '../repositories/food_repository.dart';
import '../repositories/meal_repository.dart';
import '../utils/energy_converter.dart';

/// 弹出历史食物快速记录面板。
void showQuickAddSheet(BuildContext context, DateTime targetDate) {
  final foodRepository = context.read<FoodRepository>();
  final foodsFuture = foodRepository.getQuickAddFoods(limit: 20);
  final t = AppStrings.of(context);
  final messenger = ScaffoldMessenger.of(context);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (bottomSheetContext) {
      return Padding(
        // Lift the sheet above the keyboard so the net-content field stays
        // visible while typing.
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(bottomSheetContext).bottom,
        ),
        child: DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.3,
          maxChildSize: 0.85,
          expand: false,
          builder: (_, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.bolt,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        t.quickAdd,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    t.quickAddSubtitle(
                      DateFormat('yyyy-MM-dd').format(targetDate),
                    ),
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  const Divider(height: 20),
                  Expanded(
                    child: FutureBuilder<List<Food>>(
                      future: foodsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState != ConnectionState.done) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final foods = snapshot.data ?? const <Food>[];
                        if (foods.isEmpty) {
                          return Center(
                            child: Text(
                              t.noQuickAddFoods,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                            ),
                          );
                        }

                        return ListView.builder(
                          controller: scrollController,
                          itemCount: foods.length,
                          itemBuilder: (ctx, index) {
                            final food = foods[index];
                            return _QuickAddFoodTile(
                              food: food,
                              targetDate: targetDate,
                              strings: t,
                              onAdded: () {
                                Navigator.of(bottomSheetContext).pop();
                                messenger.showSnackBar(
                                  SnackBar(
                                    content: Text(t.quickAdded(food.name)),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}

class _QuickAddFoodTile extends StatefulWidget {
  final Food food;
  final DateTime targetDate;
  final AppStrings strings;
  final VoidCallback onAdded;

  const _QuickAddFoodTile({
    required this.food,
    required this.targetDate,
    required this.strings,
    required this.onAdded,
  });

  @override
  State<_QuickAddFoodTile> createState() => _QuickAddFoodTileState();
}

class _QuickAddFoodTileState extends State<_QuickAddFoodTile> {
  final TextEditingController _netContentController = TextEditingController();
  int _quantity = 1;

  /// Packaged foods are counted in packages; custom foods are measured in
  /// ml/g, so they ask for a net content instead of a quantity.
  bool get _isCustom => widget.food is CustomFood;

  @override
  void initState() {
    super.initState();
    if (_isCustom) {
      final basis = widget.food.basisAmount;
      _netContentController.text = _formatAmount(basis > 0 ? basis : 100);
    }
  }

  @override
  void dispose() {
    _netContentController.dispose();
    super.dispose();
  }

  String _formatAmount(double value) {
    if (value == value.roundToDouble()) return value.toInt().toString();
    return value.toString();
  }

  double get _netContent =>
      double.tryParse(_netContentController.text.trim()) ?? 0;

  bool get _canLog => !_isCustom || _netContent > 0;

  double get _totalKj {
    final food = widget.food;
    if (!_isCustom) return food.kj * _quantity;
    final basis = food.basisAmount > 0 ? food.basisAmount : 100.0;
    return food.kj * _netContent / basis;
  }

  Future<void> _log() async {
    final food = widget.food;
    final now = DateTime.now();
    final recordTime = DateTime(
      widget.targetDate.year,
      widget.targetDate.month,
      widget.targetDate.day,
      now.hour,
      now.minute,
      now.second,
    );

    final meal = Meal.fromFood(
      food: food,
      quantity: _quantity.toDouble(),
      netContent: _isCustom ? _netContent : null,
      createTime: recordTime,
    );

    final foodRepository = context.read<FoodRepository>();
    final mealRepository = context.read<MealRepository>();
    final messenger = ScaffoldMessenger.of(context);
    try {
      food.lastUsedTime = now;
      await foodRepository.saveFood(food);
      await mealRepository.saveMeal(meal);
      widget.onAdded();
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    final food = widget.food;
    final totalKj = _totalKj;
    final totalKcal = EnergyConverter.kjToKcal(totalKj);
    final showNetContentError =
        _isCustom && !_canLog && _netContentController.text.trim().isNotEmpty;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${totalKcal.toStringAsFixed(1)} kcal',
                    style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            if (_isCustom)
              SizedBox(
                width: 104,
                child: TextField(
                  controller: _netContentController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  textAlign: TextAlign.center,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    isDense: true,
                    labelText: widget.strings.servingSize,
                    suffixText: food.unitName,
                    errorText: showNetContentError
                        ? widget.strings.invalidNumber
                        : null,
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 10,
                    ),
                  ),
                ),
              )
            else
              // 数量微调 [-] 1 [+]
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline, size: 20),
                    onPressed: _quantity > 1
                        ? () => setState(() => _quantity -= 1)
                        : null,
                  ),
                  Text(
                    _quantity.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline, size: 20),
                    onPressed: () => setState(() => _quantity += 1),
                  ),
                ],
              ),
            const SizedBox(width: 4),
            FilledButton.tonal(
              onPressed: _canLog ? _log : null,
              child: Text(widget.strings.logButton),
            ),
          ],
        ),
      ),
    );
  }
}
