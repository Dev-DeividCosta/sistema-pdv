import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/providers/app_database_provider.dart';
import '../../data/datasources/itinerary_local_datasource.dart';
import '../../data/repositories/itinerary_repository_impl.dart';
import '../../domain/entities/itinerary_item.dart';
import '../../domain/repositories/itinerary_repository.dart';

final itineraryLocalDataSourceProvider = Provider<ItineraryLocalDataSource>((ref) {
  return ItineraryLocalDataSource(ref.watch(appDatabaseProvider));
});

final itineraryRepositoryProvider = Provider<ItineraryRepository>((ref) {
  return ItineraryRepositoryImpl(ref.watch(itineraryLocalDataSourceProvider));
});

// Identidade provisória para o modo local. Deve ser substituída pelo ID real
// do usuário autenticado quando o login for implementado.
const currentUserId = 'LOCAL_DEVICE_USER';

final itineraryListProvider = StreamProvider.family<List<ItineraryItemEntity>, String>((ref, cityId) {
  return ref.watch(itineraryRepositoryProvider).watchItineraryForCity(cityId, currentUserId);
});

class ItineraryNotifier extends Notifier<AsyncValue<void>> {
  Future<void> _lastOperation = Future<void>.value();

  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<void> _enqueue(Future<void> Function() operation) {
    final next = _lastOperation.then((_) => operation());
    _lastOperation = next.catchError((_) {});
    return next;
  }

  Future<void> toggleVisited(ItineraryItemEntity item, String cityId) {
    return _enqueue(() async {
      state = const AsyncLoading();
      try {
        await ref.read(itineraryRepositoryProvider).saveItineraryAction(
          userId: currentUserId,
          customerId: item.customer.id,
          cityId: cityId,
          isVisited: !item.isVisited,
          visitOrder: item.isNew ? 999 : item.visitOrder,
        );
        state = const AsyncData(null);
      } catch (e, stack) {
        debugPrint('Erro ao alternar visita: $e');
        state = AsyncError(e, stack);
        rethrow;
      }
    });
  }

  Future<void> confirmNewUser(ItineraryItemEntity item, String cityId, int newOrder) {
    return _enqueue(() async {
      state = const AsyncLoading();
      try {
        await ref.read(itineraryRepositoryProvider).saveItineraryAction(
          userId: currentUserId,
          customerId: item.customer.id,
          cityId: cityId,
          visitOrder: newOrder,
          isVisited: false,
        );
        state = const AsyncData(null);
      } catch (e, stack) {
        debugPrint('Erro ao confirmar novo usuário: $e');
        state = AsyncError(e, stack);
        rethrow;
      }
    });
  }

  Future<void> updateFullListOrder(List<ItineraryItemEntity> items, String cityId) {
    return _enqueue(() async {
      state = const AsyncLoading();
      try {
        await ref.read(itineraryRepositoryProvider).saveItineraryBatch(
          userId: currentUserId,
          cityId: cityId,
          items: items,
        );
        state = const AsyncData(null);
      } catch (e, stack) {
        debugPrint('Erro ao reordenar lista: $e');
        state = AsyncError(e, stack);
        rethrow;
      }
    });
  }

  Future<void> resetAllVisits(String cityId) {
    return _enqueue(() async {
      state = const AsyncLoading();
      try {
        await ref.read(itineraryRepositoryProvider).resetVisits(
          userId: currentUserId,
          cityId: cityId,
        );
        state = const AsyncData(null);
      } catch (e, stack) {
        debugPrint('Erro ao resetar visitas: $e');
        state = AsyncError(e, stack);
        rethrow;
      }
    });
  }
}

final itineraryNotifierProvider = NotifierProvider<ItineraryNotifier, AsyncValue<void>>(
  ItineraryNotifier.new,
);
