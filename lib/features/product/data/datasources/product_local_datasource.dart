import 'package:drift/drift.dart';

import '../../../../app/database/app_database.dart';

class ProductLocalDataSource {
  final AppDatabase _db;

  ProductLocalDataSource(this._db);
  Stream<List<Product>> watchProducts() {
    return (_db.select(_db.products)
          ..orderBy([
            (table) => OrderingTerm(
                  expression: table.nomeProduto,
                ),
          ]))
        .watch();
  }

  Future<List<Product>> getProducts() {
    return (_db.select(_db.products)
          ..orderBy([
            (table) => OrderingTerm(
                  expression: table.nomeProduto,
                ),
          ]))
        .get();
  }

  Future<void> saveProduct(ProductsCompanion product) async {
    await _db.into(_db.products).insert(
          product,
          mode: InsertMode.insertOrReplace,
        );
  }

  Future<void> deactivateProduct(String id) async {
    await (_db.update(_db.products)
          ..where((table) => table.id.equals(id)))
        .write(
      ProductsCompanion(
        ativo: const Value(false),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }
}