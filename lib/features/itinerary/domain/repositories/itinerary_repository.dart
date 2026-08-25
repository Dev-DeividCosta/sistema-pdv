import '../entities/itinerary_item.dart';

abstract class ItineraryRepository {
  Stream<List<ItineraryItemEntity>> watchItineraryForCity(
    String cityId,
    String userId,
  );

  Future<void> saveItineraryAction({
    required String userId,
    required String customerId,
    required String cityId,
    bool? isVisited,
    int? visitOrder,
  });

  Future<void> saveItineraryBatch({
    required String userId,
    required String cityId,
    required List<ItineraryItemEntity> items,
  });

  Future<void> resetVisits({
    required String userId,
    required String cityId,
  });
}
