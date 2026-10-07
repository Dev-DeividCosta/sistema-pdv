import 'package:drift/drift.dart';
import '../../../../app/database/app_database.dart';

class CustomerLocalDataSource {
  final AppDatabase _db;

  CustomerLocalDataSource(this._db);

  /// Consulta reativa ignorando os registros deletados logicamente (soft delete)
  Stream<List<Customer>> watchCustomers() {
    return (_db.select(_db.customers)
          ..where((t) => t.isDeleted.equals(false)))
        .watch();
  }

  /// Busca todos os clientes não deletados uma única vez
  Future<List<Customer>> getCustomers() {
    return (_db.select(_db.customers)
          ..where((t) => t.isDeleted.equals(false)))
        .get();
  }

  /// Persiste um cliente sem usar UPSERT.
  ///
  /// A tabela sincronizada pelo PowerSync é exposta ao Drift como uma view.
  /// SQLite não permite `ON CONFLICT DO UPDATE` em views, portanto o fluxo
  /// precisa consultar a existência e executar INSERT ou UPDATE separado.
  /// Isso também preserva explicitamente `is_ativo = false`.
  Future<void> saveCustomer(CustomersCompanion customer) async {
    final id = customer.id.value;
    if (id.isEmpty) {
      throw StateError('Não foi possível salvar o cliente sem um identificador.');
    }

    final existing = await (_db.select(_db.customers)
          ..where((table) => table.id.equals(id)))
        .getSingleOrNull();

    if (existing == null) {
      await _db.into(_db.customers).insert(customer);
    } else {
      await (_db.update(_db.customers)..where((table) => table.id.equals(id)))
          .write(customer.copyWith(id: const Value.absent()));
    }

    // Não reler e validar a view imediatamente após a escrita. O PowerSync
    // pode aplicar a alteração local de forma assíncrona; nesse intervalo uma
    // leitura imediata ainda pode devolver o valor anterior e gerar um falso
    // erro, mesmo com a operação aceita. O stream reativo do Drift/PowerSync
    // é a fonte de atualização da interface.
  }

  /// Soft Delete: Atualiza a flag isDeleted para true
  Future<void> deleteCustomer(String id) async {
    await (_db.update(_db.customers)
          ..where((t) => t.id.equals(id)))
        .write(
          const CustomersCompanion(
            isDeleted: Value(true),
          ),
        );
  }
}
