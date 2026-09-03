import '../entities/payment_method.dart';

abstract class PaymentMethodRepository {
  Stream<List<PaymentMethodEntity>> watchPaymentMethods();
  Future<void> savePaymentMethod(PaymentMethodEntity paymentMethod);
  Future<void> deletePaymentMethod(String id);
}
