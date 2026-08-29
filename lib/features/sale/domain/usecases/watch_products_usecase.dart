import '../entities/sale.dart';
import '../repositories/sale_repository.dart';

class WatchProductsUseCase {
  final SaleRepository _repository;

  WatchProductsUseCase(this._repository);

  Stream<List<SaleProduct>> call() {
    return _repository.watchActiveProducts();
  }
}
