import 'package:flutter/material.dart';
import '../../../../core/models/app_menu_item.dart';
import '../pages/customer_form_page.dart';
import '../pages/customer_list_page.dart';

abstract class CustomerMenuBuilder {
  List<AppMenuItem> getMenuItems(BuildContext context);
}

class CustomerMenuBuilderImpl implements CustomerMenuBuilder {
  const CustomerMenuBuilderImpl();

  @override
  List<AppMenuItem> getMenuItems(BuildContext context) {
    return [
      AppMenuItem(
        title: 'Adicionar novo cliente',
        icon: Icons.person_add,
        color: const Color(0xFFB71C1C),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CustomerFormPage(mode: CustomerFormMode.create),
            ),
          );
        },
      ),
      AppMenuItem(
        title: 'Listar clientes cadastrados',
        icon: Icons.list_alt,
        color: const Color(0xFFB71C1C),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CustomerListPage(),
            ),
          );
        },
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
  }
}