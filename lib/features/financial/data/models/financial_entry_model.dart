import '../../domain/entities/financial_entry.dart';

class FinancialEntryModel {
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

  const FinancialEntryModel({
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

  FinancialEntry toEntity() => FinancialEntry(
        saleId: saleId,
        amountCentavos: amountCentavos,
        paidCentavos: paidCentavos,
        pendingCentavos: pendingCentavos,
        soldAt: soldAt,
        city: city,
        saleStatus: saleStatus,
        customerName: customerName,
        paymentMethod: paymentMethod,
        installments: installments,
        itemsSummary: itemsSummary,
        itemCount: itemCount,
      );
}
