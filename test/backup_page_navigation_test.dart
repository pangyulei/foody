import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foody/models/app_settings.dart';
import 'package:foody/pages/backup/backup_page.dart';
import 'package:foody/pages/settings/settings_bloc.dart';
import 'package:foody/pages/settings/settings_page.dart';
import 'package:foody/services/settings_service.dart';

class _FakeSettingsService extends SettingsService {
  _FakeSettingsService() : super(File('unused'));

  @override
  Future<void> save(AppSettings settings) async {}
}

class _FakeFilePicker extends FilePickerPlatform {
  int pickFileCalls = 0;
  PlatformFile? result;

  @override
  Future<PlatformFile?> pickFile({
    String? dialogTitle,
    String? initialDirectory,
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    Function(FilePickerStatus)? onFileLoading,
    int compressionQuality = 0,
    AndroidOptions androidOptions = const AndroidOptions(),
    DarwinOptions darwinOptions = const DarwinOptions(),
    WindowsOptions windowsOptions = const WindowsOptions(),
    LinuxOptions linuxOptions = const LinuxOptions(),
    WebOptions webOptions = const WebOptions(),
  }) async {
    pickFileCalls++;
    return result;
  }
}

void main() {
  testWidgets('settings backup entry opens the backup page', (tester) async {
    final bloc = SettingsBloc(
      service: _FakeSettingsService(),
      initial: const AppSettings(),
    );

    addTearDown(bloc.close);

    await tester.pumpWidget(
      BlocProvider.value(
        value: bloc,
        child: const MaterialApp(home: Scaffold(body: SettingsPage())),
      ),
    );
    await tester.pump();

    final entry = find.text('Backup & restore');
    await tester.ensureVisible(entry);
    await tester.pump();

    expect(find.byType(BackupPage), findsNothing);

    await tester.tap(entry);
    await tester.pumpAndSettle();

    expect(find.byType(BackupPage), findsOneWidget);
    // The three backup controls now live on the dedicated page.
    expect(find.text('Backup now'), findsOneWidget);
    expect(find.text('Restore backup'), findsOneWidget);
  });

  testWidgets('cancelling the file picker changes nothing', (tester) async {
    final originalPicker = FilePickerPlatform.instance;
    final picker = _FakeFilePicker();
    FilePickerPlatform.instance = picker;
    addTearDown(() => FilePickerPlatform.instance = originalPicker);

    final bloc = SettingsBloc(
      service: _FakeSettingsService(),
      initial: const AppSettings(),
    );

    addTearDown(bloc.close);

    await tester.pumpWidget(
      BlocProvider.value(
        value: bloc,
        child: const MaterialApp(home: BackupPage()),
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Restore backup'));
    await tester.pumpAndSettle();

    // The picker was opened directly, with no extra confirmation dialog.
    expect(picker.pickFileCalls, 1);
    expect(find.byType(AlertDialog), findsNothing);
    expect(find.byType(SnackBar), findsNothing);
    expect(find.byType(BackupPage), findsOneWidget);
  });
}
