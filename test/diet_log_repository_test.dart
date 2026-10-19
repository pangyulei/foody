import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foody/models/custom_food.dart';
import 'package:foody/models/diet_log.dart';
import 'package:foody/models/food_source.dart';
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
      repository = DietLogRepository(database);
    });

    tearDown(() async {
      await repository.dispose();
      await database.close();
    });

    test('saves and loads a PremadeFood log snapshot', () async {
      final food = PremadeFood(
        name: '牛奶',
        kj: 251,
        carbs: 10,
        protein: 6,
        fat: 8,
        netContent: 200,
        basisAmount: 100,
        unitName: 'ml',
      );
      final log = DietLog.fromFood(
        food: food,
        quantity: 2,
        createTime: DateTime(2026, 10, 19, 8, 30),
        note: 'Breakfast',
      );

      await repository.saveDietLog(log);
      expect(log.id, greaterThan(0));

      final loaded = await repository.getDietLogsForDate(
        DateTime(2026, 10, 19),
      );
      expect(loaded, hasLength(1));

      final loadedLog = loaded.first;
      expect(loadedLog.id, log.id);
      expect(loadedLog.foodName, '牛奶');
      expect(loadedLog.foodSource, FoodSource.premade);
      expect(loadedLog.netContent, 200);
      expect(loadedLog.basisAmount, 100);
      expect(loadedLog.unitName, 'ml');
      expect(loadedLog.quantity, 2);
      expect(loadedLog.createTime, DateTime(2026, 10, 19, 8, 30));
      expect(loadedLog.note, 'Breakfast');
      expect(loadedLog.kj, 251);
      expect(loadedLog.totalKj, 502);
      expect(loadedLog.totalCarbs, 20);
      expect(loadedLog.totalProtein, 12);
      expect(loadedLog.totalFat, 16);
    });

    test('saves and loads a CustomFood log snapshot', () async {
      final food = CustomFood(
        name: '鸡蛋',
        kj: 300,
        carbs: 1,
        protein: 6,
        fat: 5,
      );
      final log = DietLog.fromFood(
        food: food,
        createTime: DateTime(2026, 10, 19, 12),
      );

      await repository.saveDietLog(log);

      final loaded = await repository.getDietLogsForDate(
        DateTime(2026, 10, 19),
      );
      expect(loaded, hasLength(1));
      expect(loaded.first.foodName, '鸡蛋');
      expect(loaded.first.foodSource, FoodSource.custom);
      expect(loaded.first.totalKj, 300);
    });

    test('updates a log with a new food snapshot', () async {
      final premade = PremadeFood(
        name: '牛奶',
        kj: 251,
        carbs: 10,
        protein: 6,
        fat: 8,
      );
      final log = DietLog.fromFood(
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
      final updated = DietLog.fromFood(
        id: log.id,
        food: custom,
        quantity: 2,
        createTime: log.createTime,
        note: 'Updated',
      );
      await repository.saveDietLog(updated);

      final loaded = await repository.getDietLogsForDate(
        DateTime(2026, 10, 19),
      );
      expect(loaded, hasLength(1));
      expect(loaded.first.id, log.id);
      expect(loaded.first.foodName, '鸡蛋');
      expect(loaded.first.foodSource, FoodSource.custom);
      expect(loaded.first.quantity, 2);
      expect(loaded.first.note, 'Updated');
      expect(loaded.first.totalKj, 600);
    });

    test('later food changes do not alter an existing log', () async {
      final food = CustomFood(
        name: '鸡蛋',
        kj: 300,
        carbs: 1,
        protein: 6,
        fat: 5,
      );
      final log = DietLog.fromFood(
        food: food,
        createTime: DateTime(2026, 10, 19, 8),
      );

      food
        ..name = '改名后的鸡蛋'
        ..kj = 999;

      await repository.saveDietLog(log);
      final loaded = await repository.getDietLogsForDate(
        DateTime(2026, 10, 19),
      );

      expect(loaded.first.foodName, '鸡蛋');
      expect(loaded.first.kj, 300);
    });

    test('deleting a food does not change existing diet logs', () async {
      final food = CustomFood(
        name: '鸡蛋',
        kj: 300,
        carbs: 1,
        protein: 6,
        fat: 5,
      );
      await foodRepository.saveFood(food);
      final log = DietLog.fromFood(
        food: food,
        quantity: 2,
        createTime: DateTime(2026, 10, 19, 8),
      );
      await repository.saveDietLog(log);

      expect(await foodRepository.deleteFood(food), isTrue);
      expect(await foodRepository.getRecentFoods(), isEmpty);

      final loaded = await repository.getDietLogsForDate(
        DateTime(2026, 10, 19),
      );
      expect(loaded, hasLength(1));
      expect(loaded.first.foodName, '鸡蛋');
      expect(loaded.first.kj, 300);
      expect(loaded.first.totalKj, 600);
    });

    test('deleting a log does not remove food catalogue entries', () async {
      final food = CustomFood(
        name: '鸡蛋',
        kj: 300,
        carbs: 1,
        protein: 6,
        fat: 5,
      );
      await foodRepository.saveFood(food);
      final log = DietLog.fromFood(
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
