import 'package:flutter/material.dart';
import '../../domain/entities/sale.dart';

class ProductSearchField extends StatefulWidget {
  final List<SaleProduct> products;
  final ValueChanged<SaleProduct> onProductSelected;

  const ProductSearchField({
    super.key,
    required this.products,
    required this.onProductSelected,
  });

  @override
  State<ProductSearchField> createState() => _ProductSearchFieldState();
}

class _ProductSearchFieldState extends State<ProductSearchField> {
  static const _productItemExtent = 72.0;

  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final normalizedQuery = _query.trim().toLowerCase();
    
    final matches = widget.products.where((product) {
      if (normalizedQuery.isEmpty) return true;
      return product.nomeProduto.toLowerCase().contains(normalizedQuery) ||
          (product.codigoBarras ?? '').toLowerCase().contains(normalizedQuery);
    }).toList(growable: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _controller,
          onChanged: (value) => setState(() => _query = value),
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: 'Adicionar produto',
            hintText: 'Buscar por nome ou código de barras',
            labelStyle: const TextStyle(color: Colors.white70),
            hintStyle: TextStyle(color: Colors.grey[500]),
            prefixIcon: const Icon(Icons.search, color: Colors.white70),
            filled: true,
            fillColor: const Color(0xFF262626),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        if (matches.isNotEmpty) ...[
          const SizedBox(height: 8),
          Material(
            color: const Color(0xFF262626),
            borderRadius: BorderRadius.circular(12),
            clipBehavior: Clip.antiAlias,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: _productItemExtent * 2.5, 
              ),
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: matches.length,
                  itemExtent: _productItemExtent,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final product = matches[index];

                    return ListTile(
                      dense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      leading: const Icon(
                        Icons.inventory_2_outlined,
                        color: Colors.white70,
                      ),
                      title: Text(
                        product.nomeProduto,
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        product.codigoBarras == null
                            ? 'Preço: ${_money(product.precoVenda)}'
                            : '${product.codigoBarras}  •  ${_money(product.precoVenda)}',
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                      trailing: const Icon(
                        Icons.add_circle_outline,
                        color: Colors.white70,
                      ),
                      onTap: () {
                        widget.onProductSelected(product);
                        _controller.clear();
                        setState(() => _query = ''); 
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ] else if (normalizedQuery.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(
            'Nenhum produto ativo encontrado.',
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ],
    );
  }

  String _money(double value) {
    return 'R\$ ${value.toStringAsFixed(2).replaceAll('.', ',')}';
  }
}