class FinancialEntry {
  final String saleId;
  final int amountCentavos;
  final int paidCentavos;
  final int pendingCentavos;
  final DateTime soldAt;
  final String city;
  final String saleStatus;
  final String customerName;
  final String? paymentMethod;
  final int installments;
  final String itemsSummary;
  final int itemCount;

  const FinancialEntry({
    this.saleId = '',
    required this.amountCentavos,
    this.paidCentavos = 0,
    this.pendingCentavos = 0,
    required this.soldAt,
    required this.city,
    required this.saleStatus,
    this.customerName = 'Cliente Não informado',
    this.paymentMethod,
    this.installments = 1,
    this.itemsSummary = '',
    this.itemCount = 0,
  });
}

class FinancialGroup {
  final String label;
  final int amountCentavos;
  final int paidCentavos;
  final int pendingCentavos;
  final int saleCount;
  final Map<String, int> statusCounts;
  final List<FinancialEntry> sales;

  const FinancialGroup({
    required this.label,
    required this.amountCentavos,
    required this.paidCentavos,
    required this.pendingCentavos,
    required this.saleCount,
    required this.statusCounts,
    this.sales = const [],
  });
}

class FinancialReport {
  final int totalCentavos;
  final int paidCentavos;
  final int pendingCentavos;
  final List<FinancialGroup> groups;
  final int saleCount;
  final Map<String, FinancialStatusTotal> statusTotals;
  final int netTotalCentavos;

  const FinancialReport({
    required this.totalCentavos,
    required this.paidCentavos,
    required this.pendingCentavos,
    required this.groups,
    required this.saleCount,
    required this.statusTotals,
    this.netTotalCentavos = 0,
  });
}

class FinancialStatusTotal {
  final int amountCentavos;
  final int paidCentavos;
  final int pendingCentavos;
  final int saleCount;

  const FinancialStatusTotal({
    required this.amountCentavos,
    required this.paidCentavos,
    required this.pendingCentavos,
    required this.saleCount,
  });
}
