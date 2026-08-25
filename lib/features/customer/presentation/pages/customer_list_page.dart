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

class CustomerListPage extends ConsumerWidget {
  const CustomerListPage({super.key});

  String _formatCpf(String? cpf) {
    if (cpf == null || cpf.trim().isEmpty) return 'Não informado';
    final clean = cpf.replaceAll(RegExp(r'\D'), '');
    if (clean.length == 11) {
      return '${clean.substring(0, 3)}.${clean.substring(3, 6)}.${clean.substring(6, 9)}-${clean.substring(9)}';
    }
    return cpf;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cities = ref.watch(citiesStreamProvider).valueOrNull ?? const <CityEntity>[];
    final cityNamesById = <String, String>{
      for (final city in cities) city.id: city.nome,
    };

    return AppGroupedListPage<CustomerEntity>(
      title: 'Lista de Clientes',
      appBarColor: AppMenuColors.customer,
      searchHint: 'Buscar por nome, apelido ou cidade...',
      emptyMessage: 'Nenhum cliente cadastrado.',
      noResultsMessage: 'Nenhum cliente encontrado para',
      loadingErrorLabel: 'Erro ao carregar clientes',
      itemsAsync: ref.watch(customersStreamProvider),
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
        MaterialPageRoute(
          builder: (_) => const CustomerFormPage(mode: AppFormMode.create),
        ),
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
              text: customer.isAtivo ? 'Ativo' : 'Inativo',
              color: customer.isAtivo ? const Color(0xFF86C5A6) : Colors.redAccent,
            ),
          ],
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CustomerHubPage(customer: customer),
            ),
          ),
        );
      },
    );
  }
}