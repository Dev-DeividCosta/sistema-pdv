import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/app_database_provider.dart';
import '../../data/datasources/payment_method_local_datasource.dart';
import '../../data/repositories/payment_method_repository_impl.dart';
import '../../domain/entities/payment_method.dart';
import '../../domain/repositories/payment_method_repository.dart';
import '../../domain/usecases/save_payment_method_usecase.dart';

final paymentMethodRepositoryProvider = Provider<PaymentMethodRepository>((ref) {
  return PaymentMethodRepositoryImpl(
    PaymentMethodLocalDataSource(ref.watch(appDatabaseProvider)),
  );
});

final paymentMethodsStreamProvider = StreamProvider<List<PaymentMethodEntity>>((ref) {
  return ref.watch(paymentMethodRepositoryProvider).watchPaymentMethods();
});

final savePaymentMethodUseCaseProvider = Provider<SavePaymentMethodUseCase>((ref) {
  return SavePaymentMethodUseCase(ref.watch(paymentMethodRepositoryProvider));
});

class PaymentMethodFormNotifier extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> savePaymentMethod(PaymentMethodEntity paymentMethod) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(savePaymentMethodUseCaseProvider)(paymentMethod);
      ref.invalidate(paymentMethodsStreamProvider);
    });
  }

  Future<void> deletePaymentMethod(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(paymentMethodRepositoryProvider).deletePaymentMethod(id);
      ref.invalidate(paymentMethodsStreamProvider);
    });
  }
}

final paymentMethodFormProvider =
    AutoDisposeAsyncNotifierProvider<PaymentMethodFormNotifier, void>(
  PaymentMethodFormNotifier.new,
);
