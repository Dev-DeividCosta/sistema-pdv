import 'package:flutter/material.dart';

class StatusTag extends StatelessWidget {
  final String text;
  final Color color;
  final IconData? icon;
  final VoidCallback? onTap;

  const StatusTag({
    super.key,
    required this.text,
    required this.color,
    this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget tag = Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha:0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text.toUpperCase(),
            style: TextStyle(
              color: color,
              fontSize: 9,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          if (icon != null) ...[
            const SizedBox(width: 4),
            Icon(icon, size: 12, color: color),
          ],
        ],
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: tag,
      );
    }
    return tag;
  }
}