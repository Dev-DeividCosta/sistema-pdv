import 'package:drift/drift.dart';

import '../../../../app/database/app_database.dart';
import '../models/payment_method_model.dart';

class PaymentMethodLocalDataSource {
  final AppDatabase _db;

  PaymentMethodLocalDataSource(this._db);

  Stream<List<PaymentMethodModel>> watchPaymentMethods() {
    return _db
        .customSelect(
          '''
          SELECT id, nome, is_ativo, created_at
          FROM payment_methods
          WHERE is_deleted = 0
          ORDER BY lower(nome)
          ''',
        )
        .watch()
        .map(
          (rows) => rows
              .map(
                (row) => PaymentMethodModel(
                  id: row.read<String>('id'),
                  nome: row.read<String>('nome'),
                  isAtivo: row.read<int>('is_ativo') == 1,
                  createdAt: DateTime.parse(
                    row.read<String>('created_at'),
                  ).toLocal(),
                ),
              )
              .toList(growable: false),
        );
  }

  Future<void> savePaymentMethod(
    PaymentMethodModel paymentMethod,
  ) async {
    await _db.customInsert(
      '''
      INSERT OR REPLACE INTO payment_methods
        (id, nome, is_ativo, is_deleted, created_at)
      VALUES (?, ?, ?, 0, ?)
      ''',
      variables: [
        Variable<String>(paymentMethod.id),
        Variable<String>(paymentMethod.nome),
        Variable<int>(paymentMethod.isAtivo ? 1 : 0),
        Variable<String>(
          paymentMethod.createdAt.toUtc().toIso8601String(),
        ),
      ],
    );
  }

  Future<void> deletePaymentMethod(String id) async {
    await _db.customUpdate(
      'UPDATE payment_methods SET is_deleted = 1 WHERE id = ?',
      variables: [Variable<String>(id)],
    );
  }
}
