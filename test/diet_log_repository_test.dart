import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foody/models/custom_food.dart';
import 'package:foody/models/diet_log.dart';
import 'package:foody/models/premade_food.dart';
import 'package:foody/repositories/diet_log_repository.dart';
import 'package:foody/repositories/food_repository.dart';
import 'package:foody/services/app_database.dart';

void main() {
  group('DietLogRepository', () {
    late AppDatabase database;
    late FoodRepository foodRepository;
    late DietLogRepository repository;

    setUp(() {
      database = AppDatabase(NativeDatabase.memory());
      foodRepository = FoodRepository(database);
      repository = DietLogRepository(database, foodRepository);
    });

    tearDown(() async {
      await database.close();
    });

    test('saves and loads a PremadeFood log', () async {
      final food = PremadeFood(
        name: '牛奶',
        kj: 251,
        carbs: 10,
        protein: 6,
        fat: 8,
        servingAmount: 200,
        basisAmount: 100,
        unitName: 'ml',
      );
      final log = DietLog.withFood(
        food: food,
        quantity: 2,
        createTime: DateTime(2026, 10, 19, 8, 30),
        note: 'Breakfast',
      );

      await repository.saveDietLog(log);
      expect(log.id, greaterThan(0));
      expect(food.id, greaterThan(0));

      final loaded = await repository.getDietLogsForDate(
        DateTime(2026, 10, 19),
      );
      expect(loaded, hasLength(1));

      final loadedLog = loaded.first;
      expect(loadedLog.id, log.id);
      expect(loadedLog.quantity, 2);
      expect(loadedLog.createTime, DateTime(2026, 10, 19, 8, 30));
      expect(loadedLog.note, 'Breakfast');
      expect(loadedLog.kj, 502);
      expect(loadedLog.carbs, 20);
      expect(loadedLog.protein, 12);
      expect(loadedLog.fat, 16);

      final loadedFood = loadedLog.food;
      expect(loadedFood, isA<PremadeFood>());
      loadedFood as PremadeFood;
      expect(loadedFood.name, '牛奶');
      expect(loadedFood.servingAmount, 200);
      expect(loadedFood.basisAmount, 100);
      expect(loadedFood.unitName, 'ml');
    });

    test('saves and loads a CustomFood log', () async {
      final food = CustomFood(
        name: '鸡蛋',
        kj: 300,
        carbs: 1,
        protein: 6,
        fat: 5,
      );
      final log = DietLog.withFood(
        food: food,
        createTime: DateTime(2026, 10, 19, 12),
      );

      await repository.saveDietLog(log);

      final loaded = await repository.getDietLogsForDate(
        DateTime(2026, 10, 19),
      );
      expect(loaded, hasLength(1));
      expect(loaded.first.food, isA<CustomFood>());
      expect(loaded.first.kj, 300);
    });

    test('updates a log and can switch from premade to custom food', () async {
      final premade = PremadeFood(
        name: '牛奶',
        kj: 251,
        carbs: 10,
        protein: 6,
        fat: 8,
      );
      final log = DietLog.withFood(
        food: premade,
        createTime: DateTime(2026, 10, 19, 8),
      );
      await repository.saveDietLog(log);

      final custom = CustomFood(
        name: '鸡蛋',
        kj: 300,
        carbs: 1,
        protein: 6,
        fat: 5,
      );
      log
        ..setFood(custom)
        ..quantity = 2
        ..note = 'Updated';
      await repository.saveDietLog(log);

      final loaded = await repository.getDietLogsForDate(
        DateTime(2026, 10, 19),
      );
      expect(loaded, hasLength(1));
      expect(loaded.first.id, log.id);
      expect(loaded.first.food, isA<CustomFood>());
      expect(loaded.first.quantity, 2);
      expect(loaded.first.note, 'Updated');
      expect(loaded.first.kj, 600);
    });

    test('deleting a log keeps the pure food', () async {
      final food = CustomFood(
        name: '鸡蛋',
        kj: 300,
        carbs: 1,
        protein: 6,
        fat: 5,
      );
      final log = DietLog.withFood(
        food: food,
        createTime: DateTime(2026, 10, 19, 8),
      );
      await repository.saveDietLog(log);

      final deleted = await repository.deleteDietLog(log.id);
      expect(deleted, isTrue);

      final loaded = await repository.getDietLogsForDate(
        DateTime(2026, 10, 19),
      );
      expect(loaded, isEmpty);

      final recent = await foodRepository.getRecentFoods();
      expect(recent, hasLength(1));
      expect(recent.first.name, '鸡蛋');
    });
  });
}
