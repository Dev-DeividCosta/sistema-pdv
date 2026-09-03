import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/menu/base_menu_page.dart';
import '../builders/employee_menu_builder.dart';

class EmployeeMenuPage extends StatelessWidget {
  final EmployeeMenuBuilder menuBuilder;

  const EmployeeMenuPage({
    super.key,
    this.menuBuilder = const EmployeeMenuBuilderImpl(),
  });

  @override
  Widget build(BuildContext context) {
    return BaseMenuPage(
      title: 'Menu de Funcionários',
      appBarColor: AppMenuColors.employees,
      items: menuBuilder.getMenuItems(context),
    );
  }
}
