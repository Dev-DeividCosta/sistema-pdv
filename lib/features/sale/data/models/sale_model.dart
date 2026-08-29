import '../../domain/entities/sale.dart';

class SaleItemModel {
  final String id;
  final String saleId;
  final String productId;
  final String productNome;
  final int quantity;
  final int unitPriceCentavos;
  final int totalCentavos;

  const SaleItemModel({
    required this.id,
    required this.saleId,
    required this.productId,
    required this.productNome,
    required this.quantity,
    required this.unitPriceCentavos,
    required this.totalCentavos,
  });

  factory SaleItemModel.fromDraft(String saleId, SaleItemDraft item) {
    return SaleItemModel(
      id: item.id,
      saleId: saleId,
      productId: item.productId,
      productNome: item.productNome,
      quantity: item.quantity,
      unitPriceCentavos: item.unitPriceCentavos,
      totalCentavos: item.totalCentavos,
    );
  }

  SaleItem toEntity() {
    return SaleItem(
      id: id,
      saleId: saleId,
      productId: productId,
      productNome: productNome,
      quantity: quantity,
      unitPriceCentavos: unitPriceCentavos,
      totalCentavos: totalCentavos,
    );
  }
}

class SaleModel {
  final String id;
  final String? customerId;
  final String status;
  final String? paymentMethod;
  final int subtotalCentavos;
  final int discountCentavos;
  final int totalCentavos;
  final DateTime soldAt;
  final DateTime createdAt;
  final List<SaleItemModel> items;

  const SaleModel({
    required this.id,
    this.customerId,
    required this.status,
    this.paymentMethod,
    required this.subtotalCentavos,
    required this.discountCentavos,
    required this.totalCentavos,
    required this.soldAt,
    required this.createdAt,
    this.items = const [],
  });

  factory SaleModel.fromDraft(SaleDraft draft) {
    final saleId = draft.id ?? DateTime.now().microsecondsSinceEpoch.toString();
    return SaleModel(
      id: saleId,
      customerId: draft.customerId,
      status: 'completed',
      paymentMethod: draft.paymentMethod,
      subtotalCentavos: draft.subtotalCentavos,
      discountCentavos: draft.discountCentavos,
      totalCentavos: draft.totalCentavos,
      soldAt: draft.soldAt,
      createdAt: DateTime.now().toUtc(),
      items: [
        for (final item in draft.items) SaleItemModel.fromDraft(saleId, item),
      ],
    );
  }

  SaleEntity toEntity() {
    return SaleEntity(
      id: id,
      customerId: customerId,
      status: status,
      paymentMethod: paymentMethod,
      subtotalCentavos: subtotalCentavos,
      discountCentavos: discountCentavos,
      totalCentavos: totalCentavos,
      soldAt: soldAt,
      createdAt: createdAt,
      items: items.map((item) => item.toEntity()).toList(growable: false),
    );
  }
}

class SaleProductModel {
  final String id;
  final String nomeProduto;
  final String? codigoBarras;
  final double precoVenda;
  final bool ativo;

  const SaleProductModel({
    required this.id,
    required this.nomeProduto,
    this.codigoBarras,
    required this.precoVenda,
    required this.ativo,
  });

  SaleProduct toEntity() {
    return SaleProduct(
      id: id,
      nomeProduto: nomeProduto,
      codigoBarras: codigoBarras,
      precoVenda: precoVenda,
      ativo: ativo,
    );
  }
}
