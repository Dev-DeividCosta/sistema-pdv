import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/menu/base_menu_page.dart';
import '../builders/product_menu_builder.dart';

class ProductMenuPage extends StatelessWidget {
  final ProductMenuBuilder menuBuilder;

  const ProductMenuPage({
    super.key,
    this.menuBuilder = const ProductMenuBuilderImpl(),
  });

  @override
  Widget build(BuildContext context) {
    return BaseMenuPage(
      title: 'Menu de Produtos',
      appBarColor: AppMenuColors.products,
      items: menuBuilder.getMenuItems(context),
    );
  }
}