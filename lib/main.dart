import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'l10n/app_strings.dart';
import 'models/app_settings.dart';
import 'pages/home/home_page.dart';
import 'pages/settings/settings_bloc.dart';
import 'pages/settings/settings_state.dart';
import 'repositories/diet_log_repository.dart';
import 'repositories/food_repository.dart';
import 'services/app_database.dart';
import 'services/settings_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化 Drift/SQLite 数据库
  final database = AppDatabase.defaults();
  final foodRepository = FoodRepository(database);
  final dietLogRepository = DietLogRepository(database);

  // 读取本地设置
  final settingsService = await SettingsService.create();
  final initialSettings = await settingsService.load();

  runApp(
    MyApp(
      foodRepository: foodRepository,
      dietLogRepository: dietLogRepository,
      settingsService: settingsService,
      initialSettings: initialSettings,
    ),
  );
}

class MyApp extends StatelessWidget {
  final FoodRepository foodRepository;
  final DietLogRepository dietLogRepository;
  final SettingsService settingsService;
  final AppSettings initialSettings;

  const MyApp({
    super.key,
    required this.foodRepository,
    required this.dietLogRepository,
    required this.settingsService,
    required this.initialSettings,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: foodRepository),
        RepositoryProvider.value(value: dietLogRepository),
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
            return MaterialApp(
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
            );
          },
        ),
      ),
    );
  }
}
