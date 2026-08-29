import '../entities/sale.dart';

abstract class SaleRepository {
  Stream<List<SaleProduct>> watchActiveProducts();

  Stream<List<SaleEntity>> watchSaleHistory();

  Future<SaleEntity> getSaleById(String id);

  Future<void> completeSale(SaleDraft draft);
}
