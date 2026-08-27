import '../entities/product.dart';
import '../repositories/product_repository.dart';

class SaveProductUseCase {
  final ProductRepository _repository;

  SaveProductUseCase(this._repository);

  Future<void> call(ProductEntity product) {
    if (product.nomeProduto.trim().isEmpty) {
      throw Exception('O nome do produto é obrigatório.');
    }

    if (product.precoCusto < 0 || product.precoVenda < 0) {
      throw Exception('Os preços não podem ser negativos.');
    }

    if (product.quantidadeEstoque < 0 || product.estoqueMinimo < 0) {
      throw Exception('As quantidades não podem ser negativas.');
    }

    return _repository.saveProduct(product);
  }
}