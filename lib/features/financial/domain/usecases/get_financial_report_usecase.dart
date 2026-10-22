import '../entities/financial_entry.dart';
import '../entities/financial_query.dart';
import '../repositories/financial_repository.dart';

class GetFinancialReportUseCase {
  final FinancialRepository _repository;

  GetFinancialReportUseCase(this._repository);

  Future<FinancialReport> call(FinancialQuery query) async {
    final sales = await _repository.getSales(query);
    final totals = <String, ({int amount, int paid, int pending, int count, DateTime date, Map<String, int> statuses})>{};
    final statusTotals = <String, ({int amount, int paid, int pending, int count})>{
      for (final status in query.statuses) status: (amount: 0, paid: 0, pending: 0, count: 0),
    };
    final salesByDay = <String, List<FinancialEntry>>{};
    var total = 0;
    var paidTotal = 0;
    var pendingTotal = 0;

    for (final sale in sales) {
      final date = sale.soldAt;
      final key = '${_two(date.day)}/${_two(date.month)}/${date.year}';
      salesByDay.putIfAbsent(key, () => <FinancialEntry>[]).add(sale);
      final countsTowardPaymentTotals = _countsTowardPaymentTotals(sale.saleStatus);
      final current = totals[key];
      final statusCounts = Map<String, int>.from(current?.statuses ?? const {});
      statusCounts.update(sale.saleStatus, (count) => count + 1, ifAbsent: () => 1);
      totals[key] = (
        amount: (current?.amount ?? 0) + sale.amountCentavos,
        paid: (current?.paid ?? 0) + (countsTowardPaymentTotals ? sale.paidCentavos : 0),
        pending: (current?.pending ?? 0) + (countsTowardPaymentTotals ? sale.pendingCentavos : 0),
        count: (current?.count ?? 0) + 1,
        date: current?.date ?? date,
        statuses: statusCounts,
      );
      total += sale.amountCentavos;
      if (countsTowardPaymentTotals) {
        paidTotal += sale.paidCentavos;
        pendingTotal += sale.pendingCentavos;
      }
      final statusTotal = statusTotals[sale.saleStatus] ?? (amount: 0, paid: 0, pending: 0, count: 0);
      statusTotals[sale.saleStatus] = (
        amount: statusTotal.amount + sale.amountCentavos,
        paid: statusTotal.paid + (countsTowardPaymentTotals ? sale.paidCentavos : 0),
        pending: statusTotal.pending + (countsTowardPaymentTotals ? sale.pendingCentavos : 0),
        count: statusTotal.count + 1,
      );
    }

    final groups = totals.entries
        .map((entry) => FinancialGroup(
              label: entry.key,
              amountCentavos: entry.value.amount,
              paidCentavos: entry.value.paid,
              pendingCentavos: entry.value.pending,
              saleCount: entry.value.count,
              statusCounts: Map.unmodifiable(entry.value.statuses),
              sales: List.unmodifiable(salesByDay[entry.key] ?? const []),
            ))
        .toList()
      ..sort((a, b) => totals[b.label]!.date.compareTo(totals[a.label]!.date));

    return FinancialReport(
      totalCentavos: total,
      paidCentavos: paidTotal,
      pendingCentavos: pendingTotal,
      groups: List.unmodifiable(groups),
      saleCount: sales.length,
      statusTotals: Map.unmodifiable({
        for (final entry in statusTotals.entries)
          entry.key: FinancialStatusTotal(
            amountCentavos: entry.value.amount,
            paidCentavos: entry.value.paid,
            pendingCentavos: entry.value.pending,
            saleCount: entry.value.count,
          ),
      }),
    );
  }

  String _two(int value) => value.toString().padLeft(2, '0');

  bool _countsTowardPaymentTotals(String status) =>
      status == 'pending' || status == 'paid' || status == 'completed';
}
