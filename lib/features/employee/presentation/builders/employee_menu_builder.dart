import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/models/app_menu_item.dart';
import '../../../../core/widgets/forms/form_mode.dart';
import '../pages/employee_form_page.dart';
import '../pages/employee_list_page.dart';

abstract class EmployeeMenuBuilder {
  List<AppMenuItem> getMenuItems(BuildContext context);
}

class EmployeeMenuBuilderImpl implements EmployeeMenuBuilder {
  const EmployeeMenuBuilderImpl();

  @override
  List<AppMenuItem> getMenuItems(BuildContext context) {
    return [
      AppMenuItem(
        title: 'Adicionar novo funcionário',
        icon: Icons.person_add_alt_1,
        color: AppMenuColors.employees,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const EmployeeFormPage(
                mode: AppFormMode.create,
              ),
            ),
          );
        },
      ),
      AppMenuItem(
        title: 'Listar funcionários cadastrados',
        icon: Icons.list_alt,
        color: AppMenuColors.employees,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const EmployeeListPage(),
            ),
          );
        },
      ),
    ];
  }
}