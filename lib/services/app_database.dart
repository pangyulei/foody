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

  RealColumn get servingAmount => real()();

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

@DataClassName('DietLogRow')
@TableIndex(name: 'idx_diet_logs_create_time', columns: {#createTime})
class DietLogs extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get premadeFoodId => integer().nullable().references(
    PremadeFoods,
    #id,
    onDelete: KeyAction.setNull,
  )();

  IntColumn get customFoodId => integer().nullable().references(
    CustomFoods,
    #id,
    onDelete: KeyAction.setNull,
  )();

  RealColumn get quantity => real()();

  DateTimeColumn get createTime => dateTime()();

  TextColumn get note => text().nullable()();
}

@DriftDatabase(tables: [PremadeFoods, CustomFoods, DietLogs])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  AppDatabase.defaults() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async => m.createAll(),
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final file = File(p.join(docsDir.path, 'foody.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
