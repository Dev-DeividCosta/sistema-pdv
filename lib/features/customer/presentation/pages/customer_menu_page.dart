import 'package:flutter/material.dart';
import '../../../../core/widgets/menu/base_menu_page.dart';
import '../builders/customer_menu_builder.dart';

class CustomerMenuPage extends StatelessWidget {
  final CustomerMenuBuilder menuBuilder;

  const CustomerMenuPage({
    super.key,
    this.menuBuilder = const CustomerMenuBuilderImpl(),
  });

  @override
  Widget build(BuildContext context) {
    final menuItems = menuBuilder.getMenuItems(context);

    return BaseMenuPage(
      title: 'Menu de Clientes',
      items: menuItems,
    );
  }
}