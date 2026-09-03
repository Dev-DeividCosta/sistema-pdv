import '../entities/employee.dart';

abstract class EmployeeRepository {
  Stream<List<EmployeeEntity>> watchEmployees();

  Future<void> saveEmployee(EmployeeEntity employee);
}