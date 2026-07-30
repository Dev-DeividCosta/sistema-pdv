import 'package:flutter/material.dart';
import '../models/dashboard_menu_item.dart';
import 'dashboard_tile.dart';

class ResponsiveDashboardGrid extends StatelessWidget {
  final List<DashboardMenuItem> items;

  const ResponsiveDashboardGrid({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 140,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.0,
      ),
      itemBuilder: (context, index) {
        return DashboardTile(item: items[index]);
      },
    );
  }
}