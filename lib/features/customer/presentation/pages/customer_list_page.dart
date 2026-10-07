import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/cards/app_customer_card.dart';
import '../../../../core/widgets/forms/form_mode.dart';
import '../../../../core/widgets/list/app_grouped_list_page.dart';
import '../../../../core/widgets/status_tag.dart';
import '../../../city/domain/entities/city.dart';
import '../../../city/presentation/providers/city_form_provider.dart';
import '../../domain/entities/customer.dart';
import '../providers/customer_form_provider.dart';
import 'customer_form_page.dart';
import 'customer_hub_page.dart';

class CustomerListPage extends ConsumerStatefulWidget {
  const CustomerListPage({super.key});

  @override
  ConsumerState<CustomerListPage> createState() => _CustomerListPageState();
}

class _CustomerListPageState extends ConsumerState<CustomerListPage> {
  bool _showArchived = false;

  String _formatCpf(String? cpf) {
    if (cpf == null || cpf.trim().isEmpty) return 'Não informado';
    final clean = cpf.replaceAll(RegExp(r'\D'), '');
    if (clean.length == 11) {
      return '${clean.substring(0, 3)}.${clean.substring(3, 6)}.${clean.substring(6, 9)}-${clean.substring(9)}';
    }
    return cpf;
  }

  @override
  Widget build(BuildContext context) {
    final cities = ref.watch(citiesStreamProvider).valueOrNull ?? const <CityEntity>[];
    final cityNamesById = <String, String>{for (final city in cities) city.id: city.nome};
    final customersAsync = ref.watch(customersStreamProvider);
    final filteredCustomersAsync = customersAsync.whenData(
      (customers) => customers.where((customer) => customer.isAtivo != _showArchived).toList(),
    );

    return AppGroupedListPage<CustomerEntity>(
      title: _showArchived ? 'Arquivo de Clientes' : 'Lista de Clientes',
      appBarColor: AppMenuColors.customer,
      searchHint: 'Buscar por nome, apelido ou cidade...',
      emptyMessage: _showArchived ? 'Nenhum cliente arquivado.' : 'Nenhum cliente ativo cadastrado.',
      noResultsMessage: 'Nenhum cliente encontrado para',
      loadingErrorLabel: 'Erro ao carregar clientes',
      itemsAsync: filteredCustomersAsync,
      header: _buildArchiveSelector(customersAsync.valueOrNull ?? const <CustomerEntity>[]),
      actionLabel: 'Cliente',
      actionBackgroundColor: AppMenuColors.customer,
      searchFields: (customer) => [
        customer.nome,
        customer.apelido ?? '',
        cityNamesById[customer.cityId] ?? '',
      ],
      groupKey: (customer) => customer.nome,
      onAdd: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const CustomerFormPage(mode: AppFormMode.create)),
      ),
      itemBuilder: (context, customer, index, totalItems) {
        return AppCustomerCard(
          name: customer.apelido != null && customer.apelido!.isNotEmpty
              ? '${customer.nome} (${customer.apelido})'
              : customer.nome,
          cpf: _formatCpf(customer.cpf),
          phone: customer.celular ?? customer.telefoneFixo ?? 'Não informado',
          topTags: [
            StatusTag(
              text: customer.isAtivo ? 'Ativo' : 'Arquivado',
              color: customer.isAtivo ? const Color(0xFF86C5A6) : Colors.redAccent,
            ),
          ],
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => CustomerHubPage(customer: customer)),
          ),
        );
      },
    );
  }

  Widget _buildArchiveSelector(List<CustomerEntity> customers) {
    final activeCount = customers.where((customer) => customer.isAtivo).length;
    final archivedCount = customers.length - activeCount;

    return SegmentedButton<bool>(
      showSelectedIcon: false,
      segments: [
        ButtonSegment<bool>(
          value: false,
          icon: const Icon(Icons.people_alt_outlined, size: 18),
          label: Text('Ativos ($activeCount)'),
        ),
        ButtonSegment<bool>(
          value: true,
          icon: const Icon(Icons.archive_outlined, size: 18),
          label: Text('Inativos ($archivedCount)'),
        ),
      ],
      selected: {_showArchived},
      onSelectionChanged: (selection) => setState(() => _showArchived = selection.first),
    );
  }
}
