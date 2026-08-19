import 'package:flutter/material.dart';

class AppGroupedItemTile extends StatelessWidget {
  final Widget child;
  final int index;
  final int totalItems;
  final VoidCallback? onTap;

  const AppGroupedItemTile({
    super.key,
    required this.child,
    required this.index,
    required this.totalItems,
    this.onTap,
  });

  BorderRadius _getBorderRadius(int index, int totalItems) {
    if (totalItems == 1) {
      return BorderRadius.circular(12);
    } else if (index == 0) {
      return const BorderRadius.vertical(top: Radius.circular(12));
    } else if (index == totalItems - 1) {
      return const BorderRadius.vertical(bottom: Radius.circular(12));
    } else {
      return BorderRadius.zero;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: _getBorderRadius(index, totalItems),
          child: child,
        ),
        if (index < totalItems - 1)
          const Divider(
            color: Color(0xFF242424),
            height: 1,
            thickness: 1,
          ),
      ],
    );
  }
}