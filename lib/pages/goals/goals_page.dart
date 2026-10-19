import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../l10n/app_strings.dart';
import '../settings/settings_bloc.dart';
import '../settings/settings_event.dart';
import '../settings/settings_state.dart';

class GoalsPage extends StatefulWidget {
  const GoalsPage({super.key});

  @override
  State<GoalsPage> createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  late final TextEditingController _weightController;
  late final TextEditingController _carbsController;
  late final TextEditingController _proteinController;
  late final TextEditingController _fatController;

  @override
  void initState() {
    super.initState();
    final settings = context.read<SettingsBloc>().state.settings;
    _weightController = TextEditingController(
      text: _formatNumber(settings.weightKg),
    );
    _carbsController = TextEditingController(
      text: _formatNumber(settings.carbsFactor),
    );
    _proteinController = TextEditingController(
      text: _formatNumber(settings.proteinFactor),
    );
    _fatController = TextEditingController(
      text: _formatNumber(settings.fatFactor),
    );
  }

  @override
  void dispose() {
    _weightController.dispose();
    _carbsController.dispose();
    _proteinController.dispose();
    _fatController.dispose();
    super.dispose();
  }

  String _formatNumber(double value) {
    if (value == 0) return '';
    return value % 1 == 0 ? value.toInt().toString() : value.toString();
  }

  double _parse(TextEditingController controller) =>
      double.tryParse(controller.text.trim()) ?? 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        final t = AppStrings.of(context);
        final bloc = context.read<SettingsBloc>();
        final settings = state.settings;
        final hasWeight = settings.weightKg > 0;

        return Scaffold(
          appBar: AppBar(title: Text(t.dailyGoals)),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                elevation: 0,
                color: Theme.of(context).colorScheme.surfaceContainerLow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _weightController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          labelText: t.bodyWeight,
                          hintText: t.bodyWeightHint,
                          suffixText: 'kg',
                          prefixIcon: const Icon(Icons.monitor_weight_outlined),
                          border: const OutlineInputBorder(),
                        ),
                        onChanged: (_) {
                          bloc.add(
                            SettingsWeightChanged(_parse(_weightController)),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _carbsController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          labelText: t.carbsFactor,
                          suffixText: 'g/kg',
                          prefixIcon: const Icon(Icons.grain),
                          border: const OutlineInputBorder(),
                        ),
                        onChanged: (_) {
                          bloc.add(
                            SettingsCarbsFactorChanged(
                              _parse(_carbsController),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _proteinController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          labelText: t.proteinFactor,
                          suffixText: 'g/kg',
                          prefixIcon: const Icon(Icons.fitness_center),
                          border: const OutlineInputBorder(),
                        ),
                        onChanged: (_) {
                          bloc.add(
                            SettingsProteinFactorChanged(
                              _parse(_proteinController),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _fatController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          labelText: t.fatFactor,
                          suffixText: 'g/kg',
                          prefixIcon: const Icon(Icons.opacity),
                          border: const OutlineInputBorder(),
                        ),
                        onChanged: (_) {
                          bloc.add(
                            SettingsFatFactorChanged(_parse(_fatController)),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      Text(
                        t.goalsHint,
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer
                              .withAlpha(150),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.flag,
                                  size: 18,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  t.dailyTargets,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            if (hasWeight) ...[
                              Text(
                                t.targetsLine(
                                  settings.targetCarbs,
                                  settings.targetProtein,
                                  settings.targetFat,
                                ),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                t.approxKcal(settings.targetKcal),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                              ),
                            ] else
                              Text(
                                t.goalsNotSet,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
