import '../../domain/entities/payment.dart';

class PaymentModel {
  final String id;
  final String saleId;
  final String? employeeId;
  final String? paymentMethodId;
  final String? paymentMethodName;
  final int amountCentavos;
  final String paymentStatus;
  final DateTime paidAt;
  final DateTime createdAt;

  const PaymentModel({
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

  factory PaymentModel.fromEntity(PaymentEntity entity) => PaymentModel(
        id: entity.id,
        saleId: entity.saleId,
        employeeId: entity.employeeId,
        paymentMethodId: entity.paymentMethodId,
        paymentMethodName: entity.paymentMethodName,
        amountCentavos: entity.amountCentavos,
        paymentStatus: entity.paymentStatus,
        paidAt: entity.paidAt,
        createdAt: entity.createdAt,
      );

  PaymentEntity toEntity() => PaymentEntity(
        id: id,
        saleId: saleId,
        employeeId: employeeId,
        paymentMethodId: paymentMethodId,
        paymentMethodName: paymentMethodName,
        amountCentavos: amountCentavos,
        paymentStatus: paymentStatus,
        paidAt: paidAt,
        createdAt: createdAt,
      );
}
