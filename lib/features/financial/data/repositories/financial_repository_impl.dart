import '../../domain/entities/financial_city.dart';
import '../../domain/entities/financial_employee.dart';
import '../../domain/entities/financial_entry.dart';
import '../../domain/entities/financial_query.dart';
import '../../domain/repositories/financial_repository.dart';
import '../datasources/financial_local_datasource.dart';

class FinancialRepositoryImpl implements FinancialRepository {
  final FinancialLocalDataSource _localDataSource;

  FinancialRepositoryImpl(this._localDataSource);

  @override
  Future<List<FinancialCity>> getCities() async =>
      (await _localDataSource.getCities())
          .map((model) => model.toEntity())
          .toList(growable: false);

  @override
  Future<List<FinancialEmployee>> getEmployees() async =>
      (await _localDataSource.getEmployees())
          .map((model) => model.toEntity())
          .toList(growable: false);

  @override
  Future<List<FinancialEntry>> getSales(FinancialQuery query) async =>
      (await _localDataSource.getSales(query))
          .map((model) => model.toEntity())
          .toList(growable: false);
}
