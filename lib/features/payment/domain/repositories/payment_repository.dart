import '../entities/payment.dart';

abstract class PaymentRepository {
  Stream<List<PaymentEntity>> watchPayments(String saleId);

  Future<List<PaymentEntity>> getPayments(String saleId);

  Future<PaymentEntity> registerPayment(PaymentEntity payment);
}
