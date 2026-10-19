import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foody/models/app_settings.dart';
import 'package:foody/pages/settings/settings_bloc.dart';
import 'package:foody/repositories/food_repository.dart';
import 'package:foody/repositories/meal_repository.dart';
import 'package:foody/services/app_database.dart';
import 'package:foody/services/backup_service.dart';
import 'package:foody/services/settings_service.dart';
import 'package:foody/widgets/auto_backup_listener.dart';

class _FakeSettingsService extends SettingsService {
  _FakeSettingsService() : super(File('unused'));

  @override
  Future<void> save(AppSettings settings) async {}
}

class _RecordingBackupService extends BackupService {
  _RecordingBackupService({
    required super.database,
    required super.foodRepository,
    required super.mealRepository,
  });

  int automaticBackups = 0;

  @override
  Future<void> createAutomaticBackup({
    required String folderPath,
    required AppSettings settings,
  }) async {
    automaticBackups++;
  }
}

void main() {
  testWidgets('food and meal changes each trigger an automatic backup', (
    tester,
  ) async {
    final database = AppDatabase(NativeDatabase.memory());
    final foods = FoodRepository(database);
    final meals = MealRepository(database);
    final backupService = _RecordingBackupService(
      database: database,
      foodRepository: foods,
      mealRepository: meals,
    );
    final bloc = SettingsBloc(
      service: _FakeSettingsService(),
      initial: const AppSettings(backupFolder: 'backups'),
    );

    addTearDown(() async {
      await bloc.close();
      await meals.dispose();
      await foods.dispose();
      await database.close();
    });

    await tester.pumpWidget(
      BlocProvider.value(
        value: bloc,
        child: AutoBackupListener(
          foodRepository: foods,
          mealRepository: meals,
          backupService: backupService,
          child: const SizedBox.shrink(),
        ),
      ),
    );

    foods.notifyChanged();
    await tester.pump();
    expect(backupService.automaticBackups, 1);

    meals.notifyChanged();
    await tester.pump();
    expect(backupService.automaticBackups, 2);
  });

  testWidgets('no backup runs without a backup folder', (tester) async {
    final database = AppDatabase(NativeDatabase.memory());
    final foods = FoodRepository(database);
    final meals = MealRepository(database);
    final backupService = _RecordingBackupService(
      database: database,
      foodRepository: foods,
      mealRepository: meals,
    );
    final bloc = SettingsBloc(
      service: _FakeSettingsService(),
      initial: const AppSettings(),
    );

    addTearDown(() async {
      await bloc.close();
      await meals.dispose();
      await foods.dispose();
      await database.close();
    });

    await tester.pumpWidget(
      BlocProvider.value(
        value: bloc,
        child: AutoBackupListener(
          foodRepository: foods,
          mealRepository: meals,
          backupService: backupService,
          child: const SizedBox.shrink(),
        ),
      ),
    );

    meals.notifyChanged();
    await tester.pump();

    expect(backupService.automaticBackups, 0);
  });
}
