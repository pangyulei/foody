import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Enforces the project's state-management conventions.
///
/// - Use Bloc, not Cubit.
/// - A page's Bloc, Event, and State classes live next to its page file
///   inside the same `lib/pages/<page>/` directory, but in separate files.
/// - Widget-local `State` classes and `BlocBuilder` usage are fine in UI files.
void main() {
  test('project uses Bloc, not Cubit', () {
    final cubitDefinition = RegExp(r'\bextends\s+Cubit\s*<');
    final offenders = _dartFiles(Directory('lib'))
        .where((file) => cubitDefinition.hasMatch(file.readAsStringSync()))
        .map((file) => file.path)
        .toList();

    expect(
      offenders,
      isEmpty,
      reason:
          'This project uses Bloc, not Cubit. Found Cubit definitions in: '
          '${offenders.join(', ')}',
    );
  });

  test('page and widget UI files do not define Bloc/Event/State classes', () {
    final forbiddenDefinition = RegExp(
      r'\bextends\s+(Bloc\s*<|Cubit\s*<|Equatable\b)',
    );

    final uiFiles = <File>[
      ..._dartFiles(Directory('lib/widgets')),
      ..._dartFiles(Directory('lib/pages')).where(_isPageUiFile),
    ];

    final offenders = <String>[];
    for (final file in uiFiles) {
      if (forbiddenDefinition.hasMatch(file.readAsStringSync())) {
        offenders.add(file.path);
      }
    }

    expect(
      offenders,
      isEmpty,
      reason:
          'Keep Bloc/Event/State definitions in their own files, '
          'not in page or widget UI files. Found state definitions in: '
          '${offenders.join(', ')}',
    );
  });
}

List<File> _dartFiles(Directory directory) {
  if (!directory.existsSync()) return const [];
  return directory
      .listSync(recursive: true)
      .whereType<File>()
      .where((file) => file.path.endsWith('.dart'))
      .toList();
}

bool _isPageUiFile(File file) {
  final path = file.path.replaceAll('\\', '/');
  final isPage = path.endsWith('_page.dart');
  final isPageWidget = path.contains('/widgets/');
  return isPage || isPageWidget;
}
