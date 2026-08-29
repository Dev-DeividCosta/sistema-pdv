import 'dart:async';

import 'package:drift/drift.dart';

import '../../../../app/database/app_database.dart';
import '../models/sale_model.dart';

class SaleLocalDataSource {
  final AppDatabase _db;
  final StreamController<void> _saleChanges =
      StreamController<void>.broadcast();

  SaleLocalDataSource(this._db);

  Stream<List<SaleProductModel>> watchActiveProducts() {
    return (_db.select(_db.products)
          ..where((table) => table.ativo.equals(true))
          ..orderBy([
            (table) => OrderingTerm(expression: table.nomeProduto),
          ]))
        .watch()
        .map(
          (rows) => rows
              .map(
                (row) => SaleProductModel(
                  id: row.id,
                  nomeProduto: row.nomeProduto,
                  codigoBarras: row.codigoBarras,
                  precoVenda: row.precoVenda,
                  ativo: row.ativo,
                ),
              )
              .toList(growable: false),
        );
  }

  Stream<List<SaleModel>> watchSaleHistory() async* {
    await _db.ensureSalesTables();
    yield await getSaleHistory();
    yield* _saleChanges.stream.asyncMap((_) => getSaleHistory());
  }

  Future<List<SaleModel>> getSaleHistory() async {
    await _db.ensureSalesTables();
    final rows = await _db
        .customSelect(
          '''
          SELECT id, customer_id, status, payment_method,
                 subtotal_centavos, discount_centavos, total_centavos,
                 sold_at, created_at
          FROM sales
          WHERE is_deleted = 0
          ORDER BY sold_at DESC, created_at DESC
          ''',
        )
        .get();

    final sales = <SaleModel>[];
    for (final row in rows) {
      final saleId = row.read<String>('id');
      sales.add(
        SaleModel(
          id: saleId,
          customerId: row.readNullable<String>('customer_id'),
          status: row.read<String>('status'),
          paymentMethod: row.readNullable<String>('payment_method'),
          subtotalCentavos: row.read<int>('subtotal_centavos'),
          discountCentavos: row.read<int>('discount_centavos'),
          totalCentavos: row.read<int>('total_centavos'),
          soldAt: DateTime.parse(row.read<String>('sold_at')).toLocal(),
          createdAt: DateTime.parse(row.read<String>('created_at')).toLocal(),
          items: await _getSaleItems(saleId),
        ),
      );
    }
    return sales;
  }

  Future<SaleModel> getSaleById(String id) async {
    await _db.ensureSalesTables();
    final rows = await _db
        .customSelect(
          '''
          SELECT id, customer_id, status, payment_method,
                 subtotal_centavos, discount_centavos, total_centavos,
                 sold_at, created_at
          FROM sales
          WHERE id = ? AND is_deleted = 0
          LIMIT 1
          ''',
          variables: [Variable<String>(id)],
        )
        .get();

    if (rows.isEmpty) {
      throw Exception('Venda não encontrada.');
    }

    final row = rows.first;
    return SaleModel(
      id: row.read<String>('id'),
      customerId: row.readNullable<String>('customer_id'),
      status: row.read<String>('status'),
      paymentMethod: row.readNullable<String>('payment_method'),
      subtotalCentavos: row.read<int>('subtotal_centavos'),
      discountCentavos: row.read<int>('discount_centavos'),
      totalCentavos: row.read<int>('total_centavos'),
      soldAt: DateTime.parse(row.read<String>('sold_at')).toLocal(),
      createdAt: DateTime.parse(row.read<String>('created_at')).toLocal(),
      items: await _getSaleItems(id),
    );
  }

  Future<List<SaleItemModel>> _getSaleItems(String saleId) async {
    final rows = await _db
        .customSelect(
          '''
          SELECT id, sale_id, product_id, product_nome, quantity,
                 unit_price_centavos, total_centavos
          FROM sale_items
          WHERE sale_id = ?
          ORDER BY rowid
          ''',
          variables: [Variable<String>(saleId)],
        )
        .get();

    return rows
        .map(
          (row) => SaleItemModel(
            id: row.read<String>('id'),
            saleId: row.read<String>('sale_id'),
            productId: row.read<String>('product_id'),
            productNome: row.read<String>('product_nome'),
            quantity: row.read<int>('quantity'),
            unitPriceCentavos: row.read<int>('unit_price_centavos'),
            totalCentavos: row.read<int>('total_centavos'),
          ),
        )
        .toList(growable: false);
  }

  Future<void> completeSale(SaleModel sale) async {
    await _db.ensureSalesTables();
    await _db.transaction(() async {
      await _db.customInsert(
        '''
        INSERT INTO sales (
          id, customer_id, status, payment_method, subtotal_centavos,
          discount_centavos, total_centavos, sold_at, created_at, is_deleted
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 0)
        ''',
        variables: [
          Variable<String>(sale.id),
          Variable<String>(sale.customerId),
          Variable<String>(sale.status),
          Variable<String>(sale.paymentMethod),
          Variable<int>(sale.subtotalCentavos),
          Variable<int>(sale.discountCentavos),
          Variable<int>(sale.totalCentavos),
          Variable<String>(sale.soldAt.toUtc().toIso8601String()),
          Variable<String>(sale.createdAt.toUtc().toIso8601String()),
        ],
      );

      for (final item in sale.items) {
        final product = await (_db.select(_db.products)
              ..where((table) => table.id.equals(item.productId)))
            .getSingleOrNull();

        if (product == null) {
          throw Exception(
            'Produto não encontrado para a venda: ${item.productNome} '
            '(ID: ${item.productId}).',
          );
        }

        if (product.quantidadeEstoque < item.quantity) {
          throw Exception(
            'Estoque insuficiente para o produto ${item.productNome}. '
            'Disponível: ${product.quantidadeEstoque}; solicitado: ${item.quantity}.',
          );
        }

        await (_db.update(_db.products)
              ..where((table) => table.id.equals(item.productId)))
            .write(
          ProductsCompanion(
            quantidadeEstoque: Value(
              product.quantidadeEstoque - item.quantity,
            ),
            updatedAt: Value(DateTime.now()),
          ),
        );

        await _db.customInsert(
          '''
          INSERT INTO sale_items (
            id, sale_id, product_id, product_nome, quantity,
            unit_price_centavos, total_centavos
          ) VALUES (?, ?, ?, ?, ?, ?, ?)
          ''',
          variables: [
            Variable<String>(item.id),
            Variable<String>(item.saleId),
            Variable<String>(item.productId),
            Variable<String>(item.productNome),
            Variable<int>(item.quantity),
            Variable<int>(item.unitPriceCentavos),
            Variable<int>(item.totalCentavos),
          ],
        );
      }
    });

    _saleChanges.add(null);
  }

  Future<void> dispose() async {
    await _saleChanges.close();
  }
}