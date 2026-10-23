import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foody/services/app_database.dart';

import 'generated_migrations/schema.dart';

void main() {
  late SchemaVerifier verifier;

  setUpAll(() {
    verifier = SchemaVerifier(GeneratedHelper());
  });

  test('v5 schema upgrades to the v6 packaged_foods schema', () async {
    final connection = await verifier.startAt(5);
    final database = AppDatabase(connection);

    await verifier.migrateAndValidate(database, 6);

    await database.close();
  });
}
