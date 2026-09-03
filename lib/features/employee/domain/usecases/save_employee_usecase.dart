import '../entities/employee.dart';
import '../repositories/employee_repository.dart';

class SaveEmployeeUseCase {
  final EmployeeRepository repository;

  SaveEmployeeUseCase(this.repository);

  Future<void> call(EmployeeEntity employee) {
    return repository.saveEmployee(employee);
  }
}
