import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/navigation/app_app_bar.dart';
import '../../../../core/widgets/navigation/app_navigation_bar.dart';
import '../../../customer/domain/entities/customer.dart';
import '../../../customer/presentation/providers/customer_form_provider.dart';
import '../../domain/entities/sale.dart';
import '../providers/sale_provider.dart';
import 'sale_detail_page.dart';
import 'sale_page.dart';

class SaleHistoryPage extends ConsumerStatefulWidget {
  const SaleHistoryPage({super.key});

  @override
  ConsumerState<SaleHistoryPage> createState() => _SaleHistoryPageState();
}

class _SaleHistoryPageState extends ConsumerState<SaleHistoryPage> {
  final _searchController = TextEditingController();
  String _query = '';
  String _status = 'all';
  DateTimeRange? _dateRange;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final salesAsync = ref.watch(saleHistoryStreamProvider);
    final customersAsync = ref.watch(customersStreamProvider);

    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xFF171717),
      appBar: const AppAppBar(
        title: 'Histórico de Vendas',
        backgroundColor: AppMenuColors.sale,
      ),
      bottomNavigationBar: AppNavigationBar(
        contextualAction: ContextualActionButton(
          icon: Icons.add_shopping_cart,
          label: 'Nova venda',
          backgroundColor: AppMenuColors.sale,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SalePage()),
            );
          },
        ),
      ),
      body: salesAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
        error: (error, _) => _message(
          'Erro ao carregar o histórico: $error',
          Colors.redAccent,
        ),
        data: (sales) => _buildContent(
          sales,
          customersAsync.whenOrNull(data: (customers) => customers),
        ),
      ),
    );
  }

  Widget _buildContent(List<SaleEntity> sales, List<CustomerEntity>? customers) {
    final filtered = sales.where((sale) => _matches(sale, customers)).toList(growable: false);

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
                  TextField(
                    controller: _searchController,
                    onChanged: (value) => setState(() => _query = value),
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Buscar por venda, cliente, item ou pagamento',
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      prefixIcon: const Icon(Icons.search, color: Colors.white70),
                      filled: true,
                      fillColor: const Color(0xFF262626),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _statusFilter()),
                      const SizedBox(width: 8),
                      Expanded(child: _dateFilter()),
                    ],
                  ),
                  const SizedBox(height: 18),
                  if (filtered.isEmpty)
                    _message(
                      sales.isEmpty
                          ? 'Nenhuma venda registrada.'
                          : 'Nenhuma venda corresponde aos filtros.',
                      Colors.grey,
                    )
                  else
                    for (final sale in filtered) _saleCard(sale, customers),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _statusFilter() {
    return DropdownButtonFormField<String>(
      initialValue: _status,
      onChanged: (value) => setState(() => _status = value ?? 'all'),
      dropdownColor: const Color(0xFF262626),
      style: const TextStyle(color: Colors.white),
      decoration: _filterDecoration('Status'),
      items: const [
        DropdownMenuItem(value: 'all', child: Text('Todos os status')),
        DropdownMenuItem(value: 'completed', child: Text('Concluídas')),
        DropdownMenuItem(value: 'cancelled', child: Text('Canceladas')),
      ],
    );
  }

  Widget _dateFilter() {
    return OutlinedButton.icon(
      onPressed: _chooseDateRange,
      icon: const Icon(Icons.date_range, color: Colors.white70),
      label: Text(
        _dateRange == null
            ? 'Qualquer período'
            : '${_formatDate(_dateRange!.start)} – ${_formatDate(_dateRange!.end)}',
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: Colors.white70),
      ),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(56),
        side: const BorderSide(color: Colors.white24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _saleCard(SaleEntity sale, List<CustomerEntity>? customers) {
    final customerName = sale.customerId == null
        ? null
        : customers
            ?.where((customer) => customer.id == sale.customerId)
            .map((customer) => customer.nome)
            .firstOrNull;
    final displayClient = customerName ?? 'Cliente Não informado';

    final productNames = sale.items.map((i) => i.productNome).take(2).join(', ');
    final extraCount = sale.items.length > 2 ? ' e mais ${sale.items.length - 2}' : '';
    final itemsSummary = '$productNames$extraCount';
    
    final isCompleted = sale.status == 'completed';

    return Card(
      color: const Color(0xFF262626),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isCompleted ? Colors.transparent : Colors.redAccent.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SaleDetailPage(saleId: sale.id),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: AppMenuColors.sale.withValues(alpha: 0.15),
                          child: const Icon(Icons.person, color: AppMenuColors.sale, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            displayClient,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    _money(sale.totalCentavos),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _infoChip(Icons.calendar_today, _formatDateTime(sale.soldAt)),
                  const SizedBox(width: 12),
                  _infoChip(Icons.payment, sale.paymentMethod ?? 'N/A'),
                ],
              ),
              const SizedBox(height: 8),
              _infoChip(Icons.shopping_bag_outlined, itemsSummary),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(color: Colors.white12, height: 1),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '#${_shortId(sale.id)}',
                    style: TextStyle(color: Colors.grey[500], fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isCompleted ? const Color(0xFF86C5A6).withValues(alpha: 0.15) : Colors.redAccent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      isCompleted ? 'Concluída' : 'Cancelada',
                      style: TextStyle(
                        color: isCompleted ? const Color(0xFF86C5A6) : Colors.redAccent,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoChip(IconData icon, String text) {
    return Expanded(
      flex: text.length > 15 ? 1 : 0,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey[400]),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              text,
              style: TextStyle(color: Colors.grey[300], fontSize: 13),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  bool _matches(SaleEntity sale, List<CustomerEntity>? customers) {
    if (_status != 'all' && sale.status != _status) return false;
    if (_dateRange != null) {
      final day = DateTime(sale.soldAt.year, sale.soldAt.month, sale.soldAt.day);
      final start = DateTime(
        _dateRange!.start.year,
        _dateRange!.start.month,
        _dateRange!.start.day,
      );
      final end = DateTime(
        _dateRange!.end.year,
        _dateRange!.end.month,
        _dateRange!.end.day,
        23,
        59,
        59,
        999,
      );
      if (day.isBefore(start) || day.isAfter(end)) return false;
    }
    
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) return true;

    String customerName = '';
    if (customers != null && sale.customerId != null) {
      final customer = customers.where((c) => c.id == sale.customerId).firstOrNull;
      if (customer != null) {
        customerName = customer.nome.toLowerCase();
      }
    }

    return sale.id.toLowerCase().contains(query) ||
        sale.status.toLowerCase().contains(query) ||
        (sale.paymentMethod ?? '').toLowerCase().contains(query) ||
        customerName.contains(query) ||
        sale.items.any((item) => item.productNome.toLowerCase().contains(query));
  }

  Future<void> _chooseDateRange() async {
    final selected = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: _dateRange,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(primary: AppMenuColors.sale),
        ),
        child: child!,
      ),
    );
    if (selected != null && mounted) setState(() => _dateRange = selected);
  }

  InputDecoration _filterDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: const Color(0xFF262626),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget _message(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(top: 32),
      child: Center(child: Text(text, style: TextStyle(color: color))),
    );
  }

  String _shortId(String id) => id.length <= 8 ? id : id.substring(id.length - 8);

  String _formatDate(DateTime value) {
    return '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}';
  }

  String _formatDateTime(DateTime value) {
    return '${_formatDate(value)}/${value.year} • ${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';
  }

  String _money(int centavos) {
    return 'R\$ ${(centavos / 100).toStringAsFixed(2).replaceAll('.', ',')}';
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}