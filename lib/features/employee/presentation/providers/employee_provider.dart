import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/app_database_provider.dart';
import '../../data/datasources/employee_local_datasource.dart';
import '../../data/repositories/employee_repository_impl.dart';
import '../../domain/entities/employee.dart';
import '../../domain/repositories/employee_repository.dart';
import '../../domain/usecases/save_employee_usecase.dart';

final employeeLocalDataSourceProvider = Provider<EmployeeLocalDataSource>(
  (ref) => EmployeeLocalDataSource(
    ref.watch(appDatabaseProvider),
  ),
);

final employeeRepositoryProvider = Provider<EmployeeRepository>(
  (ref) => EmployeeRepositoryImpl(
    ref.watch(employeeLocalDataSourceProvider),
  ),
);

final employeesStreamProvider =
    StreamProvider.autoDispose<List<EmployeeEntity>>(
  (ref) => ref.watch(employeeRepositoryProvider).watchEmployees(),
);

final saveEmployeeUseCaseProvider = Provider<SaveEmployeeUseCase>(
  (ref) => SaveEmployeeUseCase(
    ref.watch(employeeRepositoryProvider),
  ),
);

class EmployeeFormNotifier extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> saveEmployee(EmployeeEntity employee) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await ref.read(saveEmployeeUseCaseProvider)(employee);

      ref.invalidate(employeesStreamProvider);
    });
  }
}

final employeeFormProvider =
    AutoDisposeAsyncNotifierProvider<EmployeeFormNotifier, void>(
  EmployeeFormNotifier.new,
);