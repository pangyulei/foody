import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../pages/settings/settings_bloc.dart';
import '../services/backup_service.dart';

/// Creates an automatic backup whenever the app moves to the background.
class AppLifecycleBackup extends StatefulWidget {
  final BackupService backupService;
  final Widget child;

  const AppLifecycleBackup({
    super.key,
    required this.backupService,
    required this.child,
  });

  @override
  State<AppLifecycleBackup> createState() => _AppLifecycleBackupState();
}

class _AppLifecycleBackupState extends State<AppLifecycleBackup>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.paused &&
        state != AppLifecycleState.hidden) {
      return;
    }

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
