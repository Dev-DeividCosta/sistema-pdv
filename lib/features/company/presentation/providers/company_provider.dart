import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/app_database_provider.dart';
import '../../data/datasources/company_local_datasource.dart';
import '../../data/repositories/company_repository_impl.dart';
import '../../domain/entities/company.dart';
import '../../domain/repositories/company_repository.dart';
import '../../domain/usecases/save_company_usecase.dart';

final companyRepositoryProvider = Provider<CompanyRepository>((ref) {
  return CompanyRepositoryImpl(
    CompanyLocalDataSource(ref.watch(appDatabaseProvider)),
  );
});

final companyProvider = StreamProvider<CompanyEntity?>((ref) {
  return ref.watch(companyRepositoryProvider).watchCompany();
});

final saveCompanyUseCaseProvider = Provider<SaveCompanyUseCase>((ref) {
  return SaveCompanyUseCase(ref.watch(companyRepositoryProvider));
});

class CompanyFormNotifier extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> saveCompany(CompanyEntity company) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(saveCompanyUseCaseProvider)(company);
      ref.invalidate(companyProvider);
    });
  }
}

final companyFormProvider =
    AutoDisposeAsyncNotifierProvider<CompanyFormNotifier, void>(
  CompanyFormNotifier.new,
);
