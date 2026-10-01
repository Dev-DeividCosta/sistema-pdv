import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/forms/app_form_select_field.dart';
import '../../../../core/widgets/navigation/app_app_bar.dart';
import '../../../../core/widgets/navigation/app_navigation_bar.dart';
import '../../../company/domain/entities/company.dart';
import '../../../company/presentation/providers/company_provider.dart';
import '../../../customer/domain/entities/customer.dart';
import '../../../customer/presentation/providers/customer_form_provider.dart';
import '../../../employee/domain/entities/employee.dart';
import '../../../employee/presentation/pages/employee_form_page.dart';
import '../../../employee/presentation/providers/employee_provider.dart';
import '../../../payment_method/domain/entities/payment_method.dart';
import '../../../payment_method/presentation/pages/payment_method_form_page.dart';
import '../../../payment_method/presentation/providers/payment_method_provider.dart';
import '../../../sale/domain/entities/sale.dart';
import '../../../sale/presentation/providers/sale_provider.dart';
import '../../domain/entities/payment.dart';
import '../providers/payment_provider.dart';
import 'payment_receipt_page.dart';

class PaymentPage extends ConsumerStatefulWidget {
  final String saleId;

  const PaymentPage({super.key, required this.saleId});

  @override
  ConsumerState<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends ConsumerState<PaymentPage> {
  final _amountController = TextEditingController();
  String? _employeeId;
  String? _paymentMethodId;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final saleAsync = ref.watch(saleByIdProvider(widget.saleId));
    final employeesAsync = ref.watch(employeesStreamProvider);
    final customersAsync = ref.watch(customersStreamProvider);
    final companyAsync = ref.watch(companyProvider);
    final paymentMethodsAsync = ref.watch(paymentMethodsStreamProvider);

    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xFF171717),
      appBar: const AppAppBar(
        title: 'Novo Pagamento',
        backgroundColor: AppMenuColors.sale,
      ),
      bottomNavigationBar: const AppNavigationBar(),
      body: saleAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: Colors.white)),
        error: (error, _) => _message('Erro ao carregar a venda: $error', Colors.redAccent),
        data: (sale) => employeesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator(color: Colors.white)),
          error: (error, _) => _message('Erro ao carregar funcionários: $error', Colors.redAccent),
          data: (employees) => _buildContent(
            sale,
            employees,
            paymentMethodsAsync.whenOrNull(data: (methods) => methods) ?? const [],
            customersAsync.whenOrNull(data: (customers) => _customerOf(sale, customers)),
            companyAsync.whenOrNull(data: (company) => company),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    SaleEntity sale,
    List<EmployeeEntity> employees,
    List<PaymentMethodEntity> paymentMethods,
    CustomerEntity? customer,
    CompanyEntity? company,
  ) {
    final paymentsAsync = ref.watch(salePaymentsStreamProvider(sale.id));
    final payments = paymentsAsync.valueOrNull ?? const <PaymentEntity>[];
    final totalPaid = payments
        .where((payment) => payment.isCompleted)
        .fold<int>(0, (sum, payment) => sum + payment.amountCentavos);
    final remaining = sale.totalCentavos - totalPaid;
    final isSaving = ref.watch(registerPaymentProvider).isLoading;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _balanceCard(sale.totalCentavos, totalPaid, remaining),
              const SizedBox(height: 20),
              _buildAmountField(),
              const SizedBox(height: 12),
              _buildPaymentMethodSelector(paymentMethods),
              const SizedBox(height: 12),
              _buildEmployeeSelector(employees),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: isSaving || remaining <= 0
                    ? null
                    : () => _register(
                          sale,
                          remaining,
                          customer,
                          company,
                          employees,
                          paymentMethods,
                        ),
                icon: isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.check_circle_outline),
                label: Text(isSaving ? 'REGISTRANDO...' : 'EFETUAR PAGAMENTO'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppMenuColors.sale,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey[800],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              if (remaining <= 0)
                const Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: Text(
                    'Esta venda já está totalmente paga.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF86C5A6)),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAmountField() {
    return TextFormField(
      controller: _amountController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
      ],
      style: const TextStyle(color: Colors.white),
      validator: (value) {
        final amount = _parseAmount(value ?? '');
        return amount <= 0 ? 'Informe um valor maior que zero' : null;
      },
      decoration: InputDecoration(
        labelText: 'Valor deste pagamento (R\$)',
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: const Icon(Icons.payments_outlined, color: Colors.white54),
        filled: true,
        fillColor: const Color(0xFF424242),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        errorStyle: const TextStyle(color: Colors.redAccent),
      ),
    );
  }

  Widget _buildPaymentMethodSelector(List<PaymentMethodEntity> paymentMethods) {
    final activeMethods = paymentMethods.where((method) => method.isAtivo).toList();
    final options = <String, String>{
      for (final method in activeMethods) method.id: method.nome,
    };

    return AppFormSelectField<String>(
      label: 'Tipo do pagamento',
      value: _paymentMethodId,
      options: options,
      sheetTitle: 'Selecione a Forma de Pagamento',
      primaryColor: AppMenuColors.sale,
      validator: (value) => value == null ? 'Selecione o tipo do pagamento' : null,
      onChanged: (value) => setState(() => _paymentMethodId = value),
      action: AppFormSelectAction(
        label: 'Nova Forma de Pagamento',
        icon: Icons.account_balance_wallet_outlined,
        backgroundColor: AppMenuColors.sale,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PaymentMethodFormPage()),
        ),
      ),
    );
  }

  Widget _buildEmployeeSelector(List<EmployeeEntity> employees) {
    final activeEmployees = employees.where((employee) => employee.isAtivo).toList();
    final options = <String, String>{
      for (final employee in activeEmployees) employee.id: employee.nome,
    };

    return AppFormSelectField<String>(
      label: 'Quem cobrou',
      value: _employeeId,
      options: options,
      sheetTitle: 'Selecione o Funcionário',
      primaryColor: AppMenuColors.employees,
      validator: (value) => value == null ? 'Selecione quem realizou a cobrança' : null,
      onChanged: (value) => setState(() => _employeeId = value),
      action: AppFormSelectAction(
        label: 'Novo Funcionário',
        icon: Icons.badge_outlined,
        backgroundColor: AppMenuColors.employees,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const EmployeeFormPage()),
        ),
      ),
    );
  }

  Widget _balanceCard(int total, int paid, int remaining) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF262626),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppMenuColors.sale.withValues(alpha: 0.45)),
      ),
      child: Column(
        children: [
          _line('Valor total da venda', total),
          _line('Total já pago', paid),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(color: Colors.white12),
          ),
          _line('Saldo devedor', remaining, emphasized: true),
        ],
      ),
    );
  }

  Widget _line(String label, int value, {bool emphasized = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[300], fontSize: emphasized ? 16 : 14)),
          Text(
            _money(value),
            style: TextStyle(
              color: emphasized ? Colors.white : Colors.white70,
              fontSize: emphasized ? 20 : 15,
              fontWeight: emphasized ? FontWeight.w900 : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _register(
    SaleEntity sale,
    int remaining,
    CustomerEntity? customer,
    CompanyEntity? company,
    List<EmployeeEntity> employees,
    List<PaymentMethodEntity> paymentMethods,
  ) async {
    final amount = _parseAmount(_amountController.text);
    if (amount <= 0) {
      _showError('Informe um valor de pagamento maior que zero.');
      return;
    }
    if (amount > remaining) {
      _showError('O pagamento não pode ser superior ao saldo devedor atual.');
      return;
    }
    if (_employeeId == null) {
      _showError('Selecione quem realizou a cobrança.');
      return;
    }
    if (_paymentMethodId == null) {
      _showError('Selecione o tipo do pagamento.');
      return;
    }

    final payment = PaymentEntity.create(
      saleId: sale.id,
      amountCentavos: amount,
      employeeId: _employeeId,
      paymentMethodId: _paymentMethodId,
      paymentMethodName: paymentMethods
          .where((method) => method.id == _paymentMethodId)
          .firstOrNull
          ?.nome,
    );
    final saved = await ref.read(registerPaymentProvider.notifier).register(payment);
    if (!mounted) return;
    if (saved == null) {
      _showError(ref.read(registerPaymentProvider).error?.toString() ?? 'Não foi possível registrar o pagamento.');
      return;
    }

    final employee = employees.where((item) => item.id == _employeeId).firstOrNull;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentReceiptPage(
          sale: sale,
          payment: saved,
          customer: customer,
          employee: employee,
          company: company,
          totalPaidAfterPayment: remaining == amount ? sale.totalCentavos : sale.totalCentavos - remaining + amount,
        ),
      ),
    );
  }

  CustomerEntity? _customerOf(SaleEntity sale, List<CustomerEntity> customers) {
    for (final customer in customers) {
      if (customer.id == sale.customerId) return customer;
    }
    return null;
  }

  int _parseAmount(String value) {
    final raw = value.trim();
    if (raw.isEmpty) return 0;
    final normalized = raw.contains(',')
        ? raw.replaceAll('.', '').replaceAll(',', '.')
        : raw;
    final parsed = double.tryParse(normalized);
    return parsed == null || !parsed.isFinite || parsed <= 0 ? 0 : (parsed * 100).round();
  }

  Widget _message(String text, Color color) => Center(child: Text(text, style: TextStyle(color: color)));

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
  }

  String _money(int cents) => 'R\$ ${(cents / 100).toStringAsFixed(2).replaceAll('.', ',')}';
}

extension _PaymentFirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
