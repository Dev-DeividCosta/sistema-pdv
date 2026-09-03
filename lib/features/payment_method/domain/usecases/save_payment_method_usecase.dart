import '../entities/payment_method.dart';
import '../repositories/payment_method_repository.dart';

class SavePaymentMethodUseCase {
  final PaymentMethodRepository _repository;

  SavePaymentMethodUseCase(this._repository);

  Future<void> call(PaymentMethodEntity paymentMethod) async {
    final nome = paymentMethod.nome.trim();
    if (nome.isEmpty) {
      throw Exception('O nome da forma de pagamento é obrigatório.');
    }
    await _repository.savePaymentMethod(paymentMethod.copyWith(nome: nome));
  }
}
