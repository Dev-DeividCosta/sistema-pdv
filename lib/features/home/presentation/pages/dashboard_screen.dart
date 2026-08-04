import 'package:flutter/material.dart';
import '../builders/dashboard_menu_builder.dart';
import '../widgets/dashboard_app_bar.dart';
import '../widgets/dashboard_bottom_bar.dart';

import '../../../../core/widgets/responsive_menu_grid.dart';

class DashboardScreen extends StatelessWidget {
  final DashboardBuilder builder;

  const DashboardScreen({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    final menuItems = builder.getMenuItems(context);

    return Scaffold(
      appBar: const DashboardAppBar(),
      
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ResponsiveMenuGrid(items: menuItems), 
      ),
      
      bottomNavigationBar: const DashboardBottomBar(),
      
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add_shopping_cart, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}