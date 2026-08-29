import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/navigation/app_app_bar.dart';
import '../../../../core/widgets/navigation/app_navigation_bar.dart';
import '../../../customer/domain/entities/customer.dart';
import '../../../customer/presentation/providers/customer_form_provider.dart';
import '../../domain/entities/sale.dart';
import '../providers/sale_provider.dart';

class SaleDetailPage extends ConsumerWidget {
  final String saleId;

  const SaleDetailPage({super.key, required this.saleId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saleAsync = ref.watch(saleByIdProvider(saleId));
    final customersAsync = ref.watch(customersStreamProvider);

    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xFF171717),
      appBar: const AppAppBar(
        title: 'Detalhe da Venda',
        backgroundColor: AppMenuColors.sale,
      ),
      bottomNavigationBar: const AppNavigationBar(),
      body: saleAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
        error: (error, _) => Center(
          child: Text(
            'Erro ao carregar a venda: $error',
            style: const TextStyle(color: Colors.redAccent),
          ),
        ),
        data: (sale) => _buildContent(
          sale,
          customersAsync.whenOrNull(data: (customers) => customers),
        ),
      ),
    );
  }

  Widget _buildContent(SaleEntity sale, List<CustomerEntity>? customers) {
    final customerName = sale.customerId == null
        ? null
        : customers
            ?.where((customer) => customer.id == sale.customerId)
            .map((customer) => customer.nome)
            .firstOrNull;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _headerCard(sale, customerName),
              const SizedBox(height: 16),
              const Text(
                'Itens da venda',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              _itemsCard(sale.items),
              const SizedBox(height: 16),
              _totalsCard(sale),
            ],
          ),
        ),
      ),
    );
  }

  Widget _headerCard(SaleEntity sale, String? customerName) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF262626),
        borderRadius: BorderRadius.circular(16),
      ),
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
                  'Venda ${_shortId(sale.id)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              _statusTag(sale.status),
            ],
          ),
          const SizedBox(height: 16),
          _metadata('Data da venda', _formatDateTime(sale.soldAt)),
          _metadata(
            'Cliente',
            customerName ??
                (sale.customerId == null
                    ? 'Não informado'
                    : 'Cliente vinculado'),
          ),
          if (sale.customerId != null && customerName == null)
            _metadata('ID do cliente', sale.customerId!),
          _metadata('Forma de pagamento', sale.paymentMethod ?? 'Não informada'),
        ],
      ),
    );
  }

  Widget _itemsCard(List<SaleItem> items) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF262626),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          for (var index = 0; index < items.length; index++) ...[
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              title: Text(
                items[index].productNome,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                '${items[index].quantity} x ${_money(items[index].unitPriceCentavos)}',
                style: TextStyle(color: Colors.grey[400]),
              ),
              trailing: Text(
                _money(items[index].totalCentavos),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            if (index != items.length - 1)
              const Divider(color: Colors.white12, height: 1),
          ],
        ],
      ),
    );
  }

  Widget _totalsCard(SaleEntity sale) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1F6F5B),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _totalLine('Subtotal', sale.subtotalCentavos),
          if (sale.discountCentavos > 0)
            _totalLine('Desconto', -sale.discountCentavos),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: Colors.white38, height: 1),
          ),
          _totalLine('TOTAL', sale.totalCentavos, emphasized: true),
        ],
      ),
    );
  }

  Widget _totalLine(String label, int centavos, {bool emphasized = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontWeight: emphasized ? FontWeight.w800 : FontWeight.normal,
            fontSize: emphasized ? 18 : 14,
          ),
        ),
        Text(
          _money(centavos),
          style: TextStyle(
            color: Colors.white,
            fontWeight: emphasized ? FontWeight.w800 : FontWeight.normal,
            fontSize: emphasized ? 22 : 14,
          ),
        ),
      ],
    );
  }

  Widget _metadata(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 145,
            child: Text(label, style: TextStyle(color: Colors.grey[500])),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _statusTag(String status) {
    final isCompleted = status == 'completed';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isCompleted ? const Color(0xFF86C5A6) : Colors.redAccent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isCompleted ? 'Concluída' : status,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }

  String _shortId(String id) => id.length <= 8 ? id : id.substring(id.length - 8);

  String _formatDateTime(DateTime value) {
    return '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year} ${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';
  }

  String _money(int centavos) {
    final signal = centavos < 0 ? '-' : '';
    return '${signal}R\$ ${(centavos.abs() / 100).toStringAsFixed(2).replaceAll('.', ',')}';
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
