import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/hub/app_entity_hub_page.dart';
import '../../../../core/widgets/cards/app_customer_card.dart';
import '../../../../core/widgets/status_tag.dart';
import '../../domain/entities/customer.dart';
import '../builders/customer_hub_menu_builder.dart';
import '../providers/customer_form_provider.dart';

class CustomerHubPage extends StatelessWidget {
  final CustomerEntity customer;
  final CustomerHubMenuBuilder menuBuilder;

  const CustomerHubPage({
    super.key,
    required this.customer,
    this.menuBuilder = const CustomerHubMenuBuilderImpl(),
  });

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
    return AppEntityHubPage<CustomerEntity>(
      item: customer,
      title: 'Detalhes do Cliente',
      appBarColor: AppMenuColors.customer,
      itemsProvider: customersStreamProvider,
      idOf: (item) => item.id,
      menuItemsBuilder: menuBuilder.getMenuItems,
      previewBuilder: (context, currentCustomer) {
        return AppCustomerCard(
          name: currentCustomer.apelido != null &&
                  currentCustomer.apelido!.isNotEmpty
              ? '${currentCustomer.nome} (${currentCustomer.apelido})'
              : currentCustomer.nome,
          cpf: _formatCpf(currentCustomer.cpf),
          phone: currentCustomer.celular ??
              currentCustomer.telefoneFixo ??
              'Não informado',
          onTap: null,
          showChevron: false,
          topTags: [
            StatusTag(
              text: currentCustomer.isAtivo ? 'Ativo' : 'Inativo',
              color: currentCustomer.isAtivo
                  ? const Color(0xFF86C5A6)
                  : Colors.redAccent,
            ),
          ],
        );
      },
    );
  }
}