import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../l10n/app_strings.dart';
import '../../models/app_settings.dart';
import '../../services/backup_service.dart';
import '../settings/settings_bloc.dart';
import '../settings/settings_event.dart';
import '../settings/settings_state.dart';

class BackupPage extends StatelessWidget {
  const BackupPage({super.key});

  Future<void> _chooseBackupFolder(BuildContext context) async {
    final t = AppStrings.of(context);
    final folder = await FilePicker.getDirectoryPath(dialogTitle: t.chooseBackupFolder);
    if (folder == null || !context.mounted) return;
    context.read<SettingsBloc>().add(SettingsBackupFolderChanged(folder));
  }

  /// Applies the retention limit immediately, so lowering it cleans up old
  /// automatic backups without waiting for the next data change.
  Future<void> _changeAutoBackupLimit(BuildContext context, int limit) async {
    final folder = context.read<SettingsBloc>().state.settings.backupFolder;
    context.read<SettingsBloc>().add(SettingsAutoBackupLimitChanged(limit));
    if (folder == null || folder.isEmpty) return;

    try {
      await context.read<BackupService>().pruneAutomaticBackups(folderPath: folder, keep: limit);
    } catch (_) {
      // The setting is stored already; cleanup is best-effort.
    }
  }

  Future<void> _backupNow(BuildContext context, AppSettings settings) async {
    final t = AppStrings.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final folder = settings.backupFolder;
    if (folder == null || folder.isEmpty) {
      messenger.showSnackBar(SnackBar(content: Text(t.backupFolderRequired)));
      return;
    }

    try {
      final path = await context.read<BackupService>().createBackup(folderPath: folder, settings: settings);
      if (!context.mounted) return;
      messenger.showSnackBar(SnackBar(content: Text(t.backupSuccess(path))));
    } catch (e) {
      if (!context.mounted) return;
      messenger.showSnackBar(SnackBar(content: Text(t.backupFailed(e.toString()))));
    }
  }

  Future<void> _restoreBackup(BuildContext context) async {
    final t = AppStrings.of(context);
    final messenger = ScaffoldMessenger.of(context);

    final PlatformFile? file;
    try {
      file = await FilePicker.pickFile(
        dialogTitle: t.restoreBackup,
        type: FileType.custom,
        allowedExtensions: ['json'],
      );
    } catch (e) {
      if (!context.mounted) return;
      messenger.showSnackBar(SnackBar(content: Text(t.restoreFailed(e.toString()))));
      return;
    }

    // Cancelling the system picker returns null; leave everything untouched.
    final path = file?.path;
    if (path == null || !context.mounted) return;

    try {
      final restoredSettings = await context.read<BackupService>().restoreBackup(path);
      if (!context.mounted) return;
      final current = context.read<SettingsBloc>().state.settings;
      final restored = AppSettings(
        languageCode: restoredSettings.languageCode,
        themeColorValue: restoredSettings.themeColorValue,
        weightKg: restoredSettings.weightKg,
        carbsFactor: restoredSettings.carbsFactor,
        proteinFactor: restoredSettings.proteinFactor,
        fatFactor: restoredSettings.fatFactor,
        backupFolder: current.backupFolder,
        autoBackupLimit: current.autoBackupLimit,
      );
      context.read<SettingsBloc>().add(SettingsRestored(restored));
      messenger.showSnackBar(SnackBar(content: Text(t.restoreSuccess)));
    } catch (e) {
      if (!context.mounted) return;
      messenger.showSnackBar(SnackBar(content: Text(t.restoreFailed(e.toString()))));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        final t = AppStrings.of(context);
        final settings = state.settings;
        final folder = settings.backupFolder;
        final hasBackupFolder = folder != null && folder.isNotEmpty;
        final autoBackupLimit = AppSettings.clampAutoBackupLimit(settings.autoBackupLimit);

        return Scaffold(
          appBar: AppBar(title: Text(t.backupAndRestore)),
          body: ListView(
            padding: const EdgeInsets.all(12),
            children: [
              Card(
                elevation: 0,
                margin: EdgeInsets.zero,
                clipBehavior: Clip.antiAlias,
                color: Theme.of(context).colorScheme.surfaceContainerLow,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: [
                    ListTile(
                      visualDensity: VisualDensity.compact,
                      leading: Icon(Icons.folder_outlined, color: Theme.of(context).colorScheme.primary),
                      title: Text(t.backupFolder, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      subtitle: Text(
                        settings.backupFolder ?? t.backupFolderNotSet,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12),
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _chooseBackupFolder(context),
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    ListTile(
                      visualDensity: VisualDensity.compact,
                      enabled: hasBackupFolder,
                      leading: Icon(
                        Icons.restore_page_outlined,
                        color: hasBackupFolder
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).disabledColor,
                      ),
                      title: Text(
                        t.autoBackupRetention,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      subtitle: Text(
                        hasBackupFolder
                            ? t.autoBackupRetentionSubtitle(autoBackupLimit)
                            : t.autoBackupRetentionRequiresFolder,
                        style: const TextStyle(fontSize: 12),
                      ),
                      trailing: DropdownButton<int>(
                        value: autoBackupLimit,
                        underline: const SizedBox.shrink(),
                        onChanged: hasBackupFolder
                            ? (value) {
                                if (value == null) return;
                                unawaited(_changeAutoBackupLimit(context, value));
                              }
                            : null,
                        items: [
                          for (var i = AppSettings.minAutoBackupLimit; i <= AppSettings.maxAutoBackupLimit; i++)
                            DropdownMenuItem<int>(value: i, child: Text('$i')),
                        ],
                      ),
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    ListTile(
                      visualDensity: VisualDensity.compact,
                      leading: Icon(Icons.backup_outlined, color: Theme.of(context).colorScheme.primary),
                      title: Text(t.backupNow, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      subtitle: Text(t.backupNowSubtitle, style: const TextStyle(fontSize: 12)),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _backupNow(context, settings),
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    ListTile(
                      visualDensity: VisualDensity.compact,
                      leading: Icon(Icons.restore, color: Theme.of(context).colorScheme.primary),
                      title: Text(t.restoreBackup, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      subtitle: Text(t.restoreBackupSubtitle, style: const TextStyle(fontSize: 12)),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _restoreBackup(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
