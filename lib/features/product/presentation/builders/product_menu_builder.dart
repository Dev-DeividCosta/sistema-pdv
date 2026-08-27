import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/models/app_menu_item.dart';
import '../pages/product_form_page.dart';
import '../pages/product_list_page.dart';

abstract class ProductMenuBuilder {
  List<AppMenuItem> getMenuItems(BuildContext context);
}

class ProductMenuBuilderImpl implements ProductMenuBuilder {
  const ProductMenuBuilderImpl();

  @override
  List<AppMenuItem> getMenuItems(BuildContext context) {
    return [
      AppMenuItem(
        title: 'Adicionar novo produto',
        icon: Icons.add_box_outlined,
        color: AppMenuColors.products,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const ProductFormPage(),
          ),
        ),
      ),
      AppMenuItem(
        title: 'Listar produtos cadastrados',
        icon: Icons.list_alt,
        color: AppMenuColors.products,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const ProductListPage(),
          ),
        ),
      ),
    ];
  }
}