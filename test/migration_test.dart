import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foody/models/food_source.dart';
import 'package:foody/models/premade_food.dart';
import 'package:foody/repositories/food_repository.dart';
import 'package:foody/repositories/meal_repository.dart';
import 'package:foody/services/app_database.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

void main() {
  test('v1 meal data survives migrating to v5', () async {
    final tempDir = await Directory.systemTemp.createTemp('foody_migration');
    final file = File(p.join(tempDir.path, 'foody.sqlite'));
    final raw = sqlite3.open(file.path);

    raw.execute('''
      CREATE TABLE premade_foods (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        kj REAL NOT NULL,
        carbs REAL NOT NULL,
        protein REAL NOT NULL,
        fat REAL NOT NULL,
        serving_amount REAL NOT NULL,
        basis_amount REAL NOT NULL,
        unit_name TEXT NOT NULL,
        last_used_time INTEGER NOT NULL
      )
    ''');
    raw.execute('''
      CREATE TABLE custom_foods (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        kj REAL NOT NULL,
        carbs REAL NOT NULL,
        protein REAL NOT NULL,
        fat REAL NOT NULL,
        last_used_time INTEGER NOT NULL
      )
    ''');
    raw.execute('''
      CREATE TABLE diet_logs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        premade_food_id INTEGER,
        custom_food_id INTEGER,
        quantity REAL NOT NULL,
        create_time INTEGER NOT NULL,
        note TEXT,
        FOREIGN KEY (premade_food_id) REFERENCES premade_foods(id)
          ON DELETE SET NULL,
        FOREIGN KEY (custom_food_id) REFERENCES custom_foods(id)
          ON DELETE SET NULL
      )
    ''');
    raw.execute(
      'CREATE INDEX idx_diet_logs_create_time ON diet_logs(create_time)',
    );

    raw.execute('''
      INSERT INTO premade_foods (
        id, name, kj, carbs, protein, fat,
        serving_amount, basis_amount, unit_name, last_used_time
      ) VALUES (1, '牛奶', 251, 10, 6, 8, 200, 100, 'ml', 0)
    ''');
    raw.execute('''
      INSERT INTO custom_foods (
        id, name, kj, carbs, protein, fat, last_used_time
      ) VALUES (1, '鸡蛋', 300, 1, 6, 5, 0)
    ''');

    final createTime =
        DateTime(2026, 10, 19, 8, 30).millisecondsSinceEpoch ~/ 1000;
    raw.execute(
      '''
      INSERT INTO diet_logs (
        id, premade_food_id, custom_food_id, quantity, create_time, note
      ) VALUES (1, 1, NULL, 2, ?, 'Breakfast')
      ''',
      [createTime],
    );
    raw.execute(
      '''
      INSERT INTO diet_logs (
        id, premade_food_id, custom_food_id, quantity, create_time, note
      ) VALUES (2, NULL, 1, 1, ?, 'Lunch')
      ''',
      [createTime],
    );
    raw.execute('PRAGMA user_version = 1');
    raw.close();

    final database = AppDatabase(NativeDatabase(file));
    final repository = MealRepository(database);

    final meals = await repository.getMealsForDate(DateTime(2026, 10, 19));
    expect(meals, hasLength(2));

    final milk = meals.firstWhere((meal) => meal.foodName == '牛奶');
    expect(milk.foodSource, FoodSource.premade);
    expect(milk.kj, 251);
    expect(milk.totalKj, 502);
    expect(milk.quantity, 2);
    expect(milk.netContent, 200);
    expect(milk.basisAmount, 100);
    expect(milk.unitName, 'ml');
    expect(milk.note, 'Breakfast');
    expect(milk.createTime, DateTime(2026, 10, 19, 8, 30));

    final egg = meals.firstWhere((meal) => meal.foodName == '鸡蛋');
    expect(egg.foodSource, FoodSource.custom);
    expect(egg.kj, 300);
    expect(egg.totalKj, 300);
    expect(egg.netContent, 1);
    expect(egg.basisAmount, 1);
    expect(egg.unitName, '份');
    expect(egg.note, 'Lunch');

    await repository.dispose();
    await database.close();
    await tempDir.delete(recursive: true);
  });

  test('v3 data migrates to the meals table with net_content', () async {
    final tempDir = await Directory.systemTemp.createTemp('foody_migration_v3');
    final file = File(p.join(tempDir.path, 'foody.sqlite'));
    final raw = sqlite3.open(file.path);

    raw.execute('''
      CREATE TABLE premade_foods (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        kj REAL NOT NULL,
        carbs REAL NOT NULL,
        protein REAL NOT NULL,
        fat REAL NOT NULL,
        serving_amount REAL NOT NULL,
        basis_amount REAL NOT NULL,
        unit_name TEXT NOT NULL,
        last_used_time INTEGER NOT NULL
      )
    ''');
    raw.execute(
      'CREATE INDEX idx_premade_foods_last_used '
      'ON premade_foods(last_used_time)',
    );
    raw.execute('''
      CREATE TABLE custom_foods (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        kj REAL NOT NULL,
        carbs REAL NOT NULL,
        protein REAL NOT NULL,
        fat REAL NOT NULL,
        last_used_time INTEGER NOT NULL
      )
    ''');
    raw.execute(
      'CREATE INDEX idx_custom_foods_last_used '
      'ON custom_foods(last_used_time)',
    );
    raw.execute('''
      CREATE TABLE diet_logs (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        food_name TEXT NOT NULL,
        kj REAL NOT NULL,
        carbs REAL NOT NULL,
        protein REAL NOT NULL,
        fat REAL NOT NULL,
        raw_food_source INTEGER NOT NULL,
        serving_amount REAL NOT NULL,
        basis_amount REAL NOT NULL,
        unit_name TEXT NOT NULL,
        quantity REAL NOT NULL,
        create_time INTEGER NOT NULL,
        note TEXT
      )
    ''');
    raw.execute(
      'CREATE INDEX idx_diet_logs_create_time ON diet_logs(create_time)',
    );

    raw.execute('''
      INSERT INTO premade_foods (
        id, name, kj, carbs, protein, fat,
        serving_amount, basis_amount, unit_name, last_used_time
      ) VALUES (7, '牛奶', 251, 10, 6, 8, 250, 100, 'ml', 0)
    ''');
    raw.execute('''
      INSERT INTO custom_foods (
        id, name, kj, carbs, protein, fat, last_used_time
      ) VALUES (9, '鸡蛋', 300, 1, 6, 5, 0)
    ''');

    final createTime =
        DateTime(2026, 10, 19, 8, 30).millisecondsSinceEpoch ~/ 1000;
    raw.execute(
      '''
      INSERT INTO diet_logs (
        id, food_name, kj, carbs, protein, fat, raw_food_source,
        serving_amount, basis_amount, unit_name, quantity, create_time, note
      ) VALUES (
        3, '牛奶', 502, 20, 12, 16, 0,
        250, 100, 'ml', 2, ?, 'Breakfast'
      )
      ''',
      [createTime],
    );
    raw.execute(
      '''
      INSERT INTO diet_logs (
        id, food_name, kj, carbs, protein, fat, raw_food_source,
        serving_amount, basis_amount, unit_name, quantity, create_time, note
      ) VALUES (
        4, '鸡蛋', 300, 1, 6, 5, 1,
        1, 1, '份', 1, ?, 'Lunch'
      )
      ''',
      [createTime],
    );
    raw.execute('PRAGMA user_version = 3');
    raw.close();

    final database = AppDatabase(NativeDatabase(file));
    final foodRepository = FoodRepository(database);
    final mealRepository = MealRepository(database);

    final premadeColumns =
        (await database.customSelect('PRAGMA table_info(premade_foods)').get())
            .map((row) => row.read<String>('name'))
            .toList();
    expect(premadeColumns, contains('net_content'));
    expect(premadeColumns, isNot(contains('serving_amount')));

    final mealColumns =
        (await database.customSelect('PRAGMA table_info(meals)').get())
            .map((row) => row.read<String>('name'))
            .toList();
    expect(mealColumns, contains('net_content'));
    expect(mealColumns, isNot(contains('serving_amount')));

    final tables =
        (await database
                .customSelect(
                  "SELECT name FROM sqlite_master WHERE type = 'table'",
                )
                .get())
            .map((row) => row.read<String>('name'))
            .toList();
    expect(tables, contains('meals'));
    expect(tables, isNot(contains('diet_logs')));

    final foods = await foodRepository.getAllFoods();
    expect(foods, hasLength(2));
    final milk = foods.whereType<PremadeFood>().single;
    expect(milk.id, 7);
    expect(milk.name, '牛奶');
    expect(milk.netContent, 250);
    expect(milk.basisAmount, 100);

    final meals = await mealRepository.getMealsForDate(DateTime(2026, 10, 19));
    expect(meals, hasLength(2));

    final milkLog = meals.firstWhere((meal) => meal.id == 3);
    expect(milkLog.foodName, '牛奶');
    expect(milkLog.netContent, 250);
    expect(milkLog.quantity, 2);
    expect(milkLog.note, 'Breakfast');

    final eggLog = meals.firstWhere((meal) => meal.id == 4);
    expect(eggLog.foodName, '鸡蛋');
    expect(eggLog.netContent, 1);
    expect(eggLog.note, 'Lunch');

    await mealRepository.dispose();
    await database.close();
    await tempDir.delete(recursive: true);
  });
}
