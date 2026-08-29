import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/app_database_provider.dart';
import '../../data/datasources/sale_local_datasource.dart';
import '../../data/repositories/sale_repository_impl.dart';
import '../../domain/entities/sale.dart';
import '../../domain/repositories/sale_repository.dart';
import '../../domain/usecases/complete_sale_usecase.dart';
import '../../domain/usecases/get_sale_history_usecase.dart';
import '../../domain/usecases/watch_products_usecase.dart';

final saleLocalDataSourceProvider = Provider<SaleLocalDataSource>(
  (ref) => SaleLocalDataSource(ref.watch(appDatabaseProvider)),
);

final saleRepositoryProvider = Provider<SaleRepository>(
  (ref) => SaleRepositoryImpl(ref.watch(saleLocalDataSourceProvider)),
);

final saleProductsStreamProvider = StreamProvider.autoDispose<List<SaleProduct>>(
  (ref) => WatchProductsUseCase(ref.watch(saleRepositoryProvider))(),
);

final saleHistoryStreamProvider = StreamProvider.autoDispose<List<SaleEntity>>(
  (ref) => GetSaleHistoryUseCase(ref.watch(saleRepositoryProvider))(),
);

final saleByIdProvider = FutureProvider.autoDispose.family<SaleEntity, String>(
  (ref, id) => ref.watch(saleRepositoryProvider).getSaleById(id),
);

final completeSaleUseCaseProvider = Provider<CompleteSaleUseCase>(
  (ref) => CompleteSaleUseCase(ref.watch(saleRepositoryProvider)),
);

class SaleCartState {
  final List<SaleItemDraft> items;
  final String? customerId;
  final String? paymentMethod;
  /// Valor de desconto informado pelo usuário, preservado enquanto o carrinho muda.
  final int requestedDiscountCentavos;

  const SaleCartState({
    this.items = const [],
    this.customerId,
    this.paymentMethod,
    this.requestedDiscountCentavos = 0,
  });

  int get subtotalCentavos =>
      items.fold(0, (sum, item) => sum + item.totalCentavos);

  /// Valor efetivamente aplicado, limitado ao subtotal atual.
  int get discountCentavos =>
      requestedDiscountCentavos > subtotalCentavos
          ? subtotalCentavos
          : requestedDiscountCentavos;

  int get totalCentavos => subtotalCentavos - discountCentavos;

  SaleDraft toDraft() {
    return SaleDraft(
      customerId: customerId,
      paymentMethod: paymentMethod,
      discountCentavos: discountCentavos,
      soldAt: DateTime.now().toUtc(),
      items: List<SaleItemDraft>.unmodifiable(items),
    );
  }
}

class SaleCartNotifier extends AutoDisposeNotifier<SaleCartState> {
  @override
  SaleCartState build() => const SaleCartState();

  void addProduct(SaleProduct product) {
    final index = state.items.indexWhere((item) => item.productId == product.id);
    if (index < 0) {
      state = SaleCartState(
        items: [
          ...state.items,
          SaleItemDraft(
            id: DateTime.now().microsecondsSinceEpoch.toString(),
            productId: product.id,
            productNome: product.nomeProduto,
            quantity: 1,
            unitPriceCentavos: product.precoVendaCentavos,
          ),
        ],
        customerId: state.customerId,
        paymentMethod: state.paymentMethod,
        requestedDiscountCentavos: state.requestedDiscountCentavos,
      );
      return;
    }

    final updatedItems = [...state.items];
    final item = updatedItems[index];
    updatedItems[index] = item.copyWith(quantity: item.quantity + 1);
    _replaceItems(updatedItems);
  }

  void increment(String itemId) {
    final items = [...state.items];
    final index = items.indexWhere((item) => item.id == itemId);
    if (index < 0) return;
    items[index] = items[index].copyWith(quantity: items[index].quantity + 1);
    _replaceItems(items);
  }

  void decrement(String itemId) {
    final items = [...state.items];
    final index = items.indexWhere((item) => item.id == itemId);
    if (index < 0) return;
    final item = items[index];
    if (item.quantity <= 1) {
      items.removeAt(index);
    } else {
      items[index] = item.copyWith(quantity: item.quantity - 1);
    }
    _replaceItems(items);
  }

  void remove(String itemId) {
    _replaceItems(state.items.where((item) => item.id != itemId).toList());
  }

  void setDiscountCentavos(int discountCentavos) {
    state = SaleCartState(
      items: state.items,
      customerId: state.customerId,
      paymentMethod: state.paymentMethod,
      requestedDiscountCentavos: discountCentavos < 0 ? 0 : discountCentavos,
    );
  }

  void setCustomerId(String? customerId) {
    state = SaleCartState(
      items: state.items,
      customerId: customerId,
      paymentMethod: state.paymentMethod,
      requestedDiscountCentavos: state.requestedDiscountCentavos,
    );
  }

  void setPaymentMethod(String? paymentMethod) {
    state = SaleCartState(
      items: state.items,
      customerId: state.customerId,
      paymentMethod: paymentMethod,
      requestedDiscountCentavos: state.requestedDiscountCentavos,
    );
  }

  void clear() {
    state = const SaleCartState();
  }

  void _replaceItems(List<SaleItemDraft> items) {
    state = SaleCartState(
      items: List<SaleItemDraft>.unmodifiable(items),
      customerId: state.customerId,
      paymentMethod: state.paymentMethod,
      requestedDiscountCentavos: state.requestedDiscountCentavos,
    );
  }
}

final saleCartProvider =
    AutoDisposeNotifierProvider<SaleCartNotifier, SaleCartState>(
  SaleCartNotifier.new,
);

class CompleteSaleNotifier extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> complete(SaleDraft draft) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(completeSaleUseCaseProvider)(draft),
    );

    if (!state.hasError) {
      ref.read(saleCartProvider.notifier).clear();
      ref.invalidate(saleHistoryStreamProvider);
    }
  }
}

final completeSaleProvider =
    AutoDisposeAsyncNotifierProvider<CompleteSaleNotifier, void>(
  CompleteSaleNotifier.new,
);
