import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/hub/app_entity_hub_page.dart';
import '../../../../core/widgets/status_tag.dart';
import '../../domain/entities/employee.dart';
import '../builders/employee_hub_menu_builder.dart';
import '../providers/employee_provider.dart';

class EmployeeHubPage extends StatelessWidget {
  final EmployeeEntity employee;
  final EmployeeHubMenuBuilder menuBuilder;

  const EmployeeHubPage({
    super.key,
    required this.employee,
    this.menuBuilder = const EmployeeHubMenuBuilderImpl(),
  });

  String _cpf(String? value) =>
      value == null || value.trim().isEmpty ? 'Não informado' : value;

  @override
  Widget build(BuildContext context) {
    return AppEntityHubPage<EmployeeEntity>(
      item: employee,
      title: 'Detalhes do Funcionário',
      appBarColor: AppMenuColors.employees,
      itemsProvider: employeesStreamProvider,
      idOf: (item) => item.id,
      menuItemsBuilder: menuBuilder.getMenuItems,
      previewBuilder: (_, currentEmployee) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF262626),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    currentEmployee.apelido?.isNotEmpty == true
                        ? '${currentEmployee.apelido}  •  ${currentEmployee.nome}'
                        : currentEmployee.nome,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                StatusTag(
                  text: currentEmployee.isAtivo ? 'Ativo' : 'Inativo',
                  color: currentEmployee.isAtivo
                      ? const Color(0xFF86C5A6)
                      : Colors.redAccent,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'CPF: ${_cpf(currentEmployee.cpf)}',
              style: TextStyle(color: Colors.grey[400], fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}