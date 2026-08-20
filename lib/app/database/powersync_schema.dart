import 'package:powersync/powersync.dart';

const schema = Schema([
  Table('customers', [
    Column.text('nome'),
    Column.text('apelido'),
    Column.text('cpf'),
    Column.text('rua'),
    Column.text('numero'),
    Column.text('complemento'),
    Column.text('bairro'),
    Column.text('city_id'),
    Column.text('uf'),
    Column.text('cep'),
    Column.text('telefone_fixo'),
    Column.text('celular'),
    Column.text('email'),
    Column.text('observacoes'),
    Column.integer('is_ativo'),
    Column.integer('is_deleted'),
    Column.text('created_at'),
  ]),
  Table('cities', [
    Column.text('nome'),
    Column.text('estado'),
    Column.integer('is_ativo'),
    Column.integer('is_deleted'),
    Column.text('created_at'),
  ]),
]);
