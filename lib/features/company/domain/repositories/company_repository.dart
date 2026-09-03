import '../entities/company.dart';

abstract class CompanyRepository {
  Stream<CompanyEntity?> watchCompany();
  Future<void> saveCompany(CompanyEntity company);
}
