import '../entities/customer.dart';
import '../repositories/customer_repository.dart';

class SaveCustomerUseCase {
  final CustomerRepository _repository;

  SaveCustomerUseCase(this._repository);

  Future<void> call(CustomerEntity customer) async {
    await _repository.saveCustomer(customer);
  }
}