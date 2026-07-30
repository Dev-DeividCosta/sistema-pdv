import 'package:flutter/material.dart';
import '../models/dashboard_menu_item.dart';
import 'dashboard_tile.dart';

class ResponsiveDashboardGrid extends StatelessWidget {
  final List<DashboardMenuItem> items;

  const ResponsiveDashboardGrid({super.key, required this.items});

  int _calculateColumnCount(double width) {
    if (width > 700) return 5;
    if (width > 500) return 4;
    return 3;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _calculateColumnCount(constraints.maxWidth),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.0,
          ),
          itemBuilder: (context, index) {
            return DashboardTile(item: items[index]);
          },
        );
      },
    );
  }
}