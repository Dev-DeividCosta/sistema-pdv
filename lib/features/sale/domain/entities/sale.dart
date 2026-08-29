class SaleProduct {
  final String id;
  final String nomeProduto;
  final String? codigoBarras;
  final double precoVenda;
  final bool ativo;

  const SaleProduct({
    required this.id,
    required this.nomeProduto,
    this.codigoBarras,
    required this.precoVenda,
    required this.ativo,
  });

  int get precoVendaCentavos => (precoVenda * 100).round();
}

class SaleItemDraft {
  final String id;
  final String productId;
  final String productNome;
  final int quantity;
  final int unitPriceCentavos;

  const SaleItemDraft({
    required this.id,
    required this.productId,
    required this.productNome,
    required this.quantity,
    required this.unitPriceCentavos,
  });

  int get totalCentavos => quantity * unitPriceCentavos;

  SaleItemDraft copyWith({
    String? id,
    String? productId,
    String? productNome,
    int? quantity,
    int? unitPriceCentavos,
  }) {
    return SaleItemDraft(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productNome: productNome ?? this.productNome,
      quantity: quantity ?? this.quantity,
      unitPriceCentavos: unitPriceCentavos ?? this.unitPriceCentavos,
    );
  }
}

class SaleDraft {
  final String? id;
  final String? customerId;
  final String? paymentMethod;
  final int discountCentavos;
  final DateTime soldAt;
  final List<SaleItemDraft> items;

  const SaleDraft({
    this.id,
    this.customerId,
    this.paymentMethod,
    this.discountCentavos = 0,
    required this.soldAt,
    this.items = const [],
  });

  int get subtotalCentavos =>
      items.fold(0, (sum, item) => sum + item.totalCentavos);

  int get totalCentavos => subtotalCentavos - discountCentavos;
}

class SaleItem {
  final String id;
  final String saleId;
  final String productId;
  final String productNome;
  final int quantity;
  final int unitPriceCentavos;
  final int totalCentavos;

  const SaleItem({
    required this.id,
    required this.saleId,
    required this.productId,
    required this.productNome,
    required this.quantity,
    required this.unitPriceCentavos,
    required this.totalCentavos,
  });
}

class SaleEntity {
  final String id;
  final String? customerId;
  final String status;
  final String? paymentMethod;
  final int subtotalCentavos;
  final int discountCentavos;
  final int totalCentavos;
  final DateTime soldAt;
  final DateTime createdAt;
  final List<SaleItem> items;

  const SaleEntity({
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
}
