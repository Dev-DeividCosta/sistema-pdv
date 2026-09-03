import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/forms/form_mode.dart';
import '../../../../core/widgets/list/app_grouped_list_page.dart';
import '../../../../core/widgets/status_tag.dart';
import '../../domain/entities/payment_method.dart';
import '../providers/payment_method_provider.dart';
import 'payment_method_form_page.dart';
import 'payment_method_hub_page.dart';

class PaymentMethodListPage extends ConsumerWidget {
  const PaymentMethodListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppGroupedListPage<PaymentMethodEntity>(
      title: 'Lista de Formas de Pagamento',
      appBarColor: AppMenuColors.paymentMethods,
      searchHint: 'Buscar por nome...',
      emptyMessage: 'Nenhuma forma de pagamento cadastrada.',
      noResultsMessage: 'Nenhuma forma de pagamento encontrada para',
      loadingErrorLabel: 'Erro ao carregar formas de pagamento',
      itemsAsync: ref.watch(paymentMethodsStreamProvider),
      actionLabel: 'Forma de pagamento',
      actionBackgroundColor: AppMenuColors.paymentMethods,
      searchFields: (item) => [item.nome],
      groupKey: (item) => item.nome,
      onAdd: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PaymentMethodFormPage(mode: AppFormMode.create)),
      ),
      itemBuilder: (context, item, index, totalItems) => ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        leading: CircleAvatar(
          backgroundColor: AppMenuColors.paymentMethods.withValues(alpha: 0.18),
          child: Icon(Icons.credit_card, color: AppMenuColors.paymentMethods),
        ),
        title: Text(item.nome, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: const Text('Forma de pagamento'),
        trailing: StatusTag(
          text: item.isAtivo ? 'Ativo' : 'Inativo',
          color: item.isAtivo ? const Color(0xFF86C5A6) : Colors.redAccent,
        ),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => PaymentMethodHubPage(paymentMethod: item)),
        ),
      ),
    );
  }
}
