import '../../../customer/domain/entities/customer.dart';

class ItineraryItemEntity {
  final CustomerEntity customer;
  final String? itineraryItemId;
  final bool isVisited;
  final int visitOrder;
  final bool isNew;

  ItineraryItemEntity({
    required this.customer,
    this.itineraryItemId,
    this.isVisited = false,
    this.visitOrder = 0,
    this.isNew = false,
  });

  ItineraryItemEntity copyWith({
    CustomerEntity? customer,
    String? itineraryItemId,
    bool? isVisited,
    int? visitOrder,
    bool? isNew,
  }) {
    return ItineraryItemEntity(
      customer: customer ?? this.customer,
      itineraryItemId: itineraryItemId ?? this.itineraryItemId,
      isVisited: isVisited ?? this.isVisited,
      visitOrder: visitOrder ?? this.visitOrder,
      isNew: isNew ?? this.isNew,
    );
  }
}