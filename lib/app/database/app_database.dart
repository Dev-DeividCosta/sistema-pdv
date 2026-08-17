import 'package:drift/drift.dart';
import 'package:drift_sqlite_async/drift_sqlite_async.dart';
import 'package:powersync/powersync.dart' hide Table, Column;
import 'tables/customer_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [
  Customers,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 2;
}

AppDatabase createDatabase(PowerSyncDatabase powerSyncDb) {
  final executor = SqliteAsyncDriftConnection(powerSyncDb.database);
  return AppDatabase(executor);
}