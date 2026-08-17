import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/app_group_card.dart';
import '../../../../core/widgets/app_customer_card.dart';
import '../../../../core/widgets/status_tag.dart';
import '../../domain/entities/customer.dart';
import '../providers/customer_form_provider.dart';
import 'new_customer_page.dart';

class ListCustomerPage extends ConsumerStatefulWidget {
  const ListCustomerPage({super.key});

  @override
  ConsumerState<ListCustomerPage> createState() => _ListCustomerPageState();
}

class _ListCustomerPageState extends ConsumerState<ListCustomerPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Helper para formatar o CPF na exibição (ex: 12345678901 -> 123.456.789-01)
  String _formatCpf(String? cpf) {
    if (cpf == null || cpf.trim().isEmpty) return 'Não informado';
    
    final clean = cpf.replaceAll(RegExp(r'\D'), '');
    if (clean.length == 11) {
      return '${clean.substring(0, 3)}.${clean.substring(3, 6)}.${clean.substring(6, 9)}-${clean.substring(9)}';
    }
    
    return cpf; // Retorna como está caso não tenha 11 dígitos (fallback)
  }

  @override
  Widget build(BuildContext context) {
    final customersAsync = ref.watch(customersStreamProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF171717),
      appBar: AppBar(
        title: const Text('Lista de Clientes'),
        backgroundColor: const Color(0xFF171717),
        elevation: 0,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NewCustomerScreen(),
            ),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                children: [
                  // Campo de Busca
                  TextField(
                    controller: _searchController,
                    onChanged: (value) => setState(() => _searchQuery = value.toLowerCase()),
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Buscar por nome, apelido ou cidade...',
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      filled: true,
                      fillColor: const Color(0xFF262626),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Lista Agrupada
                  customersAsync.when(
                    data: (customers) {
                      final filteredCustomers = customers.where((c) {
                        final nameMatch = c.nome.toLowerCase().contains(_searchQuery);
                        final nickMatch = (c.apelido ?? '').toLowerCase().contains(_searchQuery);
                        final cityMatch = (c.cidade ?? '').toLowerCase().contains(_searchQuery);
                        return nameMatch || nickMatch || cityMatch;
                      }).toList();

                      if (filteredCustomers.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 32.0),
                          child: Center(
                            child: Text(
                              _searchQuery.isEmpty
                                  ? 'Nenhum cliente cadastrado.'
                                  : 'Nenhum cliente encontrado para "$_searchQuery".',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ),
                        );
                      }

                      // Agrupar pela primeira letra
                      final Map<String, List<CustomerEntity>> groupedCustomers = {};
                      for (var customer in filteredCustomers) {
                        final firstLetter = customer.nome.isNotEmpty 
                            ? customer.nome[0].toUpperCase() 
                            : '#';
                        if (!groupedCustomers.containsKey(firstLetter)) {
                          groupedCustomers[firstLetter] = [];
                        }
                        groupedCustomers[firstLetter]!.add(customer);
                      }

                      final sortedKeys = groupedCustomers.keys.toList()..sort();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: sortedKeys.map((letter) {
                          final group = groupedCustomers[letter]!;
                          group.sort((a, b) => a.nome.compareTo(b.nome));

                          return AppGroupCard<CustomerEntity>(
                            title: letter,
                            items: group,
                            itemBuilder: (context, customer, index, total) {
                              return AppCustomerCard(
                                name: customer.apelido != null && customer.apelido!.isNotEmpty 
                                    ? '${customer.nome} (${customer.apelido})'
                                    : customer.nome,
                                cpf: _formatCpf(customer.cpf), // <-- AQUI: Passando o CPF formatado
                                phone: customer.celular ?? customer.telefoneFixo ?? 'Não informado',
                                
                                // Tag em linha posicionada no topo (acima do nome)
                                topTags: [
                                  StatusTag(
                                    text: customer.isAtivo ? 'Ativo' : 'Inativo',
                                    color: customer.isAtivo 
                                        ? const Color(0xFF86C5A6) 
                                        : Colors.redAccent,
                                  ),
                                ],
                                onTap: () {
                                  // TODO: Abrir detalhes
                                },
                              );
                            },
                          );
                        }).toList(),
                      );
                    },
                    loading: () => const Padding(
                      padding: EdgeInsets.only(top: 32.0),
                      child: Center(child: CircularProgressIndicator(color: Colors.white)),
                    ),
                    error: (err, stack) => Padding(
                      padding: const EdgeInsets.only(top: 32.0),
                      child: Center(
                        child: Text(
                          'Erro ao carregar clientes: $err',
                          style: const TextStyle(color: Colors.redAccent),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}