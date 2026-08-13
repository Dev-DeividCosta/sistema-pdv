import '../entities/customer.dart';

abstract class CustomerRepository {
  /// Retorna uma Stream com a lista atualizada de clientes em tempo real.
  Stream<List<CustomerEntity>> watchCustomers();

  /// Salva ou atualiza um cliente no banco de dados.
  Future<void> saveCustomer(CustomerEntity customer);

  /// Remove (ou marca como deletado) um cliente pelo ID.
  Future<void> deleteCustomer(String id);
}