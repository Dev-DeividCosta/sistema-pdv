import '../entities/sale.dart';
import '../repositories/sale_repository.dart';

class CompleteSaleUseCase {
  final SaleRepository _repository;

  CompleteSaleUseCase(this._repository);

  Future<void> call(SaleDraft draft) {
    if (draft.items.isEmpty) {
      throw Exception('A venda precisa ter pelo menos um item.');
    }
    if (draft.items.any((item) => item.quantity <= 0)) {
      throw Exception('A quantidade de cada item deve ser maior que zero.');
    }
    if (draft.items.any((item) => item.unitPriceCentavos < 0)) {
      throw Exception('O preço dos itens não pode ser negativo.');
    }
    if (draft.discountCentavos < 0) {
      throw Exception('O desconto não pode ser negativo.');
    }
    if (draft.discountCentavos > draft.subtotalCentavos) {
      throw Exception('O desconto não pode ser maior que o subtotal.');
    }
    if (draft.totalCentavos < 0) {
      throw Exception('O total da venda não pode ser negativo.');
    }

    return _repository.completeSale(draft);
  }
}
