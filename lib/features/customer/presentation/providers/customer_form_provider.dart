import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/database/app_database.dart';
import '../../data/datasources/customer_local_datasource.dart';
import '../../data/repositories/customer_repository_impl.dart';
import '../../domain/entities/customer.dart';
import '../../domain/repositories/customer_repository.dart';
import '../../domain/usecases/save_customer_usecase.dart';

// 1. Provider do Banco de Dados (Altere caso já tenha um provider global de AppDatabase)
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  throw UnimplementedError('Inicialize o appDatabaseProvider no ProviderScope no main.dart');
});

// 2. Provider do DataSource Local
final customerLocalDataSourceProvider = Provider<CustomerLocalDataSource>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return CustomerLocalDataSource(db);
});

// 3. Provider do Repositório
final customerRepositoryProvider = Provider<CustomerRepository>((ref) {
  final dataSource = ref.watch(customerLocalDataSourceProvider);
  return CustomerRepositoryImpl(dataSource);
});

final customersStreamProvider = StreamProvider.autoDispose<List<CustomerEntity>>((ref) {
  final repository = ref.watch(customerRepositoryProvider);
  return repository.watchCustomers();
});

// 4. Provider do UseCase
final saveCustomerUseCaseProvider = Provider<SaveCustomerUseCase>((ref) {
  final repository = ref.watch(customerRepositoryProvider);
  return SaveCustomerUseCase(repository);
});

// 5. Notifier/Controller da Tela
class CustomerFormNotifier extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    // Estado inicial vazio
  }

  Future<void> saveCustomer(CustomerEntity customer) async {
    state = const AsyncValue.loading();
    
    state = await AsyncValue.guard(() async {
      final useCase = ref.read(saveCustomerUseCaseProvider);
      await useCase(customer);

      ref.invalidate(customersStreamProvider);
    });
  }
}

final customerFormProvider = AutoDisposeAsyncNotifierProvider<CustomerFormNotifier, void>(() {
  return CustomerFormNotifier();
});