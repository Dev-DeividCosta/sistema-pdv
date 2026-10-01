import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/navigation/app_app_bar.dart';
import '../../../../core/widgets/navigation/app_navigation_bar.dart';
import '../../../company/domain/entities/company.dart';
import '../../../company/presentation/providers/company_provider.dart';
import '../../../customer/domain/entities/customer.dart';
import '../../../customer/presentation/providers/customer_form_provider.dart';
import '../../../employee/domain/entities/employee.dart';
import '../../../employee/presentation/providers/employee_provider.dart';
import '../../../payment/domain/entities/payment.dart';
import '../../../payment/presentation/pages/payment_page.dart';
import '../../../payment/presentation/providers/payment_provider.dart';
import '../../../payment/presentation/utils/receipt_pdf_builder.dart';
import '../../domain/entities/sale.dart';
import '../providers/sale_provider.dart';

class SaleDetailPage extends ConsumerWidget {
  final String saleId;

  const SaleDetailPage({super.key, required this.saleId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saleAsync = ref.watch(saleByIdProvider(saleId));
    final customersAsync = ref.watch(customersStreamProvider);
    final companyAsync = ref.watch(companyProvider);

    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xFF171717),
      appBar: const AppAppBar(
        title: 'Detalhe da Venda',
        backgroundColor: AppMenuColors.sale,
      ),
      bottomNavigationBar: const AppNavigationBar(),
      body: saleAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: Colors.white)),
        error: (error, _) => Center(
          child: Text('Erro ao carregar a venda: $error', style: const TextStyle(color: Colors.redAccent)),
        ),
        data: (sale) => _buildContent(
          context,
          ref,
          sale,
          customersAsync.whenOrNull(data: (customers) => customers),
          companyAsync.whenOrNull(data: (company) => company),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    SaleEntity sale,
    List<CustomerEntity>? customers,
    CompanyEntity? company,
  ) {
    final customer = sale.customerId == null
        ? null
        : customers?.where((item) => item.id == sale.customerId).firstOrNull;
    final customerName = customer?.nome;
    final paymentsAsync = ref.watch(salePaymentsStreamProvider(sale.id));
    final payments = paymentsAsync.whenOrNull(data: (payments) => payments) ?? const [];
    final employeesAsync = ref.watch(employeesStreamProvider);
    final employees = employeesAsync.whenOrNull(data: (items) => items) ?? const [];
    final employeeName = sale.employeeId == null
        ? null
        : employees
            .where((employee) => employee.id == sale.employeeId)
            .map((employee) => employee.nome)
            .firstOrNull;
    final employee = sale.employeeId == null
        ? null
        : employees.where((item) => item.id == sale.employeeId).firstOrNull;

    final paid = payments.where((payment) => payment.isCompleted).fold<int>(0, (sum, payment) => sum + payment.amountCentavos);
    final remaining = sale.totalCentavos - paid;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _headerCard(context, sale, customer, employee, company, customerName, employeeName),
              const SizedBox(height: 16),
              const Text(
                'Itens da venda',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              _itemsCard(sale.items),
              const SizedBox(height: 16),
              _remainingCard(remaining),
              const SizedBox(height: 20),
              _paymentsSection(
                context,
                sale,
                payments,
                employees,
                remaining,
                customer,
                company,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _headerCard(
    BuildContext context,
    SaleEntity sale,
    CustomerEntity? customer,
    EmployeeEntity? employee,
    CompanyEntity? company,
    String? customerName,
    String? employeeName,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: const Color(0xFF262626), borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                backgroundColor: AppMenuColors.sale,
                child: Icon(Icons.receipt_long, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Código da venda: ${_shortId(sale.id)}',
                  style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w700),
                ),
              ),
              _statusTag(sale.status),
              IconButton(
                tooltip: 'Compartilhar comprovante da compra',
                onPressed: () => _shareSale(context, sale, customer, employee, company),
                icon: const Icon(Icons.share_outlined, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _metadata('Data da venda', _formatDateTime(sale.soldAt)),
          _metadata('Cliente', customerName ?? (sale.customerId == null ? 'Não informado' : 'Cliente vinculado')),
          if (sale.customerId != null && customerName == null)
            _metadata('ID do cliente', sale.customerId!),
          _metadata('Vendedor', employeeName ?? (sale.employeeId == null ? 'Não informado' : 'Vendedor vinculado')),
          _metadata('Parcelas', _getInstallmentsText(sale.totalCentavos, sale.installments)),
          const SizedBox(height: 8),
          const Divider(color: Colors.white12, height: 1),
          const SizedBox(height: 8),
          _metadata('Subtotal', _money(sale.subtotalCentavos)),
          _metadata('Desconto', sale.discountCentavos > 0 ? _money(sale.discountCentavos) : 'Nenhum'),
          _metadata('Total', _money(sale.totalCentavos)),
        ],
      ),
    );
  }

  Widget _itemsCard(List<SaleItem> items) {
    return Container(
      decoration: BoxDecoration(color: const Color(0xFF262626), borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          for (var index = 0; index < items.length; index++) ...[
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              title: Text(items[index].productNome, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
              subtitle: Text('${items[index].quantity} x ${_money(items[index].unitPriceCentavos)}', style: TextStyle(color: Colors.grey[400])),
              trailing: Text(_money(items[index].totalCentavos), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            if (index != items.length - 1) const Divider(color: Colors.white12, height: 1),
          ],
        ],
      ),
    );
  }

  Widget _remainingCard(int remaining) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: const Color(0xFF1F6F5B), borderRadius: BorderRadius.circular(16)),
      child: _totalLine('FALTA PAGAR', remaining > 0 ? remaining : 0, emphasized: true),
    );
  }

  Widget _paymentsSection(
    BuildContext context,
    SaleEntity sale,
    List<PaymentEntity> payments,
    List<EmployeeEntity> employees,
    int remaining,
    CustomerEntity? customer,
    CompanyEntity? company,
  ) {
    final remainingAfter = <String, int>{};
    var running = sale.totalCentavos;
    for (final payment in payments.reversed) {
      if (payment.isCompleted) running -= payment.amountCentavos;
      remainingAfter[payment.id] = running;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilledButton.icon(
          onPressed: remaining > 0
              ? () => Navigator.push(context, MaterialPageRoute(builder: (_) => PaymentPage(saleId: sale.id)))
              : null,
          icon: const Icon(Icons.add_card),
          label: Text(remaining > 0 ? 'EFETUAR PAGAMENTO' : 'VENDA QUITADA'),
          style: FilledButton.styleFrom(backgroundColor: AppMenuColors.sale, disabledBackgroundColor: Colors.grey[800]),
        ),
        const SizedBox(height: 24),
        const Text('Histórico de pagamentos', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        if (payments.isEmpty)
          _paymentMessage('Nenhum pagamento registrado.')
        else
          Container(
            decoration: BoxDecoration(color: const Color(0xFF262626), borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                for (var index = 0; index < payments.length; index++) ...[
                  _paymentTile(
                    context,
                    sale,
                    payments[index],
                    employees,
                    remainingAfter[payments[index].id] ?? remaining,
                    customer,
                    company,
                  ),
                  if (index != payments.length - 1) const Divider(color: Colors.white12, height: 1),
                ],
              ],
            ),
          ),
      ],
    );
  }

  Widget _paymentTile(
    BuildContext context,
    SaleEntity sale,
    PaymentEntity payment,
    List<EmployeeEntity> employees,
    int remainingAfter,
    CustomerEntity? customer,
    CompanyEntity? company,
  ) {
    final employee = payment.employeeId == null
        ? null
        : employees.where((item) => item.id == payment.employeeId).firstOrNull;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      leading: CircleAvatar(
        backgroundColor: AppMenuColors.sale.withValues(alpha: 0.18),
        child: const Icon(Icons.payments_outlined, color: AppMenuColors.sale),
      ),
      title: Text(_money(payment.amountCentavos), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      subtitle: Text(
        '${_formatDateTime(payment.paidAt)}\nForma: ${payment.paymentMethodName ?? 'Não informada'}\nCobrado por: ${employee?.nome ?? 'Não informado'}\nSaldo devedor após registro: ${_money(remainingAfter)}',
        style: TextStyle(color: Colors.grey[400], height: 1.35),
      ),
      isThreeLine: true,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _paymentStatusTag(payment.paymentStatus),
          IconButton(
            tooltip: 'Compartilhar comprovante do pagamento',
            onPressed: () => _sharePayment(
              context,
              sale,
              payment,
              employee,
              customer,
              company,
              sale.totalCentavos - remainingAfter,
            ),
            icon: const Icon(Icons.share_outlined, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Future<void> _shareSale(
    BuildContext context,
    SaleEntity sale,
    CustomerEntity? customer,
    EmployeeEntity? employee,
    CompanyEntity? company,
  ) async {
    try {
      final bytes = await ReceiptPdfBuilder.buildSaleReceipt(
        sale: sale,
        customer: customer,
        employee: employee,
        company: company,
      );
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/Comprovante_de_compra_${sale.id}.pdf');
      await file.writeAsBytes(bytes, flush: true);
      await Share.shareXFiles(
        [XFile(file.path, mimeType: 'application/pdf')],
        text: 'Comprovante de compra — venda ${sale.id}',
      );
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Não foi possível compartilhar o comprovante: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _sharePayment(
    BuildContext context,
    SaleEntity sale,
    PaymentEntity payment,
    EmployeeEntity? employee,
    CustomerEntity? customer,
    CompanyEntity? company,
    int totalPaidAfterPayment,
  ) async {
    try {
      final bytes = await ReceiptPdfBuilder.buildPaymentReceipt(
        sale: sale,
        payment: payment,
        employee: employee,
        customer: customer,
        company: company,
        totalPaidAfterPayment: totalPaidAfterPayment,
      );
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/Comprovante_de_pagamento_${payment.id}.pdf');
      await file.writeAsBytes(bytes, flush: true);
      await Share.shareXFiles(
        [XFile(file.path, mimeType: 'application/pdf')],
        text: 'Comprovante de pagamento — venda ${sale.id}',
      );
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Não foi possível compartilhar o comprovante: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _paymentStatusTag(String status) {
    final isCompleted = status == PaymentStatus.completed;
    final color = isCompleted ? const Color(0xFF86C5A6) : Colors.orangeAccent;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
      child: Text(paymentStatusLabel(status), style: TextStyle(color: color, fontSize: 11)),
    );
  }

  Widget _paymentMessage(String text) => Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(color: const Color(0xFF262626), borderRadius: BorderRadius.circular(16)),
        child: Text(text, style: TextStyle(color: Colors.grey[400])),
      );

  Widget _totalLine(String label, int centavos, {bool emphasized = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.white, fontWeight: emphasized ? FontWeight.w800 : FontWeight.normal, fontSize: emphasized ? 18 : 14)),
        Text(_money(centavos), style: TextStyle(color: Colors.white, fontWeight: emphasized ? FontWeight.w800 : FontWeight.normal, fontSize: emphasized ? 22 : 14)),
      ],
    );
  }

  Widget _metadata(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 145, child: Text(label, style: TextStyle(color: Colors.grey[500]))),
          Expanded(child: Text(value, style: const TextStyle(color: Colors.white))),
        ],
      ),
    );
  }

  Widget _statusTag(String status) {
    final isCompleted = status == 'completed';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: isCompleted ? const Color(0xFF86C5A6) : Colors.redAccent, borderRadius: BorderRadius.circular(20)),
      child: Text(isCompleted ? 'Concluída' : status, style: const TextStyle(color: Colors.white, fontSize: 12)),
    );
  }

  String _getInstallmentsText(int totalCentavos, int installments) {
    if (installments <= 0) return '-';
    if (installments == 1) return '1 de ${_money(totalCentavos)}';

    final baseValue = totalCentavos ~/ installments;
    final remainder = totalCentavos % installments;

    if (remainder == 0) {
      return '$installments de ${_money(baseValue)}';
    }

    final lastValue = baseValue + remainder;
    return '$installments de ${_money(baseValue)}, sendo 1 de ${_money(lastValue)}';
  }

  String _shortId(String id) => id.length <= 8 ? id : id.substring(id.length - 8);

  String _formatDateTime(DateTime value) => '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year} às ${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';

  String _money(int centavos) {
    final signal = centavos < 0 ? '-' : '';
    return '${signal}R\$ ${(centavos.abs() / 100).toStringAsFixed(2).replaceAll('.', ',')}';
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
