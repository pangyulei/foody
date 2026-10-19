import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../l10n/app_strings.dart';
import '../food_catalogue/food_catalogue_page.dart';
import '../goals/goals_page.dart';
import 'settings_bloc.dart';
import 'settings_event.dart';
import 'settings_state.dart';

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

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        final t = AppStrings.of(context);
        final bloc = context.read<SettingsBloc>();
        final settings = state.settings;

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
                    bloc.add(SettingsLanguageChanged(selection.first));
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
                      onTap: () => bloc.add(SettingsThemeColorChanged(value)),
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

            // 每日目标：开关在外，具体数值在新页面编辑
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
                    onChanged: (enabled) =>
                        bloc.add(SettingsGoalsEnabledChanged(enabled)),
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
                  ListTile(
                    leading: const Icon(Icons.tune),
                    title: Text(t.editDailyGoals),
                    subtitle: Text(
                      settings.hasGoals
                          ? '${t.targetsLine(settings.targetCarbs, settings.targetProtein, settings.targetFat)}\n${t.approxKcal(settings.targetKcal)}'
                          : t.goalsNotSet,
                      style: const TextStyle(fontSize: 12),
                    ),
                    isThreeLine: settings.hasGoals,
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const GoalsPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 食物管理
            _SectionTitle(title: t.foodCatalogue, icon: Icons.restaurant_menu),
            Card(
              elevation: 0,
              color: Theme.of(context).colorScheme.surfaceContainerLow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.restaurant_menu),
                title: Text(
                  t.foodCatalogue,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                subtitle: Text(t.foodCatalogueSubtitle),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const FoodCataloguePage(),
                    ),
                  );
                },
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
