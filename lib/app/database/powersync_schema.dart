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
  // Não há autenticação nem backend de sync neste estágio. O roteiro é local.
  // O nome interno separado permite adicionar a tabela sincronizada no futuro
  // sem colisão com esta fonte local.
  Table.localOnly(
    'local_itinerary_items',
    [
      Column.text('user_id'),
      Column.text('customer_id'),
      Column.text('city_id'),
      Column.integer('visit_order'),
      Column.integer('is_visited'),
      Column.text('created_at'),
    ],
    viewName: 'itinerary_items',
  ),
]);
