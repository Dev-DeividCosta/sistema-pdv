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

  /// Insere ou atualiza um cliente compatível com as Views do PowerSync
  Future<void> saveCustomer(CustomersCompanion customer) async {
    await _db.into(_db.customers).insert(
          customer,
          mode: InsertMode.insertOrReplace,
        );
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