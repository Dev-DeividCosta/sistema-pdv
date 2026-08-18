import '../../../../core/utils/cpf_validator.dart';
import '../entities/customer.dart';
import '../repositories/customer_repository.dart';

class SaveCustomerUseCase {
  final CustomerRepository _repository;

  SaveCustomerUseCase(this._repository);

  Future<void> call(CustomerEntity customer) async {
    CustomerEntity customerToSave = customer;

    if (customer.cpf != null && customer.cpf!.trim().isNotEmpty) {
      
      if (!CpfValidator.isValid(customer.cpf)) {
        throw Exception('O CPF informado é inválido.');
      }

      final String numericCpf = customer.cpf!.replaceAll(RegExp(r'\D'), '');
      customerToSave = customer.copyWith(cpf: numericCpf);
    } else {
      customerToSave = customer.copyWith(cpf: null);
    }

    await _repository.saveCustomer(customerToSave);
  }
}