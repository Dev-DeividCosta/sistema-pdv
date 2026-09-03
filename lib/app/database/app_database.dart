import 'package:drift/drift.dart';
import 'package:drift_sqlite_async/drift_sqlite_async.dart';
import 'package:powersync/powersync.dart' hide Table, Column;
import 'tables/customer_table.dart';
import 'tables/city_table.dart';
import 'tables/itinerary_items_table.dart';
import 'tables/product_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [
  Customers,
  Cities,
  ItineraryItems,
  Products,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 7;

  // --- ADICIONADO: Estratégia de Migração ---
  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        await _createSalesTables();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 5) {
          // Quando atualizar da versão 4 para a 5, cria a nova tabela!
          await m.createTable(itineraryItems);
        }
        if (from < 6) {
          await m.createTable(products);
        }
        if (from < 7) {
          await _createSalesTables();
        }
      },
    );
  }

  /// As vendas permanecem locais neste MVP, mas são criadas no mesmo banco
  /// para que o fechamento transacional e o histórico sobrevivam ao reinício.
  /// Garante as tabelas de vendas também quando o arquivo SQLite já existia
  /// antes da migração 7 ou quando a migração não foi executada pelo executor.
  Future<void> ensureSalesTables() => _createSalesTables();

  Future<void> ensurePaymentMethodsTable() async {
    await customStatement('''
      CREATE TABLE IF NOT EXISTS payment_methods (
        id TEXT NOT NULL PRIMARY KEY,
        nome TEXT NOT NULL,
        is_ativo INTEGER NOT NULL DEFAULT 1,
        is_deleted INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL
      )
    ''');
  }

  Future<void> ensureEmployeesTable() async {
    await customStatement('''
      CREATE TABLE IF NOT EXISTS employees (
        id TEXT NOT NULL PRIMARY KEY,
        nome TEXT NOT NULL,
        apelido TEXT,
        cpf TEXT,
        is_ativo INTEGER NOT NULL DEFAULT 1,
        is_deleted INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL
      )
    ''');
  }

  Future<void> ensureCompanyTable() async {
    await customStatement('''
      CREATE TABLE IF NOT EXISTS company (
        id TEXT NOT NULL PRIMARY KEY,
        razao_social TEXT NOT NULL,
        nome_fantasia TEXT,
        cnpj TEXT,
        telefone TEXT,
        email TEXT,
        endereco TEXT,
        numero TEXT,
        complemento TEXT,
        bairro TEXT,
        cidade TEXT,
        uf TEXT,
        cep TEXT,
        is_ativo INTEGER NOT NULL DEFAULT 1,
        is_deleted INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL
      )
    ''');
  }

  Future<void> _createSalesTables() async {
    await customStatement('''
      CREATE TABLE IF NOT EXISTS sales (
        id TEXT NOT NULL PRIMARY KEY,
        customer_id TEXT,
        status TEXT NOT NULL DEFAULT 'completed',
        payment_method TEXT,
        subtotal_centavos INTEGER NOT NULL DEFAULT 0,
        discount_centavos INTEGER NOT NULL DEFAULT 0,
        total_centavos INTEGER NOT NULL DEFAULT 0,
        sold_at TEXT NOT NULL,
        created_at TEXT NOT NULL,
        is_deleted INTEGER NOT NULL DEFAULT 0
      )
    ''');
    await customStatement('''
      CREATE TABLE IF NOT EXISTS sale_items (
        id TEXT NOT NULL PRIMARY KEY,
        sale_id TEXT NOT NULL,
        product_id TEXT NOT NULL,
        product_nome TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        unit_price_centavos INTEGER NOT NULL,
        total_centavos INTEGER NOT NULL
      )
    ''');
  }
}

AppDatabase createDatabase(PowerSyncDatabase powerSyncDb) {
  final executor = SqliteAsyncDriftConnection(powerSyncDb.database);
  return AppDatabase(executor);
}