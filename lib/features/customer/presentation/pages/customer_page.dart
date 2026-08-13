import 'package:flutter/material.dart';
import '../../../../core/widgets/app_menu_tile.dart';
import '../../../../core/widgets/responsive_menu_grid.dart';
import '../builders/customer_menu_builder.dart';

class CustomerScreen extends StatelessWidget {
  final CustomerMenuBuilder menuBuilder;

  const CustomerScreen({
    super.key,
    this.menuBuilder = const CustomerMenuBuilderImpl(),
  });

  @override
  Widget build(BuildContext context) {
    final menuItems = menuBuilder.getMenuItems(context);

    return Scaffold(
      backgroundColor: const Color(0xFF2C2C2C),
      appBar: AppBar(
        title: const Text('Menu de Clientes'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: ResponsiveMenuGrid(
                  items: menuItems,
                  shape: TileShape.rectangle,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 50),
                ),
                child: const Text('Voltar'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}