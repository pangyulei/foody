import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../bloc/food_bloc.dart';
import '../bloc/food_event.dart';
import '../bloc/food_state.dart';
import '../models/food_entry.dart';
import '../repositories/food_repository.dart';
import '../utils/energy_converter.dart';
import 'add_food_screen.dart';
import 'widgets/daily_summary_card.dart';
import 'widgets/food_item_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _selectDate(BuildContext context, DateTime currentDate) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (pickedDate != null && context.mounted) {
      BlocProvider.of<FoodBloc>(context).add(SelectDate(pickedDate));
    }
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  void _showQuickAddBottomSheet(BuildContext context, DateTime selectedDate) {
    final foodRepository = RepositoryProvider.of<FoodRepository>(context);
    final historyFoods = foodRepository.getRecentUniqueFoods(limit: 20);

    if (historyFoods.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('暂无历史食物记录，请先“记一笔”添加食物')));
      return;
    }

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
                      const Text(
                        '快速选择历史食品',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '选中后即可直接快速记录到 ${DateFormat('yyyy-MM-dd').format(selectedDate)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  const Divider(height: 20),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: historyFoods.length,
                      itemBuilder: (ctx, index) {
                        final item = historyFoods[index];
                        return _QuickAddHistoryTile(
                          historyEntry: item,
                          targetDate: selectedDate,
                          onAdded: () {
                            Navigator.of(bottomSheetContext).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('已快速记入“${item.name}”！'),
                                duration: const Duration(seconds: 2),
                              ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Foood 饮食日志',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: '历史食品',
            onPressed: () {
              final state = BlocProvider.of<FoodBloc>(context).state;
              final targetDate = state is FoodLoaded
                  ? state.selectedDate
                  : DateTime.now();
              _showQuickAddBottomSheet(context, targetDate);
            },
          ),
          IconButton(
            icon: const Icon(Icons.today),
            tooltip: '回到今天',
            onPressed: () {
              BlocProvider.of<FoodBloc>(context)
                  .add(SelectDate(DateTime.now()));
            },
          ),
        ],
      ),
      body: BlocBuilder<FoodBloc, FoodState>(
        builder: (context, state) {
          if (state is FoodLoading || state is FoodInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is FoodError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 12),
                  Text(state.message),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<FoodBloc>(context)
                          .add(const LoadFoodEntries());
                    },
                    child: const Text('重试'),
                  ),
                ],
              ),
            );
          }

          if (state is FoodLoaded) {
            final selectedDate = state.selectedDate;
            final entries = state.entries;

            return CustomScrollView(
              slivers: [
                // 日期选择条
                SliverToBoxAdapter(
                  child: Container(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest
                        .withAlpha(128),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left),
                          onPressed: () {
                            final prevDay = selectedDate.subtract(
                              const Duration(days: 1),
                            );
                            BlocProvider.of<FoodBloc>(context)
                                .add(SelectDate(prevDay));
                          },
                        ),
                        InkWell(
                          onTap: () => _selectDate(context, selectedDate),
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today, size: 16),
                                const SizedBox(width: 8),
                                Text(
                                  _isToday(selectedDate)
                                      ? '今天 (${DateFormat('yyyy-MM-dd').format(selectedDate)})'
                                      : DateFormat('yyyy-MM-dd')
                                            .format(selectedDate),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_right),
                          onPressed: () {
                            final nextDay = selectedDate.add(
                              const Duration(days: 1),
                            );
                            BlocProvider.of<FoodBloc>(context)
                                .add(SelectDate(nextDay));
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                // 今日卡路里与营养素汇总卡片
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: DailySummaryCard(
                      totalKj: state.totalKj,
                      totalCarbs: state.totalCarbs,
                      totalProtein: state.totalProtein,
                      totalFat: state.totalFat,
                    ),
                  ),
                ),

                // 标题栏
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '食物记录明细 (${entries.length}项)',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () =>
                              _showQuickAddBottomSheet(context, selectedDate),
                          icon: const Icon(Icons.history, size: 18),
                          label: const Text('历史食品'),
                        ),
                      ],
                    ),
                  ),
                ),

                // 记录列表 / 空状态
                if (entries.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.no_meals_outlined,
                            size: 64,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _isToday(selectedDate)
                                ? '今天还没有饮食记录，快点击下方按钮添加吧！'
                                : '该日期暂无记录',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.outline,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final item = entries[index];
                      return FoodItemTile(
                        entry: item,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => AddFoodScreen(initialEntry: item),
                            ),
                          );
                        },
                        onDelete: () {
                          BlocProvider.of<FoodBloc>(context)
                              .add(DeleteFoodEntry(item.id));
                        },
                      );
                    }, childCount: entries.length),
                  ),

                const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => const AddFoodScreen()));
        },
        icon: const Icon(Icons.add),
        label: const Text('记一笔'),
      ),
    );
  }
}

class _QuickAddHistoryTile extends StatefulWidget {
  final FoodEntry historyEntry;
  final DateTime targetDate;
  final VoidCallback onAdded;

  const _QuickAddHistoryTile({
    required this.historyEntry,
    required this.targetDate,
    required this.onAdded,
  });

  @override
  State<_QuickAddHistoryTile> createState() => _QuickAddHistoryTileState();
}

class _QuickAddHistoryTileState extends State<_QuickAddHistoryTile> {
  double _quantity = 1.0;

  @override
  Widget build(BuildContext context) {
    final hist = widget.historyEntry;
    final baseQty = hist.quantity > 0 ? hist.quantity : 1.0;
    final unitKj = hist.kj / baseQty;
    final totalKj = unitKj * _quantity;
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
                    hist.name,
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
            // 数量微调 [-] 1.0 [+]
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
              onPressed: () {
                final now = DateTime.now();
                final recordTime = DateTime(
                  widget.targetDate.year,
                  widget.targetDate.month,
                  widget.targetDate.day,
                  now.hour,
                  now.minute,
                );

                final newEntry = FoodEntry(
                  name: hist.name,
                  createTime: recordTime,
                  kj: totalKj,
                  carbs: (hist.carbs / baseQty) * _quantity,
                  protein: (hist.protein / baseQty) * _quantity,
                  fat: (hist.fat / baseQty) * _quantity,
                  inputMode: hist.inputMode,
                  quantity: _quantity,
                  note: hist.note,
                );

                BlocProvider.of<FoodBloc>(context).add(AddFoodEntry(newEntry));
                widget.onAdded();
              },
              child: const Text('记录'),
            ),
          ],
        ),
      ),
    );
  }
}
