import '../entities/product.dart';

abstract class ProductRepository {
  Stream<List<ProductEntity>> watchProducts();

  Future<void> saveProduct(ProductEntity product);

  Future<void> deactivateProduct(String id);
}