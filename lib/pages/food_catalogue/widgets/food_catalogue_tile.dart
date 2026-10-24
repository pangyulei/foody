import 'package:flutter/material.dart';

import '../../../l10n/app_strings.dart';
import '../../../models/food.dart';
import '../../../models/packaged_food.dart';
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
    final isPackaged = food is PackagedFood;
    final typeLabel = isPackaged ? t.foodTypePackaged : t.foodTypeCustom;
    final energyLabel = isPackaged
        ? EnergyConverter.formatKcal(food.kj, fractionDigits: 0)
        : '${EnergyConverter.formatKcal(food.kj, fractionDigits: 0)} /100${food.unitName}';

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        child: Icon(
          isPackaged ? Icons.inventory_2_outlined : Icons.restaurant_outlined,
          size: 20,
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      ),
      title: Text(
        food.name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        '$energyLabel · '
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
