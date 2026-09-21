import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/forms/app_form_select_field.dart';
import '../../../../core/widgets/navigation/app_app_bar.dart';
import '../../../../core/widgets/navigation/app_navigation_bar.dart';
import '../../../customer/domain/entities/customer.dart';
import '../../../customer/presentation/pages/customer_form_page.dart';
import '../../../customer/presentation/providers/customer_form_provider.dart';
import '../../../employee/domain/entities/employee.dart';
import '../../../employee/presentation/pages/employee_form_page.dart';
import '../../../employee/presentation/providers/employee_provider.dart';
import '../../../company/domain/entities/company.dart';
import '../../../company/presentation/providers/company_provider.dart';
import 'sale_completed_page.dart';
import '../../../product/presentation/pages/product_form_page.dart';
import '../../../payment_method/domain/entities/payment_method.dart';
import '../../../payment_method/presentation/pages/payment_method_form_page.dart';
import '../../../payment_method/presentation/providers/payment_method_provider.dart';

import '../../domain/entities/sale.dart';
import '../providers/sale_provider.dart';
import '../widgets/product_search_field.dart';
import '../widgets/sale_cart.dart';
import '../widgets/sale_total_card.dart';

class SalePage extends ConsumerStatefulWidget {
  const SalePage({super.key});

  @override
  ConsumerState<SalePage> createState() => _SalePageState();
}

class _SalePageState extends ConsumerState<SalePage> {
  final _discountController = TextEditingController();
  final _installmentsController = TextEditingController(text: '1');
  SaleDraft? _pendingDraft;
  CustomerEntity? _pendingCustomer;
  EmployeeEntity? _pendingEmployee;
  CompanyEntity? _pendingCompany;

  @override
  void dispose() {
    _discountController.dispose();
    _installmentsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(completeSaleProvider, (_, next) {
      next.whenOrNull(
        data: (_) {
          if (!mounted) return;
          _discountController.clear();
          _installmentsController.text = '1';
          final draft = _pendingDraft;
          if (draft == null || !mounted) return;
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => SaleCompletedPage(
                draft: draft,
                customer: _pendingCustomer,
                employee: _pendingEmployee,
                company: _pendingCompany,
              ),
            ),
          );
        },
        error: (error, _) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Não foi possível registrar a venda: $error'),
              backgroundColor: Colors.red,
            ),
          );
        },
      );
    });

    final productsAsync = ref.watch(saleProductsStreamProvider);
    final customersAsync = ref.watch(customersStreamProvider);
    final employeesAsync = ref.watch(employeesStreamProvider);
    final companyAsync = ref.watch(companyProvider);
    final paymentMethodsAsync = ref.watch(paymentMethodsStreamProvider);

    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xFF171717),
      appBar: const AppAppBar(
        title: 'Nova Venda',
        backgroundColor: AppMenuColors.sale,
      ),
      bottomNavigationBar: AppNavigationBar(
        contextualAction: ContextualActionButton(
          label: 'Produto',
          icon: Icons.add,
          backgroundColor: AppMenuColors.products,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProductFormPage()),
          ),
        ),
      ),
      body: productsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
        error: (error, _) => _PageMessage(
          text: 'Erro ao carregar produtos: $error',
          color: Colors.redAccent,
        ),
        data: (products) => customersAsync.when(
          loading: () => _buildContent(products, const [], const [], const [], null),
          error: (_, _) => _buildContent(products, const [], const [], const [], null),
          data: (customers) => employeesAsync.when(
            loading: () => _buildContent(products, customers, const [], const [], null),
            error: (_, _) => _buildContent(products, customers, const [], const [], null),
            data: (employees) => paymentMethodsAsync.when(
              loading: () => _buildContent(products, customers, employees, const [], null),
              error: (_, _) => _buildContent(products, customers, employees, const [], null),
              data: (paymentMethods) => companyAsync.when(
                loading: () => _buildContent(products, customers, employees, paymentMethods, null),
                error: (_, _) => _buildContent(products, customers, employees, paymentMethods, null),
                data: (company) => _buildContent(products, customers, employees, paymentMethods, company),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    List<SaleProduct> products,
    List<CustomerEntity> customers,
    List<EmployeeEntity> employees,
    List<PaymentMethodEntity> paymentMethods,
    CompanyEntity? company,
  ) {
    final cart = ref.watch(saleCartProvider);
    final isLoading = ref.watch(completeSaleProvider).isLoading;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _sectionTitle('Catálogo'),
                  ProductSearchField(
                    products: products,
                    onProductSelected: (product) =>
                        ref.read(saleCartProvider.notifier).addProduct(product),
                  ),
                  const SizedBox(height: 20),
                  _sectionTitle('Carrinho'),
                  SaleCart(
                    items: cart.items,
                    onIncrement: (id) =>
                        ref.read(saleCartProvider.notifier).increment(id),
                    onDecrement: (id) =>
                        ref.read(saleCartProvider.notifier).decrement(id),
                    onRemove: (id) =>
                        ref.read(saleCartProvider.notifier).remove(id),
                  ),
                  const SizedBox(height: 20),
                  _buildCustomerSelector(customers, cart.customerId),
                  const SizedBox(height: 12),
                  _buildEmployeeSelector(employees, cart.employeeId),
                  const SizedBox(height: 12),
                  _buildPaymentSelector(paymentMethods, cart.paymentMethod),
                  const SizedBox(height: 12),
                  _buildInstallmentsField(),
                  const SizedBox(height: 12),
                  _buildDiscountField(),
                  const SizedBox(height: 20),
                  SaleTotalCard(
                    subtotalCentavos: cart.subtotalCentavos,
                    discountCentavos: cart.discountCentavos,
                    totalCentavos: cart.totalCentavos,
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: isLoading || cart.items.isEmpty ? null : () => _complete(customers, employees, company),
                    icon: isLoading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.check_circle_outline),
                    label: Text(isLoading ? 'REGISTRANDO...' : 'REGISTRAR VENDA'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppMenuColors.sale,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey[800],
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCustomerSelector(
    List<CustomerEntity> customers,
    String? selectedCustomerId,
  ) {
    final Map<String, String> customerOptions = {
      for (final customer in customers) customer.id: customer.nome,
    };

    return AppFormSelectField<String>(
      label: 'Cliente',
      value: selectedCustomerId,
      options: customerOptions,
      sheetTitle: 'Selecione o Cliente',
      primaryColor: AppMenuColors.customer,
      onChanged: (value) =>
          ref.read(saleCartProvider.notifier).setCustomerId(value),
      action: AppFormSelectAction(
        label: 'Novo Cliente',
        icon: Icons.person_add_outlined,
        backgroundColor: AppMenuColors.customer,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CustomerFormPage()),
          );
        },
      ),
    );
  }

  Widget _buildEmployeeSelector(List<EmployeeEntity> employees, String? selectedEmployeeId) {
    final activeEmployees = employees.where((employee) => employee.isAtivo).toList();
    final options = <String, String>{for (final employee in activeEmployees) employee.id: employee.nome};
    return AppFormSelectField<String>(
      label: 'Funcionário', 
      value: selectedEmployeeId, 
      options: options,
      sheetTitle: 'Selecione o Funcionário', 
      primaryColor: AppMenuColors.employees,
      onChanged: (value) => ref.read(saleCartProvider.notifier).setEmployeeId(value),
      action: AppFormSelectAction(
        label: 'Novo Funcionário', 
        icon: Icons.badge_outlined, 
        backgroundColor: AppMenuColors.employees,
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EmployeeFormPage())),
      ),
    );
  }

  Widget _buildPaymentSelector(
    List<PaymentMethodEntity> paymentMethods,
    String? selectedPaymentMethod,
  ) {
    final activeMethods = paymentMethods.where((method) => method.isAtivo).toList();
    final paymentOptions = <String, String>{
      for (final method in activeMethods) method.nome: method.nome,
    };
    final selectedValue = paymentOptions.containsKey(selectedPaymentMethod)
        ? selectedPaymentMethod
        : null;

    return AppFormSelectField<String>(
      label: 'Forma de pagamento',
      value: selectedValue,
      options: paymentOptions,
      sheetTitle: 'Selecione o Pagamento',
      primaryColor: AppMenuColors.paymentMethods,
      onChanged: (value) =>
          ref.read(saleCartProvider.notifier).setPaymentMethod(value),
      action: AppFormSelectAction(
        label: 'Nova forma de pagamento',
        icon: Icons.add_card,
        backgroundColor: AppMenuColors.paymentMethods,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PaymentMethodFormPage()),
        ),
      ),
    );
  }

  Widget _buildInstallmentsField() {
    return TextFormField(
      controller: _installmentsController,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      style: const TextStyle(color: Colors.white),
      validator: (value) {
        final parsed = int.tryParse(value?.trim() ?? '');
        return parsed == null || parsed <= 0 ? 'Informe um número de parcelas maior que zero' : null;
      },
      decoration: InputDecoration(
        labelText: 'Parcelas',
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: const Icon(Icons.payments_outlined, color: Colors.white54),
        filled: true,
        fillColor: const Color(0xFF424242),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
        errorStyle: const TextStyle(color: Colors.redAccent),
      ),
      onChanged: (value) {
        final parsed = int.tryParse(value.trim());
        if (parsed != null && parsed > 0) {
          ref.read(saleCartProvider.notifier).setInstallments(parsed);
        }
      },
    );
  }

  Widget _buildDiscountField() {
    return TextField(
      controller: _discountController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
      ],
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: 'Desconto em Reais (R\$)',
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: const Icon(Icons.discount_outlined, color: Colors.white54),
        filled: true,
        fillColor: const Color(0xFF424242),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
      onChanged: (value) {
        ref
            .read(saleCartProvider.notifier)
            .setDiscountCentavos(_parseDiscountCentavos(value));
      },
    );
  }

  int _parseDiscountCentavos(String value) {
    final raw = value.trim();
    if (raw.isEmpty) return 0;

    final normalized = raw.contains(',')
        ? raw.replaceAll('.', '').replaceAll(',', '.')
        : raw;

    final parsed = double.tryParse(normalized);
    if (parsed == null || !parsed.isFinite || parsed < 0) return 0;

    return (parsed * 100).round();
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  CustomerEntity? _findCustomer(List<CustomerEntity> items, String? id) {
    for (final item in items) { if (item.id == id) return item; }
    return null;
  }

  EmployeeEntity? _findEmployee(List<EmployeeEntity> items, String? id) {
    for (final item in items) { if (item.id == id) return item; }
    return null;
  }

  void _complete(List<CustomerEntity> customers, List<EmployeeEntity> employees, CompanyEntity? company) {
    final cart = ref.read(saleCartProvider);
    final installments = int.tryParse(_installmentsController.text.trim());
    if (installments == null || installments <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Informe a quantidade de parcelas.')));
      return;
    }
    final draft = SaleDraft(id: const Uuid().v4(), customerId: cart.customerId, employeeId: cart.employeeId, paymentMethod: cart.paymentMethod, installments: installments, discountCentavos: cart.discountCentavos, soldAt: DateTime.now().toUtc(), items: cart.items);
    _pendingDraft = draft;
    _pendingCustomer = _findCustomer(customers, draft.customerId);
    _pendingEmployee = _findEmployee(employees, draft.employeeId);
    _pendingCompany = company;
    ref.read(completeSaleProvider.notifier).complete(draft);
  }
}

class _PageMessage extends StatelessWidget {
  final String text;
  final Color color;

  const _PageMessage({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(text, style: TextStyle(color: color)));
  }
}