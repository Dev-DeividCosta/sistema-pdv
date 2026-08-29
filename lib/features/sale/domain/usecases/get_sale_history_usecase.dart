import '../entities/sale.dart';
import '../repositories/sale_repository.dart';

class GetSaleHistoryUseCase {
  final SaleRepository _repository;

  GetSaleHistoryUseCase(this._repository);

  Stream<List<SaleEntity>> call() {
    return _repository.watchSaleHistory();
  }
}
