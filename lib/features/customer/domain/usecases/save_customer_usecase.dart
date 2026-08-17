import '../entities/customer.dart';
import '../repositories/customer_repository.dart';

class SaveCustomerUseCase {
  final CustomerRepository _repository;

  SaveCustomerUseCase(this._repository);

  Future<void> call(CustomerEntity customer) async {
    CustomerEntity customerToSave = customer;

    // Se o usuário digitou o CPF (é opcional), limpamos a máscara e validamos
    if (customer.cpf != null && customer.cpf!.trim().isNotEmpty) {
      final String numericCpf = customer.cpf!.replaceAll(RegExp(r'\D'), '');

      if (!_isValidCpf(numericCpf)) {
        throw Exception('O CPF informado é inválido.');
      }

      // Substitui o CPF com máscara pelo apenas com números antes de salvar
      customerToSave = customer.copyWith(cpf: numericCpf);
    } else {
      // Se estava vazio ou com espaços, salva como nulo
      customerToSave = customer.copyWith(cpf: null);
    }

    await _repository.saveCustomer(customerToSave);
  }

  // Lógica completa de validação de CPF (Módulo 11)
  bool _isValidCpf(String cpf) {
    if (cpf.length != 11) return false;
    
    // Verifica se todos os números são iguais (ex: 111.111.111-11)
    if (RegExp(r'^(\d)\1*$').hasMatch(cpf)) return false;

    List<int> numbers = cpf.split('').map((String d) => int.parse(d)).toList();

    // Validação do primeiro dígito
    int sum1 = 0;
    for (int i = 0; i < 9; i++) {
      sum1 += numbers[i] * (10 - i);
    }
    int digit1 = 11 - (sum1 % 11);
    if (digit1 >= 10) digit1 = 0;

    // Validação do segundo dígito
    int sum2 = 0;
    for (int i = 0; i < 10; i++) {
      sum2 += numbers[i] * (11 - i);
    }
    int digit2 = 11 - (sum2 % 11);
    if (digit2 >= 10) digit2 = 0;

    return numbers[9] == digit1 && numbers[10] == digit2;
  }
}