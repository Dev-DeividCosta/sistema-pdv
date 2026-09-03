import 'package:flutter/material.dart';

import '../../../../core/models/app_menu_item.dart';
import '../../../../core/widgets/forms/form_mode.dart';
import '../../domain/entities/payment_method.dart';
import '../pages/payment_method_form_page.dart';

abstract class PaymentMethodHubMenuBuilder {
  List<AppMenuItem> getMenuItems(BuildContext context, PaymentMethodEntity paymentMethod);
}

class PaymentMethodHubMenuBuilderImpl implements PaymentMethodHubMenuBuilder {
  const PaymentMethodHubMenuBuilderImpl();

  @override
  List<AppMenuItem> getMenuItems(BuildContext context, PaymentMethodEntity paymentMethod) {
    return [
      AppMenuItem(
        title: 'Visualizar',
        icon: Icons.visibility,
        color: const Color(0xFFB71C1C),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PaymentMethodFormPage(paymentMethod: paymentMethod, mode: AppFormMode.view),
          ),
        ),
      ),
      AppMenuItem(
        title: 'Editar',
        icon: Icons.edit,
        color: const Color(0xFFB71C1C),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PaymentMethodFormPage(paymentMethod: paymentMethod, mode: AppFormMode.edit),
          ),
        ),
      ),
    ];
  }
}
