import 'package:drift/drift.dart';

class Customers extends Table {
  TextColumn get id => text()();
  TextColumn get nome => text()();
  TextColumn get apelido => text().nullable()();
  TextColumn get cpf => text().nullable()();
  TextColumn get rua => text().nullable()();
  TextColumn get numero => text().nullable()();
  TextColumn get complemento => text().nullable()();
  TextColumn get bairro => text().nullable()();
  TextColumn get cidade => text().nullable()();
  TextColumn get uf => text().nullable()();
  TextColumn get cep => text().nullable()();
  TextColumn get telefoneFixo => text().nullable()();
  TextColumn get celular => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get observacoes => text().nullable()();
  
  // O status visível na tela pelo usuário
  BoolColumn get isAtivo => boolean().withDefault(const Constant(true))();
  
  // A flag de "soft delete" usada nos bastidores para o banco/PowerSync
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))(); 
  
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}