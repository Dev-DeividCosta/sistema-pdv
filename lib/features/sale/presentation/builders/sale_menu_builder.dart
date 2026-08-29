import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/models/app_menu_item.dart';
import '../pages/sale_history_page.dart';
import '../pages/sale_page.dart';

abstract class SaleMenuBuilder {
  List<AppMenuItem> getMenuItems(BuildContext context);
}

class SaleMenuBuilderImpl implements SaleMenuBuilder {
  const SaleMenuBuilderImpl();

  @override
  List<AppMenuItem> getMenuItems(BuildContext context) {
    return [
      AppMenuItem(
        title: 'Registrar nova venda',
        icon: Icons.add_shopping_cart,
        color: AppMenuColors.sale,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SalePage()),
        ),
      ),
      AppMenuItem(
        title: 'Consultar histórico',
        icon: Icons.receipt_long,
        color: AppMenuColors.sale,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SaleHistoryPage()),
        ),
      ),
    ];
  }
}
