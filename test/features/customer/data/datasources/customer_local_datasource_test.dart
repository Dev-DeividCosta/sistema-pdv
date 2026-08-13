import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sistema_pdv/app/database/app_database.dart';
import 'package:sistema_pdv/features/customer/data/datasources/customer_local_datasource.dart';

void main() {
  late AppDatabase db;
  late CustomerLocalDataSource dataSource;

  // Executado antes de CADA teste: cria um banco limpo na memória RAM
  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    dataSource = CustomerLocalDataSource(db);
  });

  // Executado depois de CADA teste: fecha a conexão com o banco
  tearDown(() async {
    await db.close();
  });

  test('Deve salvar um cliente no SQLite local e retornar na listagem', () async {
    // 1. Arrange (Preparar os dados do teste)
    const clienteParaSalvar = CustomersCompanion(
      id: Value('123-abc'),
      nome: Value('Cliente Teste Ltda'),
      email: Value('teste@empresa.com'),
      celular: Value('75999999999'),
      isAtivo: Value(true),
      isDeleted: Value(false),
    );

    // 2. Act (Executar a ação principal)
    await dataSource.saveCustomer(clienteParaSalvar);

    // 3. Assert (Verificar os resultados com expect em vez de print)
    final listaDeClientes = await dataSource.getCustomers();

    // Valida se salvou exatamente 1 cliente
    expect(listaDeClientes.length, equals(1));

    // Valida os campos do cliente salvo
    final clienteSalvo = listaDeClientes.first;
    expect(clienteSalvo.id, equals('123-abc'));
    expect(clienteSalvo.nome, equals('Cliente Teste Ltda'));
    expect(clienteSalvo.email, equals('teste@empresa.com'));
    expect(clienteSalvo.isAtivo, isTrue);
  });
}