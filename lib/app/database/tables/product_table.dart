import 'package:drift/drift.dart';

class Products extends Table {
  TextColumn get id => text()();
  TextColumn get codigoBarras => text().nullable()();
  TextColumn get nomeProduto => text()();
  RealColumn get precoCusto => real()();
  RealColumn get precoVenda => real()();
  IntColumn get quantidadeEstoque => integer().withDefault(const Constant(0))();
  BoolColumn get ativo => boolean().withDefault(const Constant(true))();
  TextColumn get descricao => text().nullable()();
  IntColumn get estoqueMinimo => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
