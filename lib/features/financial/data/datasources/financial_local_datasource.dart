import 'package:drift/drift.dart';

import '../../../../app/database/app_database.dart';
import '../models/financial_city_model.dart';
import '../models/financial_employee_model.dart';
import '../models/financial_entry_model.dart';
import '../../domain/entities/financial_query.dart';

class FinancialLocalDataSource {
  final AppDatabase _db;

  FinancialLocalDataSource(this._db);

  Future<List<FinancialCityModel>> getCities() async {
    final rows = await _db.customSelect('''
      SELECT id, nome, estado
      FROM cities
      WHERE is_deleted = 0
      ORDER BY nome COLLATE NOCASE, estado COLLATE NOCASE
    ''').get();

    return rows
        .map((row) => FinancialCityModel(
              id: row.read<String>('id'),
              name: row.read<String>('nome'),
              state: row.read<String>('estado'),
            ))
        .toList(growable: false);
  }

  Future<List<FinancialEmployeeModel>> getEmployees() async {
    await _db.ensureEmployeesTable();
    final rows = await _db.customSelect('''
      SELECT id, nome
      FROM employees
      WHERE is_deleted = 0 AND is_ativo = 1
      ORDER BY nome COLLATE NOCASE
    ''').get();

    return rows
        .map((row) => FinancialEmployeeModel(
              id: row.read<String>('id'),
              name: row.read<String>('nome'),
            ))
        .toList(growable: false);
  }

  Future<List<FinancialEntryModel>> getSales(FinancialQuery query) async {
    await _db.ensureSalesTables();
    if (query.statuses.isEmpty) return const [];

    final start = query.startDate.toLocal();
    final endExclusive = DateTime(
      query.endDate.year,
      query.endDate.month,
      query.endDate.day + 1,
    );
    final statusPlaceholders = List.filled(query.statuses.length, '?').join(', ');
    final cityClause = query.cityId == null ? '' : 'AND c.city_id = ?';
    final employeeClause = query.employeeId == null ? '' : 'AND s.employee_id = ?';

    final variables = <Variable>[
      Variable<String>(start.toUtc().toIso8601String()),
      Variable<String>(endExclusive.toUtc().toIso8601String()),
      ...query.statuses.map(Variable<String>.new),
      if (query.cityId != null) Variable<String>(query.cityId!),
      if (query.employeeId != null) Variable<String>(query.employeeId!),
    ];

    final rows = await _db.customSelect('''
      SELECT s.id, s.total_centavos,
             COALESCE((
               SELECT SUM(p.amount_centavos)
               FROM sale_payments p
               WHERE p.sale_id = s.id
                 AND p.payment_status = 'pagamento_concluido'
             ), 0) AS paid_centavos,
             s.sold_at, s.status,
             s.payment_method, s.installments,
             COALESCE(NULLIF(TRIM(c.nome), ''), 'Cliente Não informado') AS customer_name,
             COALESCE((
               SELECT group_concat(item.product_nome, ', ')
               FROM (
                 SELECT product_nome
                 FROM sale_items
                 WHERE sale_id = s.id
                 ORDER BY rowid
               LIMIT 2
             ) AS item
             ), '') AS items_summary,
             (SELECT COUNT(*) FROM sale_items WHERE sale_id = s.id) AS items_count,
             COALESCE(NULLIF(TRIM(ci.nome), ''), 'Cidade não informada') AS city
      FROM sales s
      LEFT JOIN customers c ON c.id = s.customer_id
      LEFT JOIN cities ci ON ci.id = c.city_id AND ci.is_deleted = 0
      WHERE s.is_deleted = 0
        AND s.sold_at >= ?
        AND s.sold_at < ?
        AND s.status IN ($statusPlaceholders)
        $cityClause
        $employeeClause
      ORDER BY s.sold_at DESC, s.created_at DESC
    ''', variables: variables).get();

    return rows
        .map((row) {
          final total = row.read<int>('total_centavos');
          final paid = row.read<int>('paid_centavos');
          return FinancialEntryModel(
              saleId: row.read<String>('id'),
              amountCentavos: total,
              paidCentavos: paid,
              pendingCentavos: (total - paid).clamp(0, total).toInt(),
              soldAt: DateTime.parse(row.read<String>('sold_at')).toLocal(),
              city: row.read<String>('city'),
              saleStatus: row.read<String>('status'),
              customerName: row.read<String>('customer_name'),
              paymentMethod: row.readNullable<String>('payment_method'),
              installments: row.read<int>('installments'),
              itemsSummary: row.read<String>('items_summary'),
              itemCount: row.read<int>('items_count'),
            );
        })
        .toList(growable: false);
  }
}
