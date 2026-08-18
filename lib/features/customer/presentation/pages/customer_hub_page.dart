import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/app_menu_tile.dart';
import '../../../../core/widgets/app_customer_card.dart';
import '../../../../core/widgets/status_tag.dart';
import '../../domain/entities/customer.dart';
import '../builders/customer_hub_menu_builder.dart';
import '../providers/customer_form_provider.dart';

class CustomerHubPage extends ConsumerWidget {
  final CustomerEntity customer;
  final CustomerHubMenuBuilder menuBuilder;

  const CustomerHubPage({
    super.key,
    required this.customer,
    this.menuBuilder = const CustomerHubMenuBuilderImpl(),
  });

  /// Helper para formatar o CPF na exibição (ex: 12345678901 -> 123.456.789-01)
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
    // Escuta as alterações no banco de dados em tempo real
    final customersAsync = ref.watch(customersStreamProvider);

    // Busca o cliente atualizado na lista usando o ID.
    // Se estiver carregando ou não encontrar, usa o cliente passado inicialmente.
    final currentCustomer = customersAsync.maybeWhen(
      data: (customers) => customers.firstWhere(
        (c) => c.id == customer.id,
        orElse: () => customer,
      ),
      orElse: () => customer,
    );

    // Busca os itens do menu passando o cliente reativo ("Visualizar", "Editar", etc.)
    final menuItems = menuBuilder.getMenuItems(context, currentCustomer);

    return Scaffold(
      backgroundColor: const Color(0xFF171717),
      appBar: AppBar(
        title: const Text('Detalhes do Cliente'),
        backgroundColor: const Color(0xFF171717),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. PREVIEW DO CLIENTE (Reativo)
                  MediaQuery(
                    data: MediaQuery.of(context),
                    child: AppCustomerCard(
                      name: currentCustomer.apelido != null && currentCustomer.apelido!.isNotEmpty 
                          ? '${currentCustomer.nome} (${currentCustomer.apelido})'
                          : currentCustomer.nome,
                      cpf: _formatCpf(currentCustomer.cpf),
                      phone: currentCustomer.celular ?? currentCustomer.telefoneFixo ?? 'Não informado',
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
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 2. BOTÕES DE AÇÃO EM COLUNA
                  ...menuItems.map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: SizedBox(
                        height: 54,
                        child: AppMenuTile(
                          item: item,
                          shape: TileShape.rectangle,
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 32),

                  // 3. BOTÃO VOLTAR
                  Center(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(200, 50),
                      ),
                      child: const Text('Voltar'),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}