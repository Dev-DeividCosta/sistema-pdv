import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/models/app_menu_item.dart';
import '../../../../core/widgets/forms/form_mode.dart';
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
        color: AppMenuColors.customer,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CustomerFormPage(mode: AppFormMode.create),
            ),
          );
        },
      ),
      AppMenuItem(
        title: 'Listar clientes cadastrados',
        icon: Icons.list_alt,
        color: AppMenuColors.customer,
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
        color: AppMenuColors.customer,
        onTap: () {},
      ),
      AppMenuItem(
        title: 'Saldo devedor de um cliente',
        icon: Icons.money_off,
        color: AppMenuColors.customer,
        onTap: () {},
      ),
      AppMenuItem(
        title: 'Pagamentos de um cliente',
        icon: Icons.payment,
        color: AppMenuColors.customer,
        onTap: () {},
      ),
      AppMenuItem(
        title: 'Vendas por cliente',
        icon: Icons.shopping_bag,
        color: AppMenuColors.customer,
        onTap: () {},
      ),
      AppMenuItem(
        title: 'Lista dos clientes em excel',
        icon: Icons.table_view,
        color: AppMenuColors.customer,
        onTap: () {},
      ),
    ];
  }
}