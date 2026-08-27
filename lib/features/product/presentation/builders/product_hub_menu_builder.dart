import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/models/app_menu_item.dart';
import '../../../../core/widgets/forms/form_mode.dart';
import '../../domain/entities/product.dart';
import '../pages/product_form_page.dart';

abstract class ProductHubMenuBuilder {
  List<AppMenuItem> getMenuItems(
    BuildContext context,
    ProductEntity product,
  );
}

class ProductHubMenuBuilderImpl implements ProductHubMenuBuilder {
  const ProductHubMenuBuilderImpl();

  @override
  List<AppMenuItem> getMenuItems(
    BuildContext context,
    ProductEntity product,
  ) {
    return [
      AppMenuItem(
        title: 'Visualizar',
        icon: Icons.visibility,
        color: AppMenuColors.products,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProductFormPage(
                product: product,
                mode: AppFormMode.view,
              ),
            ),
          );
        },
      ),
      AppMenuItem(
        title: 'Editar',
        icon: Icons.edit,
        color: AppMenuColors.products,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProductFormPage(
                product: product,
                mode: AppFormMode.edit,
              ),
            ),
          );
        },
      ),
    ];
  }
}