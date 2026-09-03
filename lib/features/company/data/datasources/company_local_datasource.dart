import 'dart:async';

import '../../../../app/database/app_database.dart';
import '../models/company_model.dart';

class CompanyLocalDataSource {
  final AppDatabase _db;
  final StreamController<void> _changes = StreamController.broadcast();
  bool _tableReady = false;

  CompanyLocalDataSource(this._db);

  Future<void> _ensureTable() async {
    if (_tableReady) return;
    await _db.ensureCompanyTable();
    _tableReady = true;
  }

  Future<CompanyModel?> getCompany() async {
    await _ensureTable();
    final rows = await _db.customSelect('''
      SELECT id, razao_social, nome_fantasia, cnpj, telefone, email,
             endereco, numero, complemento, bairro, cidade, uf, cep,
             is_ativo, created_at
      FROM company
      WHERE is_deleted = 0
      LIMIT 1
    ''').get();
    if (rows.isEmpty) return null;
    return CompanyModel.fromRow(rows.first.data);
  }

  Stream<CompanyModel?> watchCompany() async* {
    yield await getCompany();
    await for (final _ in _changes.stream) {
      yield await getCompany();
    }
  }

  Future<void> saveCompany(CompanyModel company) async {
    await _ensureTable();
    await _db.customStatement('''
      INSERT INTO company (
        id, razao_social, nome_fantasia, cnpj, telefone, email,
        endereco, numero, complemento, bairro, cidade, uf, cep,
        is_ativo, is_deleted, created_at
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 0, ?)
      ON CONFLICT(id) DO UPDATE SET
        razao_social = excluded.razao_social,
        nome_fantasia = excluded.nome_fantasia,
        cnpj = excluded.cnpj,
        telefone = excluded.telefone,
        email = excluded.email,
        endereco = excluded.endereco,
        numero = excluded.numero,
        complemento = excluded.complemento,
        bairro = excluded.bairro,
        cidade = excluded.cidade,
        uf = excluded.uf,
        cep = excluded.cep,
        is_ativo = excluded.is_ativo,
        is_deleted = 0
    ''', [
      company.id,
      company.razaoSocial,
      company.nomeFantasia,
      company.cnpj,
      company.telefone,
      company.email,
      company.endereco,
      company.numero,
      company.complemento,
      company.bairro,
      company.cidade,
      company.uf,
      company.cep,
      company.isAtivo ? 1 : 0,
      company.createdAt.toIso8601String(),
    ]);
    _changes.add(null);
  }
}
