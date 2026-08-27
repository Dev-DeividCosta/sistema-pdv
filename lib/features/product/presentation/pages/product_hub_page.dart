import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/hub/app_entity_hub_page.dart';
import '../../../../core/widgets/status_tag.dart';
import '../../domain/entities/product.dart';
import '../builders/product_hub_menu_builder.dart';
import '../providers/product_form_provider.dart';

class ProductHubPage extends StatelessWidget {
  final ProductEntity product;
  final ProductHubMenuBuilder menuBuilder;

  const ProductHubPage({
    super.key,
    required this.product,
    this.menuBuilder = const ProductHubMenuBuilderImpl(),
  });

  String _money(double value) {
    return 'R\$ ${value.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  @override
  Widget build(BuildContext context) {
    return AppEntityHubPage<ProductEntity>(
      item: product,
      title: 'Detalhes do Produto',
      appBarColor: AppMenuColors.products,
      itemsProvider: productsStreamProvider,
      idOf: (product) => product.id,
      menuItemsBuilder: menuBuilder.getMenuItems,
      previewBuilder: (context, product) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF262626),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      product.nomeProduto,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  StatusTag(
                    text: product.ativo ? 'Ativo' : 'Inativo',
                    color: product.ativo
                        ? const Color(0xFF86C5A6)
                        : Colors.redAccent,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Venda: ${_money(product.precoVenda)}',
                style: TextStyle(
                  color: Colors.grey[300],
                  fontSize: 16,
                ),
              ),
              Text(
                'Custo: ${_money(product.precoCusto)}',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14,
                ),
              ),
              Text(
                'Estoque: ${product.quantidadeEstoque} '
                '(mínimo ${product.estoqueMinimo})',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14,
                ),
              ),
              if ((product.codigoBarras ?? '').isNotEmpty)
                Text(
                  'Código de barras: ${product.codigoBarras}',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}