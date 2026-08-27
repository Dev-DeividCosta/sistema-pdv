import 'package:drift/drift.dart';

import '../../../../app/database/app_database.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_datasource.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductLocalDataSource _localDataSource;

  ProductRepositoryImpl(this._localDataSource);

  @override
  Stream<List<ProductEntity>> watchProducts() {
    return _localDataSource.watchProducts().map(
          (rows) => rows.map((row) => row.toEntity()).toList(),
        );
  }

  @override
  Future<void> saveProduct(ProductEntity product) {
    return _localDataSource.saveProduct(
      ProductsCompanion(
        id: Value(product.id),
        codigoBarras: Value(product.codigoBarras),
        nomeProduto: Value(product.nomeProduto.trim()),
        precoCusto: Value(product.precoCusto),
        precoVenda: Value(product.precoVenda),
        quantidadeEstoque: Value(product.quantidadeEstoque),
        ativo: Value(product.ativo),
        descricao: Value(product.descricao),
        estoqueMinimo: Value(product.estoqueMinimo),
        createdAt: Value(product.createdAt),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  @override
  Future<void> deactivateProduct(String id) {
    return _localDataSource.deactivateProduct(id);
  }
}