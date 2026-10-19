import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/settings_cubit.dart';
import '../l10n/app_strings.dart';
import '../models/app_settings.dart';

const _themeColors = <int>[
  0xFF009688, // teal
  0xFF2196F3, // blue
  0xFF4CAF50, // green
  0xFFFF9800, // orange
  0xFF9C27B0, // purple
  0xFFE91E63, // pink
  0xFFF44336, // red
  0xFF3F51B5, // indigo
];

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final TextEditingController _weightController;
  late final TextEditingController _carbsController;
  late final TextEditingController _proteinController;
  late final TextEditingController _fatController;

  @override
  void initState() {
    super.initState();
    final settings = context.read<SettingsCubit>().state;
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
    return BlocBuilder<SettingsCubit, AppSettings>(
      builder: (context, settings) {
        final t = AppStrings.of(context);
        final cubit = context.read<SettingsCubit>();
        final hasWeight = settings.weightKg > 0;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 语言
            _SectionTitle(title: t.language, icon: Icons.translate),
            Card(
              elevation: 0,
              color: Theme.of(context).colorScheme.surfaceContainerLow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: SegmentedButton<String>(
                  segments: [
                    ButtonSegment(value: 'zh', label: Text(t.languageChinese)),
                    ButtonSegment(value: 'en', label: Text(t.languageEnglish)),
                  ],
                  selected: {settings.languageCode},
                  onSelectionChanged: (selection) {
                    cubit.setLanguage(selection.first);
                  },
                  showSelectedIcon: false,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 主题颜色
            _SectionTitle(title: t.themeColor, icon: Icons.palette_outlined),
            Card(
              elevation: 0,
              color: Theme.of(context).colorScheme.surfaceContainerLow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Wrap(
                  spacing: 14,
                  runSpacing: 14,
                  children: _themeColors.map((value) {
                    final selected = settings.themeColorValue == value;
                    return InkWell(
                      onTap: () => cubit.setThemeColor(value),
                      borderRadius: BorderRadius.circular(24),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Color(value),
                          shape: BoxShape.circle,
                          border: selected
                              ? Border.all(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface,
                                  width: 3,
                                )
                              : null,
                        ),
                        child: selected
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 22,
                              )
                            : null,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 每日目标
            _SectionTitle(title: t.dailyGoals, icon: Icons.flag_outlined),
            Card(
              elevation: 0,
              color: Theme.of(context).colorScheme.surfaceContainerLow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    value: settings.goalsEnabled,
                    onChanged: cubit.setGoalsEnabled,
                    title: Text(
                      t.enableGoals,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    secondary: const Icon(Icons.speed),
                  ),
                  const Divider(height: 1),
                  Padding(
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
                            prefixIcon: const Icon(
                              Icons.monitor_weight_outlined,
                            ),
                            border: const OutlineInputBorder(),
                          ),
                          onChanged: (_) {
                            cubit.setWeight(_parse(_weightController));
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
                            cubit.setCarbsFactor(_parse(_carbsController));
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
                            cubit.setProteinFactor(_parse(_proteinController));
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
                            cubit.setFatFactor(_parse(_fatController));
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
                            color: Theme.of(context)
                                .colorScheme
                                .primaryContainer
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
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary,
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
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        );
      },
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionTitle({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
