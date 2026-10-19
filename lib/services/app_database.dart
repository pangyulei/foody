import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

@DataClassName('PremadeFoodRow')
@TableIndex(name: 'idx_premade_foods_last_used', columns: {#lastUsedTime})
class PremadeFoods extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  RealColumn get kj => real()();

  RealColumn get carbs => real()();

  RealColumn get protein => real()();

  RealColumn get fat => real()();

  RealColumn get netContent => real()();

  RealColumn get basisAmount => real()();

  TextColumn get unitName => text()();

  DateTimeColumn get lastUsedTime => dateTime()();
}

@DataClassName('CustomFoodRow')
@TableIndex(name: 'idx_custom_foods_last_used', columns: {#lastUsedTime})
class CustomFoods extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  RealColumn get kj => real()();

  RealColumn get carbs => real()();

  RealColumn get protein => real()();

  RealColumn get fat => real()();

  DateTimeColumn get lastUsedTime => dateTime()();
}

/// A one-time eating record. Food attributes are copied into the log; there is
/// intentionally no foreign key to the food catalogue.
@DataClassName('DietLogRow')
@TableIndex(name: 'idx_diet_logs_create_time', columns: {#createTime})
class DietLogs extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get foodName => text()();

  RealColumn get kj => real()();

  RealColumn get carbs => real()();

  RealColumn get protein => real()();

  RealColumn get fat => real()();

  IntColumn get rawFoodSource => integer()();

  RealColumn get netContent => real()();

  RealColumn get basisAmount => real()();

  TextColumn get unitName => text()();

  RealColumn get quantity => real()();

  DateTimeColumn get createTime => dateTime()();

  TextColumn get note => text().nullable()();
}

@DriftDatabase(tables: [PremadeFoods, CustomFoods, DietLogs])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  AppDatabase.defaults() : super(_openConnection());

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await _migrateV1ToV2();
      }
      if (from < 3) {
        await _migrateV2ToV3();
      }
      if (from < 4) {
        await _migrateV3ToV4();
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  /// v1 stored food foreign keys. v2 copies the food attributes onto each log
  /// so later food edits cannot alter history.
  Future<void> _migrateV1ToV2() async {
    await customStatement('''
      CREATE TABLE diet_logs_v2 (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        food_name TEXT NOT NULL,
        kj REAL NOT NULL,
        carbs REAL NOT NULL,
        protein REAL NOT NULL,
        fat REAL NOT NULL,
        input_mode TEXT NOT NULL,
        serving_amount REAL NOT NULL,
        basis_amount REAL NOT NULL,
        unit_name TEXT NOT NULL,
        quantity REAL NOT NULL,
        create_time INTEGER NOT NULL,
        note TEXT
      )
    ''');

    await customStatement('''
      INSERT INTO diet_logs_v2 (
        id,
        food_name,
        kj,
        carbs,
        protein,
        fat,
        input_mode,
        serving_amount,
        basis_amount,
        unit_name,
        quantity,
        create_time,
        note
      )
      SELECT
        l.id,
        COALESCE(p.name, c.name, ''),
        COALESCE(p.kj, c.kj, 0),
        COALESCE(p.carbs, c.carbs, 0),
        COALESCE(p.protein, c.protein, 0),
        COALESCE(p.fat, c.fat, 0),
        CASE
          WHEN l.premade_food_id IS NOT NULL THEN 'table'
          ELSE 'direct'
        END,
        COALESCE(p.serving_amount, 1),
        COALESCE(p.basis_amount, 1),
        COALESCE(p.unit_name, '份'),
        l.quantity,
        l.create_time,
        l.note
      FROM diet_logs l
      LEFT JOIN premade_foods p ON l.premade_food_id = p.id
      LEFT JOIN custom_foods c ON l.custom_food_id = c.id
    ''');

    await customStatement('DROP TABLE diet_logs');
    await customStatement('ALTER TABLE diet_logs_v2 RENAME TO diet_logs');
    await customStatement(
      'CREATE INDEX idx_diet_logs_create_time ON diet_logs(create_time)',
    );
  }

  /// v2 stored the source as the text 'table'/'direct'. v3 stores it as an
  /// integer matching the FoodSource enum values.
  Future<void> _migrateV2ToV3() async {
    await customStatement('''
      CREATE TABLE diet_logs_v3 (
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

    await customStatement('''
      INSERT INTO diet_logs_v3 (
        id,
        food_name,
        kj,
        carbs,
        protein,
        fat,
        raw_food_source,
        serving_amount,
        basis_amount,
        unit_name,
        quantity,
        create_time,
        note
      )
      SELECT
        id,
        food_name,
        kj,
        carbs,
        protein,
        fat,
        CASE WHEN input_mode = 'table' THEN 0 ELSE 1 END,
        serving_amount,
        basis_amount,
        unit_name,
        quantity,
        create_time,
        note
      FROM diet_logs
    ''');

    await customStatement('DROP TABLE diet_logs');
    await customStatement('ALTER TABLE diet_logs_v3 RENAME TO diet_logs');
    await customStatement(
      'CREATE INDEX idx_diet_logs_create_time ON diet_logs(create_time)',
    );
  }

  /// v3 named the net content column `serving_amount`. v4 renames it to
  /// `net_content` in both tables, copying every row so no data is lost.
  Future<void> _migrateV3ToV4() async {
    await transaction(() async {
      await customStatement('''
        CREATE TABLE premade_foods_v4 (
          id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          kj REAL NOT NULL,
          carbs REAL NOT NULL,
          protein REAL NOT NULL,
          fat REAL NOT NULL,
          net_content REAL NOT NULL,
          basis_amount REAL NOT NULL,
          unit_name TEXT NOT NULL,
          last_used_time INTEGER NOT NULL
        )
      ''');

      await customStatement('''
        INSERT INTO premade_foods_v4 (
          id,
          name,
          kj,
          carbs,
          protein,
          fat,
          net_content,
          basis_amount,
          unit_name,
          last_used_time
        )
        SELECT
          id,
          name,
          kj,
          carbs,
          protein,
          fat,
          serving_amount,
          basis_amount,
          unit_name,
          last_used_time
        FROM premade_foods
      ''');

      await customStatement('DROP TABLE premade_foods');
      await customStatement(
        'ALTER TABLE premade_foods_v4 RENAME TO premade_foods',
      );
      await customStatement(
        'CREATE INDEX idx_premade_foods_last_used '
        'ON premade_foods(last_used_time)',
      );

      await customStatement('''
        CREATE TABLE diet_logs_v4 (
          id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
          food_name TEXT NOT NULL,
          kj REAL NOT NULL,
          carbs REAL NOT NULL,
          protein REAL NOT NULL,
          fat REAL NOT NULL,
          raw_food_source INTEGER NOT NULL,
          net_content REAL NOT NULL,
          basis_amount REAL NOT NULL,
          unit_name TEXT NOT NULL,
          quantity REAL NOT NULL,
          create_time INTEGER NOT NULL,
          note TEXT
        )
      ''');

      await customStatement('''
        INSERT INTO diet_logs_v4 (
          id,
          food_name,
          kj,
          carbs,
          protein,
          fat,
          raw_food_source,
          net_content,
          basis_amount,
          unit_name,
          quantity,
          create_time,
          note
        )
        SELECT
          id,
          food_name,
          kj,
          carbs,
          protein,
          fat,
          raw_food_source,
          serving_amount,
          basis_amount,
          unit_name,
          quantity,
          create_time,
          note
        FROM diet_logs
      ''');

      await customStatement('DROP TABLE diet_logs');
      await customStatement('ALTER TABLE diet_logs_v4 RENAME TO diet_logs');
      await customStatement(
        'CREATE INDEX idx_diet_logs_create_time ON diet_logs(create_time)',
      );
    });
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final file = File(p.join(docsDir.path, 'foody.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
