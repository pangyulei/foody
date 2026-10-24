import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../l10n/app_strings.dart';
import '../../models/food.dart';
import '../../repositories/food_repository.dart';
import '../../widgets/error_view.dart';
import '../add_food/add_food_page.dart';
import 'food_catalogue_bloc.dart';
import 'food_catalogue_event.dart';
import 'food_catalogue_state.dart';
import 'widgets/food_catalogue_tile.dart';

class FoodCataloguePage extends StatelessWidget {
  const FoodCataloguePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          FoodCatalogueBloc(repository: context.read<FoodRepository>())
            ..add(const LoadFoodCatalogue()),
      child: const _FoodCatalogueView(),
    );
  }
}

class _FoodCatalogueView extends StatelessWidget {
  const _FoodCatalogueView();

  Future<void> _openEditor(BuildContext context, {Food? food}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AddFoodPage(catalogueMode: true, initialFood: food),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, Food food) async {
    final t = AppStrings.of(context);
    final catalogueBloc = context.read<FoodCatalogueBloc>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.confirmDeleteFood),
        content: Text(t.deleteFoodMessage(food.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(t.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(t.delete),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      catalogueBloc.add(DeleteFoodCatalogueEntry(food));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppStrings.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(t.foodCatalogue)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openEditor(context),
        icon: const Icon(Icons.add),
        label: Text(t.addCatalogueFood),
      ),
      body: BlocListener<FoodCatalogueBloc, FoodCatalogueState>(
        listenWhen: (previous, current) =>
            current is FoodCatalogueLoaded &&
            current.blockedDelete != null &&
            (previous is! FoodCatalogueLoaded ||
                previous.blockedDelete != current.blockedDelete),
        listener: (context, state) {
          final blocked = (state as FoodCatalogueLoaded).blockedDelete!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppStrings.of(context).foodInUseError(blocked.name),
              ),
            ),
          );
          context.read<FoodCatalogueBloc>().add(const RefreshFoodCatalogue());
        },
        child: BlocBuilder<FoodCatalogueBloc, FoodCatalogueState>(
          builder: (context, state) {
            if (state is FoodCatalogueLoading ||
                state is FoodCatalogueInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is FoodCatalogueError) {
              return LoadErrorView(
                detail: state.message,
                onRetry: () {
                  context.read<FoodCatalogueBloc>().add(
                    const LoadFoodCatalogue(),
                  );
                },
              );
            }

            if (state is! FoodCatalogueLoaded) {
              return const SizedBox.shrink();
            }

            if (state.foods.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.restaurant_menu,
                        size: 48,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        t.noCatalogueFoods,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.only(bottom: 96),
              itemCount: state.foods.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final food = state.foods[index];
                return FoodCatalogueTile(
                  food: food,
                  onEdit: () => _openEditor(context, food: food),
                  onDelete: () => _confirmDelete(context, food),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
