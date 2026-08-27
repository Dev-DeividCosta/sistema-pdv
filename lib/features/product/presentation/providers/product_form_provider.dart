import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/app_database_provider.dart';
import '../../data/datasources/product_local_datasource.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/usecases/save_product_usecase.dart';

final productLocalDataSourceProvider = Provider<ProductLocalDataSource>(
  (ref) => ProductLocalDataSource(
    ref.watch(appDatabaseProvider),
  ),
);

final productRepositoryProvider = Provider<ProductRepository>(
  (ref) => ProductRepositoryImpl(
    ref.watch(productLocalDataSourceProvider),
  ),
);

final productsStreamProvider = StreamProvider.autoDispose<List<ProductEntity>>(
  (ref) => ref.watch(productRepositoryProvider).watchProducts(),
);

final saveProductUseCaseProvider = Provider<SaveProductUseCase>(
  (ref) => SaveProductUseCase(
    ref.watch(productRepositoryProvider),
  ),
);

class ProductFormNotifier extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> saveProduct(ProductEntity product) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(
      () => ref.read(saveProductUseCaseProvider)(product),
    );

    if (!state.hasError) {
      ref.invalidate(productsStreamProvider);
    }
  }

  Future<void> deactivateProduct(String id) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(
      () => ref.read(productRepositoryProvider).deactivateProduct(id),
    );

    if (!state.hasError) {
      ref.invalidate(productsStreamProvider);
    }
  }
}

final productFormProvider =
    AutoDisposeAsyncNotifierProvider<ProductFormNotifier, void>(
  ProductFormNotifier.new,
);