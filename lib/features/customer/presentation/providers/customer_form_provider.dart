import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/app_database_provider.dart';
import '../../data/datasources/customer_local_datasource.dart';
import '../../data/repositories/customer_repository_impl.dart';
import '../../domain/entities/customer.dart';
import '../../domain/repositories/customer_repository.dart';
import '../../domain/usecases/save_customer_usecase.dart';

final customerLocalDataSourceProvider = Provider<CustomerLocalDataSource>((ref) {
  return CustomerLocalDataSource(ref.watch(appDatabaseProvider));
});

final customerRepositoryProvider = Provider<CustomerRepository>((ref) {
  return CustomerRepositoryImpl(ref.watch(customerLocalDataSourceProvider));
});

final customersStreamProvider = StreamProvider.autoDispose<List<CustomerEntity>>((ref) {
  return ref.watch(customerRepositoryProvider).watchCustomers();
});

final saveCustomerUseCaseProvider = Provider<SaveCustomerUseCase>((ref) {
  return SaveCustomerUseCase(ref.watch(customerRepositoryProvider));
});

class CustomerFormNotifier extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> saveCustomer(CustomerEntity customer) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(saveCustomerUseCaseProvider)(customer);
      ref.invalidate(customersStreamProvider);
    });
  }
}

final customerFormProvider = AutoDisposeAsyncNotifierProvider<CustomerFormNotifier, void>(
  CustomerFormNotifier.new,
);
