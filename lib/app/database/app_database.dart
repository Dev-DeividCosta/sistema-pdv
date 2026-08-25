import 'package:drift/drift.dart';
import 'package:drift_sqlite_async/drift_sqlite_async.dart';
import 'package:powersync/powersync.dart' hide Table, Column;
import 'tables/customer_table.dart';
import 'tables/city_table.dart';
import 'tables/itinerary_items_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [
  Customers,
  Cities,
  ItineraryItems,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 5;

  // --- ADICIONADO: Estratégia de Migração ---
  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 5) {
          // Quando atualizar da versão 4 para a 5, cria a nova tabela!
          await m.createTable(itineraryItems);
        }
      },
    );
  }
}

AppDatabase createDatabase(PowerSyncDatabase powerSyncDb) {
  final executor = SqliteAsyncDriftConnection(powerSyncDb.database);
  return AppDatabase(executor);
}