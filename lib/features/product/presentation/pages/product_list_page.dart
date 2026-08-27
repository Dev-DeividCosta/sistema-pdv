import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/list/app_grouped_list_page.dart';
import '../../../../core/widgets/status_tag.dart';
import '../../domain/entities/product.dart';
import '../providers/product_form_provider.dart';
import 'product_form_page.dart';
import 'product_hub_page.dart';

class ProductListPage extends ConsumerWidget {
  const ProductListPage({super.key});

  String _money(double value) {
    return 'R\$ ${value.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppGroupedListPage<ProductEntity>(
      title: 'Lista de Produtos',
      appBarColor: AppMenuColors.products,
      searchHint: 'Buscar por nome ou código de barras...',
      emptyMessage: 'Nenhum produto cadastrado.',
      noResultsMessage: 'Nenhum produto encontrado para',
      loadingErrorLabel: 'Erro ao carregar produtos',
      itemsAsync: ref.watch(productsStreamProvider),
      actionLabel: 'Produto',
      actionBackgroundColor: AppMenuColors.products,

      searchFields: (product) => [
        product.nomeProduto,
        product.codigoBarras ?? '',
        product.descricao ?? '',
      ],

      groupKey: (product) => product.nomeProduto,

      onAdd: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const ProductFormPage(),
          ),
        );
      },

      itemBuilder: (context, product, index, total) {
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 6,
          ),
          leading: const CircleAvatar(
            backgroundColor: AppMenuColors.products,
            child: Icon(
              Icons.inventory_2,
              color: Colors.white,
            ),
          ),
          title: Text(
            product.nomeProduto,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            'Estoque: ${product.quantidadeEstoque}  •  '
            'Venda: ${_money(product.precoVenda)}',
            style: TextStyle(
              color: Colors.grey[400],
            ),
          ),
          trailing: StatusTag(
            text: product.ativo ? 'Ativo' : 'Inativo',
            color: product.ativo
                ? const Color(0xFF86C5A6)
                : Colors.redAccent,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductHubPage(
                  product: product,
                ),
              ),
            );
          },
        );
      },
    );
  }
}