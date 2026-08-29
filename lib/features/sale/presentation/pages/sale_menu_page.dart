import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/menu/base_menu_page.dart';
import '../builders/sale_menu_builder.dart';

class SaleMenuPage extends StatelessWidget {
  final SaleMenuBuilder menuBuilder;

  const SaleMenuPage({
    super.key,
    this.menuBuilder = const SaleMenuBuilderImpl(),
  });

  @override
  Widget build(BuildContext context) {
    return BaseMenuPage(
      title: 'Menu de Vendas',
      appBarColor: AppMenuColors.sale,
      items: menuBuilder.getMenuItems(context),
    );
  }
}
