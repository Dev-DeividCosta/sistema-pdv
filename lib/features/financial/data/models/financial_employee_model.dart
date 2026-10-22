import '../../domain/entities/financial_employee.dart';

class FinancialEmployeeModel {
  final String id;
  final String name;

  const FinancialEmployeeModel({required this.id, required this.name});

  FinancialEmployee toEntity() => FinancialEmployee(id: id, name: name);
}
