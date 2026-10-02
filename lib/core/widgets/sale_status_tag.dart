import 'package:flutter/material.dart';

import '../../features/sale/domain/entities/sale_status.dart';

class SaleStatusTag extends StatelessWidget {
  final String status;
  final bool compact;

  const SaleStatusTag({super.key, required this.status, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final definition = status.saleStatus;
    final padding = compact
        ? const EdgeInsets.symmetric(horizontal: 8, vertical: 4)
        : const EdgeInsets.symmetric(horizontal: 10, vertical: 5);
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: definition.color.withValues(alpha: compact ? 0.15 : 1),
        borderRadius: BorderRadius.circular(compact ? 8 : 20),
      ),
      child: Text(
        definition.label,
        style: TextStyle(
          color: compact ? definition.color : Colors.white,
          fontSize: compact ? 12 : 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
