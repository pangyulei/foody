import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../l10n/app_strings.dart';
import '../../../models/food.dart';
import '../../../repositories/food_repository.dart';
import '../../../utils/energy_converter.dart';

class QuickFoodSelector extends StatefulWidget {
  final Function(Food food) onFoodSelected;

  const QuickFoodSelector({super.key, required this.onFoodSelected});

  @override
  State<QuickFoodSelector> createState() => _QuickFoodSelectorState();
}

class _QuickFoodSelectorState extends State<QuickFoodSelector> {
  Future<List<Food>>? _foodsFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _foodsFuture ??= RepositoryProvider.of<FoodRepository>(context)
        .getRecentFoods(limit: 15);
  }

  @override
  Widget build(BuildContext context) {
    final foodsFuture = _foodsFuture;
    if (foodsFuture == null) return const SizedBox.shrink();

    return FutureBuilder<List<Food>>(
      future: foodsFuture,
      builder: (context, snapshot) {
        final recentFoods = snapshot.data;
        if (recentFoods == null || recentFoods.isEmpty) {
          return const SizedBox.shrink();
        }
        return _buildSelector(context, recentFoods);
      },
    );
  }

  Widget _buildSelector(BuildContext context, List<Food> recentFoods) {
    final t = AppStrings.of(context);
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.history,
                  size: 18,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 6),
                Text(
                  t.quickAddTitle,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const Spacer(),
                Text(
                  t.tapToFill,
                  style: TextStyle(
                    fontSize: 11,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: recentFoods.map((food) {
                  final kcalText = EnergyConverter.formatKcal(
                    food.kj,
                    fractionDigits: 0,
                  );
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ActionChip(
                      avatar: CircleAvatar(
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .primaryContainer,
                        child: Text(
                          food.name.isNotEmpty ? food.name[0] : 'F',
                          style: TextStyle(
                            fontSize: 11,
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                          ),
                        ),
                      ),
                      label: Text('${food.name} ($kcalText)'),
                      tooltip: t.selectTooltip(food.name),
                      onPressed: () => widget.onFoodSelected(food),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
