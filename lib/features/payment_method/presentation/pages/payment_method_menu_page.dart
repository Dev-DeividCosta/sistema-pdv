import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/menu/base_menu_page.dart';
import '../builders/payment_method_menu_builder.dart';

class PaymentMethodMenuPage extends StatelessWidget {
  final PaymentMethodMenuBuilder menuBuilder;

  const PaymentMethodMenuPage({
    super.key,
    this.menuBuilder = const PaymentMethodMenuBuilderImpl(),
  });

  @override
  Widget build(BuildContext context) {
    return BaseMenuPage(
      title: 'Menu de Formas de Pagamento',
      appBarColor: AppMenuColors.paymentMethods,
      items: menuBuilder.getMenuItems(context).take(2).toList(),
    );
  }
}
