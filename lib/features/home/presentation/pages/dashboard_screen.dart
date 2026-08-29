import 'package:flutter/material.dart';
import '../builders/dashboard_menu_builder.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/menu/responsive_menu_grid.dart';
import '../../../../core/widgets/navigation/app_navigation_bar.dart'; 
import '../../../sale/presentation/pages/sale_page.dart';
import '../widgets/dashboard_app_bar.dart'; 

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
      extendBody: true, 
      
      appBar: const DashboardAppBar(),
      
      // Aplicando apenas a técnica de rolagem do Form, mantendo sua fidelidade visual
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 110.0),
                child: ResponsiveMenuGrid(items: menuItems), 
              ),
            ),
          );
        },
      ),
      
      bottomNavigationBar: AppNavigationBar(
        showBackButton: false,
        showHomeButton: false, 
        contextualAction: ContextualActionButton(
          icon: Icons.add,
          label: 'Venda',
          backgroundColor: AppMenuColors.sale, 
          foregroundColor: Colors.white,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SalePage()),
            );
          },
        ),
      ),
    );
  }
}