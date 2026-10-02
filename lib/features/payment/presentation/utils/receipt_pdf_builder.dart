import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../company/domain/entities/company.dart';
import '../../../customer/domain/entities/customer.dart';
import '../../../employee/domain/entities/employee.dart';
import '../../../sale/domain/entities/sale.dart';
import '../../../sale/domain/entities/sale_status.dart';
import '../../domain/entities/payment.dart';

class ReceiptPdfBuilder {
  const ReceiptPdfBuilder._();

  static Future<Uint8List> buildSaleReceipt({
    required SaleEntity sale,
    CompanyEntity? company,
    CustomerEntity? customer,
    EmployeeEntity? employee,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(36),
        build: (_) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'COMPROVANTE DE COMPRA',
              style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 6),
            pw.Text('Venda: ${sale.id}'),
            pw.Text('Data e hora da compra: ${_date(sale.soldAt)}'),
            pw.Divider(),
            _companySection(company),
            pw.SizedBox(height: 12),
            pw.Text('CLIENTE', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text(customer?.nome ?? 'Não informado'),
            if (customer?.cpf != null) pw.Text('CPF: ${customer!.cpf}'),
            if (customer?.celular != null) pw.Text('Celular: ${customer!.celular}'),
            pw.SizedBox(height: 12),
            pw.Text('VENDA', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text(employee?.nome ?? 'Não informado'),
            if (employee?.cpf != null) pw.Text('CPF: ${employee!.cpf}'),
            pw.SizedBox(height: 16),
            pw.Text('ITENS DA VENDA', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.TableHelper.fromTextArray(
              headers: const ['Produto', 'Qtd.', 'Unitário', 'Total'],
              data: sale.items
                  .map((item) => [
                        item.productNome,
                        '${item.quantity}',
                        _money(item.unitPriceCentavos),
                        _money(item.totalCentavos),
                      ])
                  .toList(),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              cellPadding: const pw.EdgeInsets.all(6),
            ),
            pw.SizedBox(height: 14),
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text('Subtotal: ${_money(sale.subtotalCentavos)}'),
                  pw.Text('Desconto: ${_money(sale.discountCentavos)}'),
                  pw.Text(
                    'Total da compra: ${_money(sale.totalCentavos)}',
                    style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
                  ),
                  if (sale.paymentMethod != null)
                    pw.Text('Forma de pagamento: ${sale.paymentMethod}'),
                  pw.Text('Parcelas: ${sale.installments}'),
                ],
              ),
            ),
            pw.Spacer(),
            pw.Center(child: pw.Text('Status da venda: ${_saleStatus(sale.status)}')),
            pw.SizedBox(height: 6),
            pw.Center(
              child: pw.Text(
                'Documento gerado pelo sistema de vendas',
                style: const pw.TextStyle(color: PdfColors.grey),
              ),
            ),
          ],
        ),
      ),
    );

    return pdf.save();
  }

  static Future<Uint8List> buildPaymentReceipt({
    required SaleEntity sale,
    required PaymentEntity payment,
    required int totalPaidAfterPayment,
    CompanyEntity? company,
    CustomerEntity? customer,
    EmployeeEntity? employee,
  }) async {
    final pdf = pw.Document();
    final remaining = sale.totalCentavos - totalPaidAfterPayment;

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(36),
        build: (_) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'COMPROVANTE DE PAGAMENTO',
              style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 6),
            pw.Text('Venda: ${sale.id}'),
            pw.Text('Data e hora do pagamento: ${_date(payment.paidAt)}'),
            pw.Divider(),
            _companySection(company),
            pw.SizedBox(height: 12),
            pw.Text('CLIENTE', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text(customer?.nome ?? 'Não informado'),
            if (customer?.cpf != null) pw.Text('CPF: ${customer!.cpf}'),
            if (customer?.celular != null) pw.Text('Celular: ${customer!.celular}'),
            pw.SizedBox(height: 12),
            pw.Text('COBRANÇA', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text(employee?.nome ?? 'Não informado'),
            if (employee?.cpf != null) pw.Text('CPF: ${employee!.cpf}'),
            pw.SizedBox(height: 16),
            pw.Text('ITENS DA VENDA', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.TableHelper.fromTextArray(
              headers: const ['Produto', 'Qtd.', 'Unitário', 'Total'],
              data: sale.items
                  .map((item) => [
                        item.productNome,
                        '${item.quantity}',
                        _money(item.unitPriceCentavos),
                        _money(item.totalCentavos),
                      ])
                  .toList(),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              cellPadding: const pw.EdgeInsets.all(6),
            ),
            pw.SizedBox(height: 14),
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text('Subtotal: ${_money(sale.subtotalCentavos)}'),
                  pw.Text('Desconto: ${_money(sale.discountCentavos)}'),
                  pw.Text('Total da compra: ${_money(sale.totalCentavos)}'),
                  pw.Text('Pagou agora: ${_money(payment.amountCentavos)}'),
                  pw.Text('Total pago: ${_money(totalPaidAfterPayment)}'),
                  pw.Text(
                    'Faltam: ${_money(remaining)}',
                    style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
                  ),
                  if (payment.paymentMethodName != null)
                    pw.Text('Forma de pagamento: ${payment.paymentMethodName}'),
                  if (sale.paymentMethod != null)
                    pw.Text('Forma original da venda: ${sale.paymentMethod}'),
                ],
              ),
            ),
            pw.Spacer(),
            pw.Center(child: pw.Text('Status do pagamento: ${paymentStatusLabel(payment.paymentStatus)}')),
            pw.SizedBox(height: 6),
            pw.Center(
              child: pw.Text(
                'Documento gerado pelo sistema de vendas',
                style: const pw.TextStyle(color: PdfColors.grey),
              ),
            ),
          ],
        ),
      ),
    );

    return pdf.save();
  }

  static pw.Widget _companySection(CompanyEntity? company) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('EMPRESA', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.Text(
            company?.nomeFantasia?.trim().isNotEmpty == true
                ? company!.nomeFantasia!
                : company?.razaoSocial ?? 'Não informado',
          ),
          if (company?.cnpj != null) pw.Text('CNPJ: ${company!.cnpj}'),
          if (company?.telefone != null) pw.Text('Telefone: ${company!.telefone}'),
        ],
      );

  static String _money(int cents) =>
      'R\$ ${(cents / 100).toStringAsFixed(2).replaceAll('.', ',')}';

  static String _date(DateTime date) {
    final local = date.toLocal();
    String two(int value) => value.toString().padLeft(2, '0');
    return '${two(local.day)}/${two(local.month)}/${local.year} '
        '${two(local.hour)}:${two(local.minute)}';
  }

  static String _saleStatus(String status) => status.saleStatus.label;

}
