import '../../domain/entities/itinerary_item.dart';
import '../../domain/repositories/itinerary_repository.dart';
import '../datasources/itinerary_local_datasource.dart';

class ItineraryRepositoryImpl implements ItineraryRepository {
  final ItineraryLocalDataSource _dataSource;

  ItineraryRepositoryImpl(this._dataSource);

  @override
  Stream<List<ItineraryItemEntity>> watchItineraryForCity(
    String cityId,
    String userId,
  ) {
    return _dataSource.watchItineraryForCity(cityId, userId);
  }

  @override
  Future<void> saveItineraryAction({
    required String userId,
    required String customerId,
    required String cityId,
    bool? isVisited,
    int? visitOrder,
  }) {
    return _dataSource.upsertItineraryItem(
      userId: userId,
      customerId: customerId,
      cityId: cityId,
      isVisited: isVisited,
      visitOrder: visitOrder,
    );
  }

  @override
  Future<void> saveItineraryBatch({
    required String userId,
    required String cityId,
    required List<ItineraryItemEntity> items,
  }) {
    return _dataSource.updateListOrderBatch(
      userId: userId,
      cityId: cityId,
      items: items,
    );
  }

  @override
  Future<void> resetVisits({
    required String userId,
    required String cityId,
  }) {
    return _dataSource.resetVisits(userId: userId, cityId: cityId);
  }
}
