import '../../domain/entities/payment_method.dart';
import '../../domain/repositories/payment_method_repository.dart';
import '../datasources/payment_method_local_datasource.dart';
import '../models/payment_method_model.dart';

class PaymentMethodRepositoryImpl implements PaymentMethodRepository {
  final PaymentMethodLocalDataSource _localDataSource;

  PaymentMethodRepositoryImpl(this._localDataSource);

  @override
  Stream<List<PaymentMethodEntity>> watchPaymentMethods() {
    return _localDataSource
        .watchPaymentMethods()
        .map((items) => items.map((item) => item.toEntity()).toList(growable: false));
  }

  @override
  Future<void> savePaymentMethod(PaymentMethodEntity paymentMethod) {
    return _localDataSource.savePaymentMethod(
      PaymentMethodModel(
        id: paymentMethod.id,
        nome: paymentMethod.nome,
        isAtivo: paymentMethod.isAtivo,
        createdAt: paymentMethod.createdAt,
      ),
    );
  }

  @override
  Future<void> deletePaymentMethod(String id) {
    return _localDataSource.deletePaymentMethod(id);
  }
}
