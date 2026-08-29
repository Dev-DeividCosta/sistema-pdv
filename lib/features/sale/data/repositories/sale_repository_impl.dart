import '../../domain/entities/sale.dart';
import '../../domain/repositories/sale_repository.dart';
import '../datasources/sale_local_datasource.dart';
import '../models/sale_model.dart';

class SaleRepositoryImpl implements SaleRepository {
  final SaleLocalDataSource _localDataSource;

  SaleRepositoryImpl(this._localDataSource);

  @override
  Stream<List<SaleProduct>> watchActiveProducts() {
    return _localDataSource
        .watchActiveProducts()
        .map((rows) => rows.map((row) => row.toEntity()).toList());
  }

  @override
  Stream<List<SaleEntity>> watchSaleHistory() {
    return _localDataSource
        .watchSaleHistory()
        .map((rows) => rows.map((row) => row.toEntity()).toList());
  }

  @override
  Future<SaleEntity> getSaleById(String id) async {
    final sale = await _localDataSource.getSaleById(id);
    return sale.toEntity();
  }

  @override
  Future<void> completeSale(SaleDraft draft) {
    return _localDataSource.completeSale(SaleModel.fromDraft(draft));
  }
}
