import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'l10n/app_strings.dart';
import 'models/app_settings.dart';
import 'pages/home/home_page.dart';
import 'pages/settings/settings_bloc.dart';
import 'pages/settings/settings_state.dart';
import 'repositories/food_repository.dart';
import 'repositories/meal_repository.dart';
import 'services/app_database.dart';
import 'services/backup_service.dart';
import 'services/settings_service.dart';
import 'widgets/auto_backup_listener.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化 Drift/SQLite 数据库
  final database = AppDatabase.defaults();
  final foodRepository = FoodRepository(database);
  final mealRepository = MealRepository(database);
  final backupService = BackupService(
    database: database,
    foodRepository: foodRepository,
    mealRepository: mealRepository,
  );

  // 读取本地设置
  final settingsService = await SettingsService.create();
  final initialSettings = await settingsService.load();

  runApp(
    MyApp(
      foodRepository: foodRepository,
      mealRepository: mealRepository,
      backupService: backupService,
      settingsService: settingsService,
      initialSettings: initialSettings,
    ),
  );
}

class MyApp extends StatelessWidget {
  final FoodRepository foodRepository;
  final MealRepository mealRepository;
  final BackupService backupService;
  final SettingsService settingsService;
  final AppSettings initialSettings;

  const MyApp({
    super.key,
    required this.foodRepository,
    required this.mealRepository,
    required this.backupService,
    required this.settingsService,
    required this.initialSettings,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: foodRepository),
        RepositoryProvider.value(value: mealRepository),
        RepositoryProvider.value(value: backupService),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => SettingsBloc(
              service: settingsService,
              initial: initialSettings,
            ),
          ),
        ],
        child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            final settings = state.settings;
            return AutoBackupListener(
              foodRepository: foodRepository,
              mealRepository: mealRepository,
              backupService: backupService,
              child: MaterialApp(
                onGenerateTitle: (context) => AppStrings.of(context).appTitle,
                debugShowCheckedModeBanner: false,
                locale: Locale(settings.languageCode),
                supportedLocales: const [Locale('zh'), Locale('en')],
                localizationsDelegates: const [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                theme: ThemeData(
                  useMaterial3: true,
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: settings.themeColor,
                    brightness: Brightness.light,
                  ),
                ),
                darkTheme: ThemeData(
                  useMaterial3: true,
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: settings.themeColor,
                    brightness: Brightness.dark,
                  ),
                ),
                themeMode: ThemeMode.system,
                home: const HomePage(),
              ),
            );
          },
        ),
      ),
    );
  }
}
