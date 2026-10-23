import 'package:flutter/material.dart';

import '../../l10n/app_strings.dart';
import '../../widgets/quick_add_sheet.dart';
import '../add_food/add_food_page.dart';
import '../history/history_page.dart';
import '../settings/settings_page.dart';
import '../today/today_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final t = AppStrings.of(context);
    final titles = [t.appTitle, t.historyTitle, t.settingsTitle];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_index], style: const TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: IndexedStack(index: _index, children: const [TodayPage(), HistoryPage(), SettingsPage()]),
      floatingActionButton: _index == 0
          ? Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FloatingActionButton(
                  heroTag: 'todayQuickAddFab',
                  tooltip: t.quickAdd,
                  onPressed: () => showQuickAddSheet(context, DateTime.now()),
                  child: const Icon(Icons.bolt),
                ),
                const SizedBox(height: 12),
                FloatingActionButton.extended(
                  heroTag: 'todayAddMealFab',
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AddFoodPage()));
                  },
                  icon: const Icon(Icons.add),
                  label: Text(t.addMeal),
                ),
              ],
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.today_outlined),
            selectedIcon: const Icon(Icons.today),
            label: t.navToday,
          ),
          NavigationDestination(
            icon: const Icon(Icons.calendar_month_outlined),
            selectedIcon: const Icon(Icons.calendar_month),
            label: t.navHistory,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: t.navSettings,
          ),
        ],
      ),
    );
  }
}
