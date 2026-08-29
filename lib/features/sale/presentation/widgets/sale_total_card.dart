import 'package:flutter/material.dart';

class SaleTotalCard extends StatelessWidget {
  final int subtotalCentavos;
  final int discountCentavos;
  final int totalCentavos;

  const SaleTotalCard({
    super.key,
    required this.subtotalCentavos,
    required this.discountCentavos,
    required this.totalCentavos,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1F6F5B),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _line('Subtotal', subtotalCentavos),
          if (discountCentavos > 0) ...[
            const SizedBox(height: 6),
            _line('Desconto', -discountCentavos),
          ],
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: Colors.white38, height: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'TOTAL',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                _money(totalCentavos),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _line(String label, int centavos) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70)),
        Text(_money(centavos), style: const TextStyle(color: Colors.white)),
      ],
    );
  }

  String _money(int centavos) {
    final signal = centavos < 0 ? '-' : '';
    final value = (centavos.abs() / 100).toStringAsFixed(2).replaceAll('.', ',');
    return '${signal}R\$ $value';
  }
}
