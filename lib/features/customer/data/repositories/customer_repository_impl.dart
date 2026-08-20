import 'package:drift/drift.dart';
import '../../../../app/database/app_database.dart';
import '../../domain/entities/customer.dart';
import '../../domain/repositories/customer_repository.dart';
import '../datasources/customer_local_datasource.dart';
import '../models/customer_model.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  final CustomerLocalDataSource _localDataSource;

  CustomerRepositoryImpl(this._localDataSource);

  @override
  Stream<List<CustomerEntity>> watchCustomers() {
    return _localDataSource.watchCustomers().map(
          (dbCustomers) => dbCustomers.map((c) => c.toEntity()).toList(),
        );
  }

  @override
  Future<void> saveCustomer(CustomerEntity customer) async {
    final companion = CustomersCompanion(
      id: Value(customer.id),
      nome: Value(customer.nome),
      apelido: Value(customer.apelido),
      cpf: Value(customer.cpf),
      rua: Value(customer.rua),
      numero: Value(customer.numero),
      complemento: Value(customer.complemento),
      bairro: Value(customer.bairro),
      cityId: Value(customer.cityId),
      uf: Value(customer.uf),
      cep: Value(customer.cep),
      telefoneFixo: Value(customer.telefoneFixo),
      celular: Value(customer.celular),
      email: Value(customer.email),
      observacoes: Value(customer.observacoes),
      isAtivo: Value(customer.isAtivo),
      isDeleted: const Value(false),
      createdAt: Value(customer.createdAt),
    );
    await _localDataSource.saveCustomer(companion);
  }

  @override
  Future<void> deleteCustomer(String id) async {
    await _localDataSource.deleteCustomer(id);
  }
}