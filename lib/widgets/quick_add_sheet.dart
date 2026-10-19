import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../l10n/app_strings.dart';
import '../models/diet_log.dart';
import '../models/food.dart';
import '../repositories/diet_log_repository.dart';
import '../repositories/food_repository.dart';
import '../utils/energy_converter.dart';

/// 弹出历史食物快速记录面板。
void showQuickAddSheet(BuildContext context, DateTime targetDate) {
  final foodRepository = context.read<FoodRepository>();
  final foodsFuture = foodRepository.getRecentFoods(limit: 20);
  final t = AppStrings.of(context);
  final messenger = ScaffoldMessenger.of(context);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (bottomSheetContext) {
      return DraggableScrollableSheet(
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
                      Icons.history,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      t.quickAddTitle,
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
                        return const Center(child: CircularProgressIndicator());
                      }

                      final recentFoods = snapshot.data ?? const <Food>[];
                      if (recentFoods.isEmpty) {
                        return Center(
                          child: Text(
                            t.noRecentFoods,
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
                        itemCount: recentFoods.length,
                        itemBuilder: (ctx, index) {
                          final food = recentFoods[index];
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
  double _quantity = 1.0;

  @override
  Widget build(BuildContext context) {
    final food = widget.food;
    final totalKj = food.kj * _quantity;
    final totalKcal = EnergyConverter.kjToKcal(totalKj);

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
            // 数量微调 [-] 1 [+]
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline, size: 20),
                  onPressed: () {
                    if (_quantity > 0.5) {
                      setState(() => _quantity -= 0.5);
                    }
                  },
                ),
                Text(
                  _quantity % 1 == 0
                      ? _quantity.toInt().toString()
                      : _quantity.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline, size: 20),
                  onPressed: () {
                    setState(() => _quantity += 0.5);
                  },
                ),
              ],
            ),
            const SizedBox(width: 4),
            FilledButton.tonal(
              onPressed: () async {
                final now = DateTime.now();
                final recordTime = DateTime(
                  widget.targetDate.year,
                  widget.targetDate.month,
                  widget.targetDate.day,
                  now.hour,
                  now.minute,
                );

                final log = DietLog.fromFood(
                  food: food,
                  quantity: _quantity,
                  createTime: recordTime,
                );

                final foodRepository = context.read<FoodRepository>();
                final dietLogRepository = context.read<DietLogRepository>();
                final messenger = ScaffoldMessenger.of(context);
                try {
                  food.lastUsedTime = now;
                  await foodRepository.saveFood(food);
                  await dietLogRepository.saveDietLog(log);
                  widget.onAdded();
                } catch (e) {
                  messenger.showSnackBar(SnackBar(content: Text(e.toString())));
                }
              },
              child: Text(widget.strings.logButton),
            ),
          ],
        ),
      ),
    );
  }
}
