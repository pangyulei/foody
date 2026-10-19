import 'package:flutter/material.dart';

import '../../../l10n/app_strings.dart';
import '../../../models/food.dart';
import '../../../models/premade_food.dart';
import '../../../utils/energy_converter.dart';

class FoodCatalogueTile extends StatelessWidget {
  final Food food;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const FoodCatalogueTile({
    super.key,
    required this.food,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppStrings.of(context);
    final isPremade = food is PremadeFood;
    final typeLabel = isPremade ? t.foodTypePremade : t.foodTypeCustom;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        child: Icon(
          isPremade ? Icons.inventory_2_outlined : Icons.restaurant_outlined,
          size: 20,
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      ),
      title: Text(
        food.name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        '${EnergyConverter.formatKcal(food.kj, fractionDigits: 0)} · '
        '$typeLabel\n'
        '${t.macrosLine(food.carbs, food.protein, food.fat)}',
      ),
      isThreeLine: true,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            tooltip: t.editCatalogueFoodTitle,
            icon: const Icon(Icons.edit_outlined),
            onPressed: onEdit,
          ),
          IconButton(
            tooltip: t.delete,
            icon: const Icon(Icons.delete_outline),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
