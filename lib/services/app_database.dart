import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

@DataClassName('PackagedFoodRow')
@TableIndex(name: 'idx_packaged_foods_last_used', columns: {#lastUsedTime})
class PackagedFoods extends Table {
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

/// Custom foods store nutrition per 100 ml/g ([basisAmount]).
@DataClassName('CustomFoodRow')
@TableIndex(name: 'idx_custom_foods_last_used', columns: {#lastUsedTime})
class CustomFoods extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  RealColumn get kj => real()();

  RealColumn get carbs => real()();

  RealColumn get protein => real()();

  RealColumn get fat => real()();

  RealColumn get basisAmount => real()();

  TextColumn get unitName => text()();

  DateTimeColumn get lastUsedTime => dateTime()();
}

@DataClassName('PackagedMealRow')
@TableIndex(name: 'idx_packaged_meals_create_time', columns: {#createTime})
class PackagedMeals extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get packagedFoodId =>
      integer().references(PackagedFoods, #id, onDelete: KeyAction.restrict)();

  RealColumn get quantity => real()();

  DateTimeColumn get createTime => dateTime()();

  TextColumn get note => text().nullable()();
}

@DataClassName('CustomMealRow')
@TableIndex(name: 'idx_custom_meals_create_time', columns: {#createTime})
class CustomMeals extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get customFoodId =>
      integer().references(CustomFoods, #id, onDelete: KeyAction.restrict)();

  RealColumn get netContent => real()();

  DateTimeColumn get createTime => dateTime()();

  TextColumn get note => text().nullable()();
}

@DataClassName('DailySummaryRow')
class DailySummaries extends Table {
  /// Local calendar day in `yyyy-MM-dd` form.
  TextColumn get day => text()();

  RealColumn get totalKj => real()();

  RealColumn get totalCarbs => real()();

  RealColumn get totalProtein => real()();

  RealColumn get totalFat => real()();

  IntColumn get mealCount => integer()();

  @override
  Set<Column> get primaryKey => {day};
}

@DriftDatabase(
  tables: [
    PackagedFoods,
    CustomFoods,
    PackagedMeals,
    CustomMeals,
    DailySummaries,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  AppDatabase.defaults() : super(_openConnection());

  /// Fresh schema. This version intentionally has no upgrade path.
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
