import 'package:drift/drift.dart';
import '../../../../app/database/app_database.dart';
import '../../../customer/data/models/customer_model.dart';
import '../../domain/entities/itinerary_item.dart';

class ItineraryLocalDataSource {
  final AppDatabase db;

  ItineraryLocalDataSource(this.db);

  Stream<List<ItineraryItemEntity>> watchItineraryForCity(
    String cityId,
    String userId,
  ) {
    final query = db.select(db.customers).join([
      leftOuterJoin(
        db.itineraryItems,
        db.itineraryItems.customerId.equalsExp(db.customers.id) &
            db.itineraryItems.userId.equals(userId) &
            db.itineraryItems.cityId.equals(cityId),
      ),
    ])..where(db.customers.cityId.equals(cityId));

    return query.watch().map((rows) {
      final items = rows.map((row) {
        final customerDb = row.readTable(db.customers);
        final itineraryDb = row.readTableOrNull(db.itineraryItems);

        return ItineraryItemEntity(
          customer: customerDb.toEntity(),
          itineraryItemId: itineraryDb?.id,
          isVisited: itineraryDb?.isVisited ?? false,
          visitOrder: itineraryDb?.visitOrder ?? 0,
          isNew: itineraryDb == null,
        );
      }).toList();

      // Itens já confirmados vêm primeiro. Dentro de cada grupo, a posição
      // salva no banco é a fonte única da ordenação visual.
      items.sort((a, b) {
        if (a.isNew && !b.isNew) return 1;
        if (!a.isNew && b.isNew) return -1;
        return a.visitOrder.compareTo(b.visitOrder);
      });

      return items;
    });
  }

  Future<void> upsertItineraryItem({
    required String userId,
    required String customerId,
    required String cityId,
    bool? isVisited,
    int? visitOrder,
  }) async {
    // Enquanto não há login, userId é um identificador local fixo. Mesmo
    // assim ele faz parte da chave lógica para permitir migração posterior.
    final existingList = await (db.select(db.itineraryItems)
          ..where(
            (t) =>
                t.userId.equals(userId) &
                t.customerId.equals(customerId) &
                t.cityId.equals(cityId),
          ))
        .get();

    final existing = existingList.firstOrNull;

    // Remove apenas duplicidades da mesma chave lógica; nunca toca outra cidade.
    for (var i = 1; i < existingList.length; i++) {
      await (db.delete(db.itineraryItems)
            ..where((t) => t.id.equals(existingList[i].id)))
          .go();
    }

    if (existing != null) {
      await (db.update(db.itineraryItems)..where((t) => t.id.equals(existing.id))).write(
        ItineraryItemsCompanion(
          isVisited: isVisited == null ? const Value.absent() : Value(isVisited),
          visitOrder: visitOrder == null ? const Value.absent() : Value(visitOrder),
        ),
      );
      return;
    }

    final newId = 'iti_${userId}_${customerId}_$cityId';
    await db.into(db.itineraryItems).insert(
      ItineraryItemsCompanion.insert(
        id: newId,
        userId: userId,
        customerId: customerId,
        cityId: cityId,
        isVisited: Value(isVisited ?? false),
        visitOrder: Value(visitOrder ?? 0),
        createdAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> updateListOrderBatch({
    required String userId,
    required String cityId,
    required List<ItineraryItemEntity> items,
  }) async {
    await db.transaction(() async {
      for (var i = 0; i < items.length; i++) {
        await upsertItineraryItem(
          userId: userId,
          customerId: items[i].customer.id,
          cityId: cityId,
          visitOrder: i,
          isVisited: items[i].isVisited,
        );
      }
    });
  }

  Future<void> resetVisits({
    required String userId,
    required String cityId,
  }) async {
    await (db.update(db.itineraryItems)
          ..where(
            (t) => t.userId.equals(userId) & t.cityId.equals(cityId),
          ))
        .write(const ItineraryItemsCompanion(isVisited: Value(false)));
  }
}
