import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/food_bloc.dart';
import 'bloc/food_event.dart';
import 'repositories/food_repository.dart';
import 'services/objectbox_service.dart';
import 'views/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化 ObjectBox 数据库
  final objectBoxService = await ObjectBoxService.create();
  final foodRepository = FoodRepository(objectBoxService);

  runApp(MyApp(foodRepository: foodRepository));
}

class MyApp extends StatelessWidget {
  final FoodRepository foodRepository;

  const MyApp({super.key, required this.foodRepository});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: foodRepository,
      child: BlocProvider(
        create: (context) =>
            FoodBloc(repository: foodRepository)..add(const LoadFoodEntries()),
        child: MaterialApp(
          title: 'Foood - 饮食与热量记录',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.teal,
              brightness: Brightness.light,
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.teal,
              brightness: Brightness.dark,
            ),
          ),
          themeMode: ThemeMode.system,
          home: const HomeScreen(),
        ),
      ),
    );
  }
}
