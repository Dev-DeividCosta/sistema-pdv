import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/hub/app_entity_hub_page.dart';
import '../../../../core/widgets/status_tag.dart';
import '../../domain/entities/payment_method.dart';
import '../builders/payment_method_hub_menu_builder.dart';
import '../providers/payment_method_provider.dart';

class PaymentMethodHubPage extends StatelessWidget {
  final PaymentMethodEntity paymentMethod;
  final PaymentMethodHubMenuBuilder menuBuilder;

  const PaymentMethodHubPage({
    super.key,
    required this.paymentMethod,
    this.menuBuilder = const PaymentMethodHubMenuBuilderImpl(),
  });

  @override
  Widget build(BuildContext context) {
    return AppEntityHubPage<PaymentMethodEntity>(
      item: paymentMethod,
      title: 'Detalhes da Forma de Pagamento',
      appBarColor: AppMenuColors.paymentMethods,
      itemsProvider: paymentMethodsStreamProvider,
      idOf: (item) => item.id,
      menuItemsBuilder: menuBuilder.getMenuItems,
      previewBuilder: (context, current) => Card(
        child: ListTile(
          leading: const Icon(Icons.credit_card),
          title: Text(current.nome),
          subtitle: const Text('Forma de pagamento'),
          trailing: StatusTag(
            text: current.isAtivo ? 'Ativo' : 'Inativo',
            color: current.isAtivo ? const Color(0xFF86C5A6) : Colors.redAccent,
          ),
        ),
      ),
    );
  }
}