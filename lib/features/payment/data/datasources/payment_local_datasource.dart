import 'dart:async';

import 'package:drift/drift.dart';

import '../../../../app/database/app_database.dart';
import '../../domain/entities/payment.dart';
import '../../../sale/domain/entities/sale_status.dart';
import '../models/payment_model.dart';

class PaymentLocalDataSource {
  final AppDatabase _db;
  final StreamController<String> _paymentChanges =
      StreamController<String>.broadcast();

  PaymentLocalDataSource(this._db);

  Stream<List<PaymentModel>> watchPayments(String saleId) async* {
    await _db.ensurePaymentTables();
    yield await getPayments(saleId);
    yield* _paymentChanges.stream
        .where((changedSaleId) => changedSaleId == saleId)
        .asyncMap((_) => getPayments(saleId));
  }

  Future<List<PaymentModel>> getPayments(String saleId) async {
    await _db.ensurePaymentTables();
    final rows = await _db.customSelect(
      '''
      SELECT sale_payments.id, sale_payments.sale_id, sale_payments.employee_id,
             sale_payments.amount_centavos, sale_payments.payment_status,
             sale_payments.payment_method_id, sale_payments.paid_at,
             sale_payments.created_at,
             payment_methods.nome AS payment_method_name
      FROM sale_payments
      LEFT JOIN payment_methods ON payment_methods.id = sale_payments.payment_method_id
      WHERE sale_payments.sale_id = ?
      ORDER BY sale_payments.paid_at DESC, sale_payments.created_at DESC
      ''',
      variables: [Variable<String>(saleId)],
    ).get();

    return rows
        .map(
          (row) => PaymentModel(
            id: row.read<String>('id'),
            saleId: row.read<String>('sale_id'),
            employeeId: row.readNullable<String>('employee_id'),
            paymentMethodId: row.readNullable<String>('payment_method_id'),
            paymentMethodName: row.readNullable<String>('payment_method_name'),
            amountCentavos: row.read<int>('amount_centavos'),
            paymentStatus: row.read<String>('payment_status'),
            paidAt: DateTime.parse(row.read<String>('paid_at')).toLocal(),
            createdAt: DateTime.parse(row.read<String>('created_at')).toLocal(),
          ),
        )
        .toList(growable: false);
  }

  Future<PaymentModel> registerPayment(PaymentModel payment) async {
    await _db.ensurePaymentTables();

    if (payment.amountCentavos <= 0) {
      throw Exception('Informe um valor de pagamento maior que zero.');
    }

    await _db.transaction(() async {
      final saleRows = await _db.customSelect(
        'SELECT total_centavos FROM sales WHERE id = ? AND is_deleted = 0 LIMIT 1',
        variables: [Variable<String>(payment.saleId)],
      ).get();
      if (saleRows.isEmpty) throw Exception('Venda não encontrada.');

      final total = saleRows.first.read<int>('total_centavos');
      final paidRows = await _db.customSelect(
        '''
        SELECT COALESCE(SUM(amount_centavos), 0) AS paid_centavos
        FROM sale_payments
        WHERE sale_id = ? AND payment_status = ?
        ''',
        variables: [
          Variable<String>(payment.saleId),
          Variable<String>(PaymentStatus.completed),
        ],
      ).get();
      final paid = paidRows.first.read<int>('paid_centavos');
      final remaining = total - paid;
      if (payment.amountCentavos > remaining) {
        throw Exception(
          'O pagamento não pode ser superior ao saldo devedor atual '
          '(${_money(remaining)}).',
        );
      }

      await _db.customInsert(
        '''
        INSERT INTO sale_payments (
          id, sale_id, employee_id, amount_centavos, payment_status,
          payment_method_id, paid_at, created_at
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        ''',
        variables: [
          Variable<String>(payment.id),
          Variable<String>(payment.saleId),
          Variable<String>(payment.employeeId),
          Variable<int>(payment.amountCentavos),
          Variable<String>(payment.paymentStatus),
          Variable<String>(payment.paymentMethodId),
          Variable<String>(payment.paidAt.toUtc().toIso8601String()),
          Variable<String>(payment.createdAt.toUtc().toIso8601String()),
        ],
      );

      if (payment.paymentStatus == PaymentStatus.completed && paid + payment.amountCentavos >= total) {
        await _db.customStatement(
          'UPDATE sales SET status = ? WHERE id = ? AND is_deleted = 0',
          [SaleStatus.paid.value, payment.saleId],
        );
      }
    });

    _paymentChanges.add(payment.saleId);
    return payment;
  }

  String _money(int centavos) =>
      'R\$ ${(centavos / 100).toStringAsFixed(2).replaceAll('.', ',')}';

  Future<void> dispose() async => _paymentChanges.close();
}
