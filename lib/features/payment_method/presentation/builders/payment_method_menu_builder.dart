import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/models/app_menu_item.dart';
import '../../../../core/widgets/forms/form_mode.dart';
import '../pages/payment_method_form_page.dart';
import '../pages/payment_method_list_page.dart';

abstract class PaymentMethodMenuBuilder {
  List<AppMenuItem> getMenuItems(BuildContext context);
}

class PaymentMethodMenuBuilderImpl implements PaymentMethodMenuBuilder {
  const PaymentMethodMenuBuilderImpl();

  @override
  List<AppMenuItem> getMenuItems(BuildContext context) {
    return [
      AppMenuItem(
        title: 'Adicionar nova forma de pagamento',
        icon: Icons.add_card,
        color: AppMenuColors.paymentMethods,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PaymentMethodFormPage(mode: AppFormMode.create)),
        ),
      ),
      AppMenuItem(
        title: 'Listar formas cadastradas',
        icon: Icons.list_alt,
        color: AppMenuColors.paymentMethods,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PaymentMethodListPage()),
        ),
      ),
    ];
  }
}
