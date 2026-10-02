import 'package:flutter/material.dart';

/// Fonte única de verdade para os status de uma venda.
///
/// O [value] é o valor persistido; [label] e [color] são usados por todas
/// as telas, filtros, recibos e componentes que exibem o status.
enum SaleStatus {
  pending('pending', 'Pendente', Color(0xFFFFC107)),
  paid('paid', 'Quitado', Color(0xFF86C5A6)),
  cancelled('cancelled', 'Cancelado', Color(0xFFE57373)),
  returned('returned', 'Devolvido', Color(0xFF64B5F6));

  const SaleStatus(this.value, this.label, this.color);

  final String value;
  final String label;
  final Color color;

  static SaleStatus fromValue(String value) {
    return values.firstWhere(
      (status) => status.value == value,
      orElse: () => SaleStatus.pending,
    );
  }

  /// Compatibilidade com registros antigos: o antigo `completed` significava
  /// apenas que a venda foi criada, não que o pagamento foi quitado.
  static String normalizeValue(String value) =>
      value == 'completed' ? SaleStatus.pending.value : fromValue(value).value;

  static List<SaleStatus> get manualOptions =>
      values.where((status) => status != SaleStatus.paid).toList(growable: false);
}

extension SaleStatusValue on String {
  SaleStatus get saleStatus => SaleStatus.fromValue(this);
}
