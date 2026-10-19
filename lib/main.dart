import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'bloc/food_bloc.dart';
import 'bloc/food_event.dart';
import 'bloc/settings_cubit.dart';
import 'l10n/app_strings.dart';
import 'models/app_settings.dart';
import 'repositories/food_repository.dart';
import 'services/app_database.dart';
import 'services/settings_service.dart';
import 'views/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化 Drift/SQLite 数据库
  final database = AppDatabase.defaults();
  final foodRepository = FoodRepository(database);

  // 读取本地设置
  final settingsService = await SettingsService.create();
  final initialSettings = await settingsService.load();

  runApp(
    MyApp(
      foodRepository: foodRepository,
      settingsService: settingsService,
      initialSettings: initialSettings,
    ),
  );
}

class MyApp extends StatelessWidget {
  final FoodRepository foodRepository;
  final SettingsService settingsService;
  final AppSettings initialSettings;

  const MyApp({
    super.key,
    required this.foodRepository,
    required this.settingsService,
    required this.initialSettings,
  });

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: foodRepository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => SettingsCubit(
              service: settingsService,
              initial: initialSettings,
            ),
          ),
          BlocProvider(
            create: (_) =>
                FoodBloc(repository: foodRepository)..add(const LoadDietLogs()),
          ),
        ],
        child: BlocBuilder<SettingsCubit, AppSettings>(
          builder: (context, settings) {
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
              home: const HomeScreen(),
            );
          },
        ),
      ),
    );
  }
}
