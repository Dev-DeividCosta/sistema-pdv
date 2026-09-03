import '../../domain/entities/employee.dart';
import '../../domain/repositories/employee_repository.dart';
import '../datasources/employee_local_datasource.dart';
import '../models/employee_model.dart';

class EmployeeRepositoryImpl implements EmployeeRepository {
  final EmployeeLocalDataSource _localDataSource;

  EmployeeRepositoryImpl(this._localDataSource);

  @override
  Stream<List<EmployeeEntity>> watchEmployees() {
    return _localDataSource
        .watchEmployees()
        .map(
          (items) => items
              .map((item) => item.toEntity())
              .toList(),
        );
  }

  @override
  Future<void> saveEmployee(EmployeeEntity employee) {
    return _localDataSource.saveEmployee(
      EmployeeModel(
        id: employee.id,
        nome: employee.nome,
        apelido: employee.apelido,
        cpf: employee.cpf,
        isAtivo: employee.isAtivo,
        createdAt: employee.createdAt,
      ),
    );
  }
}