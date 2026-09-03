import '../../domain/entities/company.dart';
import '../../domain/repositories/company_repository.dart';
import '../datasources/company_local_datasource.dart';
import '../models/company_model.dart';

class CompanyRepositoryImpl implements CompanyRepository {
  final CompanyLocalDataSource _dataSource;

  CompanyRepositoryImpl(this._dataSource);

  @override
  Stream<CompanyEntity?> watchCompany() =>
      _dataSource.watchCompany().map((model) => model?.toEntity());

  @override
  Future<void> saveCompany(CompanyEntity company) =>
      _dataSource.saveCompany(CompanyModel.fromEntity(company));
}
