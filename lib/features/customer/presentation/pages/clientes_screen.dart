// lib/features/customer/presentation/pages/clientes_screen.dart
import 'package:flutter/material.dart';
import '../../../../core/models/app_menu_item.dart';
import '../../../../core/widgets/app_menu_tile.dart';
import '../../../../core/widgets/responsive_menu_grid.dart';

class ClientesScreen extends StatelessWidget {
  const ClientesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Lista com as opções de clientes, usando o novo modelo global
    final List<AppMenuItem> menuItems = [
      AppMenuItem(
        title: 'Adicionar novo cliente',
        icon: Icons.person_add,
        color: const Color(0xFFB71C1C),
        onTap: () {},
      ),
      AppMenuItem(
        title: 'Listar clientes cadastrados',
        icon: Icons.list_alt,
        color: const Color(0xFFB71C1C),
        onTap: () {},
      ),
      AppMenuItem(
        title: 'Gerar relatório PDF dos clientes',
        icon: Icons.picture_as_pdf,
        color: const Color(0xFFB71C1C),
        onTap: () {},
      ),
      AppMenuItem(
        title: 'Saldo devedor de um cliente',
        icon: Icons.money_off,
        color: const Color(0xFFB71C1C),
        onTap: () {},
      ),
      AppMenuItem(
        title: 'Pagamentos de um cliente',
        icon: Icons.payment,
        color: const Color(0xFFB71C1C),
        onTap: () {},
      ),
      AppMenuItem(
        title: 'Vendas por cliente',
        icon: Icons.shopping_bag,
        color: const Color(0xFFB71C1C),
        onTap: () {},
      ),
      AppMenuItem(
        title: 'Lista dos clientes em excel',
        icon: Icons.table_view,
        color: const Color(0xFFB71C1C),
        onTap: () {},
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF2C2C2C),
      appBar: AppBar(
        title: const Text('Menu de Clientes'),
      ),
      body: Center(
        // 💡 O ConstrainedBox foi removido daqui! Agora o Padding ocupa todo o espaço disponível.
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