import '../../domain/entities/payment.dart';
import '../../domain/repositories/payment_repository.dart';
import '../datasources/payment_local_datasource.dart';
import '../models/payment_model.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentLocalDataSource _localDataSource;

  PaymentRepositoryImpl(this._localDataSource);

  @override
  Stream<List<PaymentEntity>> watchPayments(String saleId) {
    return _localDataSource
        .watchPayments(saleId)
        .map((rows) => rows.map((row) => row.toEntity()).toList(growable: false));
  }

  @override
  Future<List<PaymentEntity>> getPayments(String saleId) async {
    final rows = await _localDataSource.getPayments(saleId);
    return rows.map((row) => row.toEntity()).toList(growable: false);
  }

  @override
  Future<PaymentEntity> registerPayment(PaymentEntity payment) async {
    final row = await _localDataSource.registerPayment(
      PaymentModel.fromEntity(payment),
    );
    return row.toEntity();
  }
}
