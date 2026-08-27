import '../../../../app/database/app_database.dart' as db;

import '../../domain/entities/product.dart';

extension ProductModelMapper on db.Product {
  ProductEntity toEntity() {
    return ProductEntity(
      id: id,
      codigoBarras: codigoBarras,
      nomeProduto: nomeProduto,
      precoCusto: precoCusto,
      precoVenda: precoVenda,
      quantidadeEstoque: quantidadeEstoque,
      ativo: ativo,
      descricao: descricao,
      estoqueMinimo: estoqueMinimo,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}