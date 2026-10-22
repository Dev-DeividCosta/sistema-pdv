import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/app_database_provider.dart';
import '../../data/datasources/financial_local_datasource.dart';
import '../../data/repositories/financial_repository_impl.dart';
import '../../domain/entities/financial_city.dart';
import '../../domain/entities/financial_employee.dart';
import '../../domain/entities/financial_entry.dart';
import '../../domain/entities/financial_query.dart';
import '../../domain/repositories/financial_repository.dart';
import '../../domain/usecases/get_financial_report_usecase.dart';

final financialLocalDataSourceProvider = Provider<FinancialLocalDataSource>(
  (ref) => FinancialLocalDataSource(ref.watch(appDatabaseProvider)),
);

final financialRepositoryProvider = Provider<FinancialRepository>(
  (ref) => FinancialRepositoryImpl(ref.watch(financialLocalDataSourceProvider)),
);

final getFinancialReportUseCaseProvider = Provider<GetFinancialReportUseCase>(
  (ref) => GetFinancialReportUseCase(ref.watch(financialRepositoryProvider)),
);

final financialCitiesProvider = FutureProvider.autoDispose<List<FinancialCity>>(
  (ref) => ref.watch(financialRepositoryProvider).getCities(),
);

final financialEmployeesProvider =
    FutureProvider.autoDispose<List<FinancialEmployee>>(
  (ref) => ref.watch(financialRepositoryProvider).getEmployees(),
);

final financialReportProvider = FutureProvider.autoDispose
    .family<FinancialReport, FinancialQuery>(
  (ref, query) => ref.watch(getFinancialReportUseCaseProvider)(query),
);
