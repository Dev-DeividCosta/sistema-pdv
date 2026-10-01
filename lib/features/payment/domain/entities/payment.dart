import 'package:uuid/uuid.dart';

abstract final class PaymentStatus {
  static const completed = 'pagamento_concluido';
  static const pending = 'pendente';
  static const cancelled = 'cancelado';
}

class PaymentEntity {
  final String id;
  final String saleId;
  final String? employeeId;
  final String? paymentMethodId;
  final String? paymentMethodName;
  final int amountCentavos;
  final String paymentStatus;
  final DateTime paidAt;
  final DateTime createdAt;

  const PaymentEntity({
    required this.id,
    required this.saleId,
    this.employeeId,
    this.paymentMethodId,
    this.paymentMethodName,
    required this.amountCentavos,
    required this.paymentStatus,
    required this.paidAt,
    required this.createdAt,
  });

  factory PaymentEntity.create({
    required String saleId,
    required int amountCentavos,
    required String? employeeId,
    String? paymentMethodId,
    String? paymentMethodName,
  }) {
    final now = DateTime.now().toUtc();
    return PaymentEntity(
      id: const Uuid().v4(),
      saleId: saleId,
      employeeId: employeeId,
      paymentMethodId: paymentMethodId,
      paymentMethodName: paymentMethodName,
      amountCentavos: amountCentavos,
      paymentStatus: PaymentStatus.completed,
      paidAt: now,
      createdAt: now,
    );
  }

  bool get isCompleted => paymentStatus == PaymentStatus.completed;
}

String paymentStatusLabel(String status) {
  switch (status) {
    case PaymentStatus.completed:
      return 'Pagamento concluído';
    case PaymentStatus.pending:
      return 'Pendente';
    case PaymentStatus.cancelled:
      return 'Cancelado';
    default:
      return status;
  }
}
