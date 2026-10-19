import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../pages/settings/settings_bloc.dart';
import '../repositories/food_repository.dart';
import '../repositories/meal_repository.dart';
import '../services/backup_service.dart';

/// Writes an automatic backup whenever the food catalogue or meals change.
class AutoBackupListener extends StatefulWidget {
  final FoodRepository foodRepository;
  final MealRepository mealRepository;
  final BackupService backupService;
  final Widget child;

  const AutoBackupListener({
    super.key,
    required this.foodRepository,
    required this.mealRepository,
    required this.backupService,
    required this.child,
  });

  @override
  State<AutoBackupListener> createState() => _AutoBackupListenerState();
}

class _AutoBackupListenerState extends State<AutoBackupListener> {
  StreamSubscription<void>? _foodSubscription;
  StreamSubscription<void>? _mealSubscription;

  @override
  void initState() {
    super.initState();
    _foodSubscription = widget.foodRepository.changes.listen((_) => _backup());
    _mealSubscription = widget.mealRepository.changes.listen((_) => _backup());
  }

  @override
  void dispose() {
    _foodSubscription?.cancel();
    _mealSubscription?.cancel();
    super.dispose();
  }

  void _backup() {
    final settings = context.read<SettingsBloc>().state.settings;
    final folder = settings.backupFolder;
    if (folder == null || folder.isEmpty) return;

    unawaited(
      widget.backupService.createAutomaticBackup(
        folderPath: folder,
        settings: settings,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
