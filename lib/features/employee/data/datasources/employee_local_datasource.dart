import 'dart:async';

import '../../../../app/database/app_database.dart';
import '../models/employee_model.dart';

class EmployeeLocalDataSource {
  final AppDatabase _db;
  final StreamController<void> _changes = StreamController.broadcast();

  bool _tableReady = false;

  EmployeeLocalDataSource(this._db);

  Future<void> _ensureTable() async {
    if (_tableReady) {
      return;
    }

    await _db.ensureEmployeesTable();
    _tableReady = true;
  }

  Future<List<EmployeeModel>> _read() async {
    await _ensureTable();

    final rows = await _db
        .customSelect(
          '''
          SELECT
            id,
            nome,
            apelido,
            cpf,
            is_ativo,
            created_at
          FROM employees
          WHERE is_deleted = 0
          ORDER BY nome COLLATE NOCASE
          ''',
        )
        .get();

    return rows
        .map((row) => EmployeeModel.fromRow(row.data))
        .toList();
  }

  Stream<List<EmployeeModel>> watchEmployees() async* {
    yield await _read();

    await for (final _ in _changes.stream) {
      yield await _read();
    }
  }

  Future<void> saveEmployee(EmployeeModel employee) async {
    await _ensureTable();

    await _db.customStatement(
      '''
      INSERT INTO employees (
        id,
        nome,
        apelido,
        cpf,
        is_ativo,
        is_deleted,
        created_at
      )
      VALUES (?, ?, ?, ?, ?, 0, ?)
      ON CONFLICT(id) DO UPDATE SET
        nome = excluded.nome,
        apelido = excluded.apelido,
        cpf = excluded.cpf,
        is_ativo = excluded.is_ativo,
        is_deleted = 0
      ''',
      [
        employee.id,
        employee.nome,
        employee.apelido,
        employee.cpf,
        employee.isAtivo ? 1 : 0,
        employee.createdAt.toIso8601String(),
      ],
    );

    _changes.add(null);
  }

  Future<void> deleteEmployee(String id) async {
    await _ensureTable();

    await _db.customStatement(
      'UPDATE employees SET is_deleted = 1 WHERE id = ?',
      [id],
    );

    _changes.add(null);
  }

  Future<void> dispose() => _changes.close();
}