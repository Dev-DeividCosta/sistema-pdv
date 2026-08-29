import 'package:flutter/material.dart';

import '../../domain/entities/sale.dart';

class SaleCart extends StatelessWidget {
  final List<SaleItemDraft> items;
  final ValueChanged<String> onIncrement;
  final ValueChanged<String> onDecrement;
  final ValueChanged<String> onRemove;

  const SaleCart({
    super.key,
    required this.items,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF262626),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(Icons.shopping_cart_outlined, color: Colors.grey[500], size: 42),
            const SizedBox(height: 8),
            Text(
              'O carrinho está vazio.',
              style: TextStyle(color: Colors.grey[400]),
            ),
            const SizedBox(height: 4),
            Text(
              'Selecione um produto acima para começar.',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF262626),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          for (var index = 0; index < items.length; index++) ...[
            _CartItemTile(
              item: items[index],
              onIncrement: () => onIncrement(items[index].id),
              onDecrement: () => onDecrement(items[index].id),
              onRemove: () => onRemove(items[index].id),
            ),
            if (index != items.length - 1)
              const Divider(color: Colors.white12, height: 1),
          ],
        ],
      ),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  final SaleItemDraft item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  const _CartItemTile({
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          const Icon(Icons.receipt_long_outlined, color: Colors.white70),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productNome,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_money(item.unitPriceCentavos)} cada  •  ${_money(item.totalCentavos)}',
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Diminuir quantidade',
            icon: const Icon(Icons.remove_circle_outline, color: Colors.white70),
            onPressed: onDecrement,
          ),
          Text(
            '${item.quantity}',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          IconButton(
            tooltip: 'Aumentar quantidade',
            icon: const Icon(Icons.add_circle_outline, color: Colors.white70),
            onPressed: onIncrement,
          ),
          IconButton(
            tooltip: 'Remover item',
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }

  String _money(int centavos) {
    return 'R\$ ${(centavos / 100).toStringAsFixed(2).replaceAll('.', ',')}';
  }
}
