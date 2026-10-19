import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../l10n/app_strings.dart';
import '../backup/backup_page.dart';
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
          padding: const EdgeInsets.all(12),
          children: [
            Card(
              elevation: 0,
              margin: EdgeInsets.zero,
              color: Theme.of(context).colorScheme.surfaceContainerLow,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  // 语言
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SettingLabel(icon: Icons.translate, title: t.language),
                        const SizedBox(height: 8),
                        SegmentedButton<String>(
                          segments: [
                            ButtonSegment(
                              value: 'zh',
                              label: Text(t.languageChinese),
                            ),
                            ButtonSegment(
                              value: 'en',
                              label: Text(t.languageEnglish),
                            ),
                          ],
                          selected: {settings.languageCode},
                          onSelectionChanged: (selection) {
                            bloc.add(SettingsLanguageChanged(selection.first));
                          },
                          showSelectedIcon: false,
                          style: const ButtonStyle(
                            visualDensity: VisualDensity.compact,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),

                  // 主题颜色
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SettingLabel(
                          icon: Icons.palette_outlined,
                          title: t.themeColor,
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: _themeColors.map((value) {
                            final selected = settings.themeColorValue == value;
                            return InkWell(
                              onTap: () =>
                                  bloc.add(SettingsThemeColorChanged(value)),
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                width: 36,
                                height: 36,
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
                                        size: 18,
                                      )
                                    : null,
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),

                  // 每日摄入目标
                  ListTile(
                    visualDensity: VisualDensity.compact,
                    leading: Icon(
                      Icons.flag_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(
                      t.dailyGoals,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: Text(
                      settings.hasCompleteGoalData
                          ? '${t.targetsLine(settings.targetCarbs, settings.targetProtein, settings.targetFat)}\n${t.approxKcal(settings.targetKcal)}'
                          : t.goalsNotSet,
                      style: const TextStyle(fontSize: 12),
                    ),
                    isThreeLine: settings.hasCompleteGoalData,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (settings.hasCompleteGoalData)
                          IconButton(
                            tooltip: t.clearGoals,
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () {
                              bloc.add(const SettingsGoalsCleared());
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(t.goalsCleared)),
                              );
                            },
                          ),
                        const Icon(Icons.chevron_right),
                      ],
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const GoalsPage()),
                      );
                    },
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),

                  // 食物管理
                  ListTile(
                    visualDensity: VisualDensity.compact,
                    leading: Icon(
                      Icons.restaurant_menu,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(
                      t.foodCatalogue,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: Text(
                      t.foodCatalogueSubtitle,
                      style: const TextStyle(fontSize: 12),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const FoodCataloguePage(),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),

                  // 备份与恢复
                  ListTile(
                    visualDensity: VisualDensity.compact,
                    leading: Icon(
                      Icons.settings_backup_restore,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(
                      t.backupAndRestore,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: Text(
                      t.backupAndRestoreSubtitle,
                      style: const TextStyle(fontSize: 12),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const BackupPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
        );
      },
    );
  }
}

class _SettingLabel extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SettingLabel({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
