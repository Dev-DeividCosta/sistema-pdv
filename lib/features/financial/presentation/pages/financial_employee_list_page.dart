import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/list/app_grouped_list_page.dart';
import '../../../../core/widgets/status_tag.dart';
import '../../../employee/domain/entities/employee.dart';
import '../../../employee/presentation/providers/employee_provider.dart';
import 'financial_period_page.dart';

/// Lista de funcionários disponíveis para consulta do relatório financeiro.
class FinancialEmployeeListPage extends ConsumerWidget {
  const FinancialEmployeeListPage({super.key});

  String _cpf(String? value) =>
      value == null || value.trim().isEmpty ? 'Não informado' : value;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employeesAsync = ref.watch(employeesStreamProvider).whenData(
          (employees) => employees.where((employee) => employee.isAtivo).toList(),
        );

    return AppGroupedListPage<EmployeeEntity>(
      title: 'Funcionários - Relatório Financeiro',
      appBarColor: AppMenuColors.company,
      searchHint: 'Buscar por nome, apelido ou CPF...',
      emptyMessage: 'Nenhum funcionário ativo cadastrado.',
      noResultsMessage: 'Nenhum funcionário encontrado para',
      loadingErrorLabel: 'Erro ao carregar funcionários',
      itemsAsync: employeesAsync,
      searchFields: (employee) => [
        employee.nome,
        employee.apelido ?? '',
        employee.cpf ?? '',
      ],
      groupKey: (employee) => employee.nome,
      itemBuilder: (context, employee, index, totalItems) {
        return InkWell(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => FinancialPeriodPage(employee: employee),
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
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        employee.apelido?.isNotEmpty == true
                            ? '${employee.apelido}  •  ${employee.nome}'
                            : employee.nome,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'CPF: ${_cpf(employee.cpf)}',
                        style: TextStyle(color: Colors.grey[400], fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const StatusTag(
                  text: 'Ativo',
                  color: Color(0xFF86C5A6),
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

/// Mantém o nome curto disponível para chamadas antigas dentro do módulo.
typedef FinancialPage = FinancialEmployeeListPage;
