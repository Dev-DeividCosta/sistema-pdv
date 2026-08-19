import 'package:drift/drift.dart';

class Cities extends Table {
  TextColumn get id => text()();
  TextColumn get nome => text()();
  TextColumn get estado => text()();

  BoolColumn get isAtivo => boolean().withDefault(const Constant(true))();

  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}