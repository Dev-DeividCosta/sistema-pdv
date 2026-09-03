import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/forms/form_mode.dart';
import '../../../../core/widgets/list/app_grouped_list_page.dart';
import '../../../../core/widgets/status_tag.dart';
import '../../domain/entities/employee.dart';
import '../providers/employee_provider.dart';
import 'employee_form_page.dart';
import 'employee_hub_page.dart';

class EmployeeListPage extends ConsumerWidget {
  const EmployeeListPage({super.key});

  String _cpf(String? value) =>
      value == null || value.trim().isEmpty ? 'Não informado' : value;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppGroupedListPage<EmployeeEntity>(
      title: 'Lista de Funcionários',
      appBarColor: AppMenuColors.employees,
      searchHint: 'Buscar por nome ou apelido...',
      emptyMessage: 'Nenhum funcionário cadastrado.',
      noResultsMessage: 'Nenhum funcionário encontrado para',
      loadingErrorLabel: 'Erro ao carregar funcionários',
      itemsAsync: ref.watch(employeesStreamProvider),
      actionLabel: 'Funcionário',
      actionBackgroundColor: AppMenuColors.employees,
      searchFields: (e) => [e.nome, e.apelido ?? '', e.cpf ?? ''],
      groupKey: (e) => e.nome,
      onAdd: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const EmployeeFormPage(mode: AppFormMode.create),
        ),
      ),
      itemBuilder: (context, e, index, totalItems) {
        return InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EmployeeHubPage(employee: e),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              border: Border(
                bottom: index < totalItems - 1
                    ? BorderSide(color: Colors.grey.withValues(alpha: 0.1))
                    : BorderSide.none,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        e.apelido?.isNotEmpty == true
                            ? '${e.apelido}  •  ${e.nome}'
                            : e.nome,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'CPF: ${_cpf(e.cpf)}',
                        style: TextStyle(color: Colors.grey[400], fontSize: 14),
                      ),
                    ],
                  ),
                ),
                StatusTag(
                  text: e.isAtivo ? 'Ativo' : 'Inativo',
                  color: e.isAtivo
                      ? const Color(0xFF86C5A6)
                      : Colors.redAccent,
                ),
                const SizedBox(width: 12),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ),
        );
      },
    );
  }
}