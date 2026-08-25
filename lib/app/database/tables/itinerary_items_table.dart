import 'package:drift/drift.dart';

class ItineraryItems extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get customerId => text()();
  TextColumn get cityId => text()();
  IntColumn get visitOrder => integer().withDefault(const Constant(0))();
  BoolColumn get isVisited => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}