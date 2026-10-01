import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/app_database_provider.dart';
import '../../data/datasources/payment_local_datasource.dart';
import '../../data/repositories/payment_repository_impl.dart';
import '../../domain/entities/payment.dart';
import '../../domain/repositories/payment_repository.dart';

final paymentLocalDataSourceProvider = Provider<PaymentLocalDataSource>(
  (ref) => PaymentLocalDataSource(ref.watch(appDatabaseProvider)),
);

final paymentRepositoryProvider = Provider<PaymentRepository>(
  (ref) => PaymentRepositoryImpl(ref.watch(paymentLocalDataSourceProvider)),
);

final salePaymentsStreamProvider =
    StreamProvider.autoDispose.family<List<PaymentEntity>, String>(
  (ref, saleId) => ref.watch(paymentRepositoryProvider).watchPayments(saleId),
);

class RegisterPaymentNotifier extends AutoDisposeAsyncNotifier<PaymentEntity?> {
  @override
  FutureOr<PaymentEntity?> build() => null;

  Future<PaymentEntity?> register(PaymentEntity payment) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(paymentRepositoryProvider).registerPayment(payment),
    );
    return state.asData?.value;
  }
}

final registerPaymentProvider = AutoDisposeAsyncNotifierProvider<
    RegisterPaymentNotifier, PaymentEntity?>(RegisterPaymentNotifier.new);
