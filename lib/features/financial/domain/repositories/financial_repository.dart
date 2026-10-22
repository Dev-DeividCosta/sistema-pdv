import '../entities/financial_city.dart';
import '../entities/financial_employee.dart';
import '../entities/financial_entry.dart';
import '../entities/financial_query.dart';

abstract class FinancialRepository {
  Future<List<FinancialCity>> getCities();
  Future<List<FinancialEmployee>> getEmployees();
  Future<List<FinancialEntry>> getSales(FinancialQuery query);
}
