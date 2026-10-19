import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foody/models/app_settings.dart';
import 'package:foody/pages/settings/settings_bloc.dart';
import 'package:foody/pages/settings/settings_page.dart';
import 'package:foody/services/settings_service.dart';

class _FakeSettingsService extends SettingsService {
  _FakeSettingsService() : super(File('unused'));

  @override
  Future<void> save(AppSettings settings) async {}
}

void main() {
  testWidgets('trash button clears daily goals', (tester) async {
    final bloc = SettingsBloc(
      service: _FakeSettingsService(),
      initial: const AppSettings(weightKg: 70),
    );

    addTearDown(bloc.close);

    await tester.pumpWidget(
      BlocProvider.value(
        value: bloc,
        child: const MaterialApp(home: Scaffold(body: SettingsPage())),
      ),
    );
    await tester.pump();

    final deleteFinder = find.byIcon(Icons.delete_outline);
    await tester.ensureVisible(deleteFinder);
    await tester.pump();
    expect(deleteFinder, findsOneWidget);

    await tester.tap(deleteFinder);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(bloc.state.settings.hasCompleteGoalData, isFalse);
    expect(bloc.state.settings.weightKg, 0);
    expect(bloc.state.settings.carbsFactor, 0);
    expect(bloc.state.settings.proteinFactor, 0);
    expect(bloc.state.settings.fatFactor, 0);
    expect(find.byIcon(Icons.delete_outline), findsNothing);
  });
}
