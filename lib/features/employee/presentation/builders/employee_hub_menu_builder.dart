import 'package:flutter/material.dart';

import '../../../../core/models/app_menu_item.dart';
import '../../../../core/widgets/forms/form_mode.dart';
import '../../domain/entities/employee.dart';
import '../pages/employee_form_page.dart';

abstract class EmployeeHubMenuBuilder {
  List<AppMenuItem> getMenuItems(BuildContext context, EmployeeEntity employee);
}

class EmployeeHubMenuBuilderImpl implements EmployeeHubMenuBuilder {
  const EmployeeHubMenuBuilderImpl();

  @override
  List<AppMenuItem> getMenuItems(BuildContext context, EmployeeEntity employee) {
    return [
      AppMenuItem(
        title: 'Visualizar',
        icon: Icons.visibility,
        // Altere para AppMenuColors.employee se estiver usando as cores centralizadas
        color: const Color(0xFFB71C1C), 
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EmployeeFormPage(
                employee: employee,
                mode: AppFormMode.view,
              ),
            ),
          );
        },
      ),
      AppMenuItem(
        title: 'Editar',
        icon: Icons.edit,
        color: const Color(0xFFB71C1C),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EmployeeFormPage(
                employee: employee,
                mode: AppFormMode.edit,
              ),
            ),
          );
        },
      ),
    ];
  }
}