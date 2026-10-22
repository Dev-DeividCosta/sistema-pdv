import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/forms/app_form_components.dart';
import '../../../../core/widgets/forms/app_form_layout.dart';
import '../../../../core/widgets/forms/app_form_select_field.dart';
import '../../../city/presentation/pages/city_form_page.dart';
import '../../../employee/presentation/pages/employee_form_page.dart';
import '../../../sale/domain/entities/sale_status.dart';
import '../../domain/entities/financial_city.dart';
import '../../domain/entities/financial_employee.dart';
import '../../domain/entities/financial_query.dart';
import '../providers/financial_provider.dart';
import 'financial_results_page.dart';

const _allCitiesValue = '__all_cities__';
const _allEmployeesValue = '__all_employees__';

class FinancialPage extends ConsumerStatefulWidget {
  const FinancialPage({super.key});

  @override
  ConsumerState<FinancialPage> createState() => _FinancialPageState();
}

class _FinancialPageState extends ConsumerState<FinancialPage> {
  late final TextEditingController _startDateController;
  late final TextEditingController _endDateController;
  String _selectedCityValue = _allCitiesValue;
  String _selectedEmployeeValue = _allEmployeesValue;
  late Set<SaleStatus> _selectedStatuses;

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    _startDateController = TextEditingController();
    _endDateController = TextEditingController(
      text: _formatDate(DateTime(today.year, today.month, today.day)),
    );
    _selectedStatuses = SaleStatus.values.toSet();
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final citiesAsync = ref.watch(financialCitiesProvider);
    final employeesAsync = ref.watch(financialEmployeesProvider);
    final startDate = _parseDate(_startDateController.text);
    final endDate = _parseDate(_endDateController.text);
    final canContinue = _selectedStatuses.isNotEmpty &&
        startDate != null &&
        endDate != null &&
        !endDate.isBefore(startDate);

    return AppFormLayout(
      title: 'Controle Financeiro',
      appBarColor: AppMenuColors.company,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text(
              'Selecione os filtros para consultar as vendas e visualizar o relatório.',
              style: TextStyle(color: Colors.white70, height: 1.4),
            ),
          ),
          AppFormSection(
            icon: Icons.location_on_outlined,
            title: 'Filtros do Relatório',
            child: Column(
              children: [
                citiesAsync.when(
                  loading: () => const InputDecorator(
                    decoration: InputDecoration(labelText: 'Cidade'),
                    child: LinearProgressIndicator(),
                  ),
                  error: (error, _) => Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Não foi possível carregar as cidades.',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Tentar novamente',
                        onPressed: () => ref.invalidate(financialCitiesProvider),
                        icon: const Icon(Icons.refresh, color: Colors.white70),
                      ),
                    ],
                  ),
                  data: (cities) => _buildCitySelect(cities),
                ),
                const SizedBox(height: 12),
                employeesAsync.when(
                  loading: () => const InputDecorator(
                    decoration: InputDecoration(labelText: 'vendedor'),
                    child: LinearProgressIndicator(),
                  ),
                  error: (error, _) => Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Não foi possível carregar os vendedors.',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Tentar novamente',
                        onPressed: () => ref.invalidate(financialEmployeesProvider),
                        icon: const Icon(Icons.refresh, color: Colors.white70),
                      ),
                    ],
                  ),
                  data: (employees) => _buildEmployeeSelect(employees),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AppFormSection(
            icon: Icons.date_range_outlined,
            title: 'Período',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 2,
                  children: [
                    _QuickRangeButton(
                      label: 'Este mês',
                      onPressed: () {
                        final now = DateTime.now();
                        _setRange(DateTime(now.year, now.month, 1), now);
                      },
                    ),
                    _QuickRangeButton(
                      label: 'Últimos 30 dias',
                      onPressed: () {
                        final now = DateTime.now();
                        final today = DateTime(now.year, now.month, now.day);
                        _setRange(
                          today.subtract(const Duration(days: 29)),
                          today,
                        );
                      },
                    ),
                    _QuickRangeButton(
                      label: 'Este ano',
                      onPressed: () {
                        final now = DateTime.now();
                        _setRange(DateTime(now.year, 1, 1), now);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _DateInputField(
                        label: 'Data inicial',
                        controller: _startDateController,
                        icon: Icons.calendar_today_outlined,
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _DateInputField(
                        label: 'Data final',
                        controller: _endDateController,
                        icon: Icons.event_available_outlined,
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                  ],
                ),
                if (_parseDate(_startDateController.text) == null ||
                    _parseDate(_endDateController.text) == null) ...[
                  const SizedBox(height: 8),
                  const Text(
                    'Digite as datas no formato DD/MM/AAAA.',
                    style: TextStyle(color: Colors.orangeAccent, fontSize: 12),
                  ),
                ] else if (_parseDate(_endDateController.text)!
                    .isBefore(_parseDate(_startDateController.text)!)) ...[
                  const SizedBox(height: 8),
                  const Text(
                    'A data final deve ser igual ou posterior à data inicial.',
                    style: TextStyle(color: Colors.redAccent, fontSize: 12),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          AppFormSection(
            icon: Icons.sell_outlined,
            title: 'Status das Vendas',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Selecione um ou mais status para incluir no relatório.',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 12),
                _StatusSelectField(
                  selectedStatuses: _selectedStatuses,
                  onChanged: (statuses) =>
                      setState(() => _selectedStatuses = statuses),
                ),
                if (_selectedStatuses.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      'Selecione ao menos um status.',
                      style: TextStyle(color: Colors.redAccent, fontSize: 12),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              onPressed: canContinue
                  ? () => _openResults(
                        citiesAsync.valueOrNull ?? const [],
                        employeesAsync.valueOrNull ?? const [],
                      )
                  : null,
              icon: const Icon(Icons.query_stats_outlined),
              label: const Text('VER RESULTADOS'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppMenuColors.company,
                disabledBackgroundColor: Colors.grey[700],
                foregroundColor: Colors.white,
                disabledForegroundColor: Colors.white54,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCitySelect(List<FinancialCity> cities) {
    final options = <String, String>{
      _allCitiesValue: 'Todas as cidades',
      for (final city in cities) city.id: '${city.name} - ${city.state}',
    };
    final value = options.containsKey(_selectedCityValue)
        ? _selectedCityValue
        : _allCitiesValue;

    return AppFormSelectField<String>(
      label: 'Cidade',
      value: value,
      options: options,
      sheetTitle: 'Selecione a Cidade',
      primaryColor: AppMenuColors.company,
      action: AppFormSelectAction(
        label: 'Cadastrar nova cidade',
        icon: Icons.add_location_alt_outlined,
        onPressed: _openCityRegistration,
      ),
      onChanged: (selected) {
        if (selected != null) {
          setState(() => _selectedCityValue = selected);
        }
      },
    );
  }

  Widget _buildEmployeeSelect(List<FinancialEmployee> employees) {
    final options = <String, String>{
      _allEmployeesValue: 'Todos os vendedores',
      for (final employee in employees) employee.id: employee.name,
    };
    final value = options.containsKey(_selectedEmployeeValue)
        ? _selectedEmployeeValue
        : _allEmployeesValue;

    return AppFormSelectField<String>(
      label: 'Vendedor',
      value: value,
      options: options,
      sheetTitle: 'Selecione o vendedor',
      primaryColor: AppMenuColors.employees,
      action: AppFormSelectAction(
        label: 'Cadastrar novo funcionário',
        icon: Icons.person_add_alt_1_outlined,
        backgroundColor: AppMenuColors.employees,
        onPressed: _openEmployeeRegistration,
      ),
      onChanged: (selected) {
        if (selected != null) {
          setState(() => _selectedEmployeeValue = selected);
        }
      },
    );
  }

  Future<void> _openCityRegistration() async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(builder: (_) => const CityFormPage()),
    );
    if (!mounted) return;
    ref.invalidate(financialCitiesProvider);
  }

  Future<void> _openEmployeeRegistration() async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(builder: (_) => const EmployeeFormPage()),
    );
    if (!mounted) return;
    ref.invalidate(financialEmployeesProvider);
  }

  void _setRange(DateTime start, DateTime end) => setState(() {
        _startDateController.text = _formatDate(start);
        _endDateController.text = _formatDate(end);
      });

  DateTime? _parseDate(String value) {
    final match = RegExp(r'^(\d{2})/(\d{2})/(\d{4})$').firstMatch(value.trim());
    if (match == null) return null;
    final day = int.tryParse(match.group(1)!);
    final month = int.tryParse(match.group(2)!);
    final year = int.tryParse(match.group(3)!);
    if (day == null || month == null || year == null || year == 0) return null;
    final date = DateTime(year, month, day);
    if (date.year != year || date.month != month || date.day != day) return null;
    return date;
  }

  void _openResults(
    List<FinancialCity> cities,
    List<FinancialEmployee> employees,
  ) {
    final startDate = _parseDate(_startDateController.text);
    final endDate = _parseDate(_endDateController.text);
    if (startDate == null || endDate == null || endDate.isBefore(startDate)) {
      return;
    }
    final cityId = _selectedCityValue == _allCitiesValue
        ? null
        : _selectedCityValue;
    final employeeId = _selectedEmployeeValue == _allEmployeesValue
        ? null
        : _selectedEmployeeValue;
    var cityLabel = 'Todas as cidades';
    if (cityId != null) {
      for (final city in cities) {
        if (city.id == cityId) {
          cityLabel = city.displayName;
          break;
        }
      }
    }
    var employeeLabel = 'Todos os vendedors';
    if (employeeId != null) {
      for (final employee in employees) {
        if (employee.id == employeeId) {
          employeeLabel = employee.name;
          break;
        }
      }
    }

    final query = FinancialQuery(
      cityId: cityId,
      employeeId: employeeId,
      startDate: startDate,
      endDate: endDate,
      statuses: _selectedStatuses.map((status) => status.value).toList(),
    );
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => FinancialResultsPage(
          query: query,
          cityLabel: cityLabel,
          employeeLabel: employeeLabel,
        ),
      ),
    );
  }
}

class _StatusSelectField extends StatelessWidget {
  final Set<SaleStatus> selectedStatuses;
  final ValueChanged<Set<SaleStatus>> onChanged;

  const _StatusSelectField({
    required this.selectedStatuses,
    required this.onChanged,
  });

  String get _summary {
    if (selectedStatuses.isEmpty) return 'Nenhum status selecionado';
    if (selectedStatuses.length == SaleStatus.values.length) return 'Todas';
    if (selectedStatuses.length == 1) return selectedStatuses.first.label;
    return '${selectedStatuses.length} status selecionados';
  }

  @override
  Widget build(BuildContext context) => Material(
        color: const Color(0xFF424242),
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => _showOptions(context),
          child: InputDecorator(
            decoration: const InputDecoration(
              labelText: 'Status da Venda',
              labelStyle: TextStyle(color: Colors.white70),
              filled: true,
              fillColor: Color(0xFF424242),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide.none,
              ),
              suffixIcon: Icon(Icons.arrow_drop_down, color: Colors.white54),
            ),
            child: Text(
              _summary,
              style: const TextStyle(color: Colors.white),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      );

  Future<void> _showOptions(BuildContext context) async {
    var draft = Set<SaleStatus>.from(selectedStatuses);
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: const Color(0xFF383838),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setSheetState) {
          final selectAll = draft.length == SaleStatus.values.length;
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(context).height * 0.72,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white30,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Selecione o Status da Venda',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 5, bottom: 8),
                    child: Text(
                      'Escolha uma ou mais opções',
                      style: TextStyle(color: Colors.white60, fontSize: 12),
                    ),
                  ),
                  const Divider(color: Colors.white12),
                  CheckboxListTile(
                    value: selectAll,
                    activeColor: AppMenuColors.company,
                    checkColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                    title: const Text(
                      'Todas',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: const Text(
                      'Incluir todos os status de venda',
                      style: TextStyle(color: Colors.white60, fontSize: 12),
                    ),
                    onChanged: (value) => setSheetState(() {
                      draft = value == true
                          ? SaleStatus.values.toSet()
                          : <SaleStatus>{};
                    }),
                  ),
                  const Divider(color: Colors.white12),
                  Flexible(
                    child: ListView(
                      shrinkWrap: true,
                      children: SaleStatus.values.map((status) {
                        return CheckboxListTile(
                          value: draft.contains(status),
                          activeColor: status.color,
                          checkColor: Colors.white,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 4),
                          title: Text(
                            status.label,
                            style: TextStyle(
                              color: status.color,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onChanged: (value) => setSheetState(() {
                            if (value == true) {
                              draft.add(status);
                            } else {
                              draft.remove(status);
                            }
                          }),
                        );
                      }).toList(growable: false),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(sheetContext),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 13),
                          ),
                          child: const Text('CANCELAR'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            onChanged(Set<SaleStatus>.from(draft));
                            Navigator.pop(sheetContext);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppMenuColors.company,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 13),
                          ),
                          child: const Text('APLICAR'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DateInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final ValueChanged<String> onChanged;

  const _DateInputField({
    required this.label,
    required this.controller,
    required this.icon,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) => TextField(
        controller: controller,
        keyboardType: TextInputType.datetime,
        inputFormatters: const [_DateSlashInputFormatter()],
        onChanged: onChanged,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          hintText: 'DD/MM/AAAA',
          hintStyle: const TextStyle(color: Colors.white38),
          labelStyle: const TextStyle(color: Colors.white70),
          prefixIcon: Icon(icon, color: Colors.white54, size: 19),
          filled: true,
          fillColor: const Color(0xFF424242),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
      );
}

class _DateSlashInputFormatter extends TextInputFormatter {
  const _DateSlashInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    var digitsBeforeCursor = newValue.text
        .substring(
          0,
          newValue.selection.extentOffset
              .clamp(0, newValue.text.length)
              .toInt(),
        )
        .replaceAll(RegExp(r'\D'), '')
        .length;
    final oldDigits = oldValue.text.replaceAll(RegExp(r'\D'), '');
    final deletedOnlySeparator =
        oldDigits == digits && newValue.text.length < oldValue.text.length;

    if (deletedOnlySeparator && digits.isNotEmpty) {
      final oldCursor = oldValue.selection.extentOffset;
      final newCursor = newValue.selection.extentOffset;
      final removeAt = newCursor < oldCursor
          ? digitsBeforeCursor - 1
          : digitsBeforeCursor;
      if (removeAt >= 0 && removeAt < digits.length) {
        digits = digits.substring(0, removeAt) + digits.substring(removeAt + 1);
        digitsBeforeCursor = newCursor < oldCursor ? removeAt : digitsBeforeCursor;
      }
    }

    if (digits.length > 8) digits = digits.substring(0, 8);
    if (digitsBeforeCursor > digits.length) digitsBeforeCursor = digits.length;

    final formatted = _applyDateMask(digits);
    final cursor = _cursorAfterDigits(formatted, digitsBeforeCursor);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: cursor),
    );
  }

  String _applyDateMask(String digits) {
    if (digits.length < 2) return digits;
    final day = digits.substring(0, 2);
    if (digits.length == 2) return '$day/';

    final monthEnd = digits.length < 4 ? digits.length : 4;
    final month = digits.substring(2, monthEnd);
    if (digits.length < 4) return '$day/$month';

    final year = digits.substring(4);
    return '$day/$month/$year';
  }

  int _cursorAfterDigits(String formatted, int digitsToSkip) {
    if (digitsToSkip <= 0) return 0;
    var digitsSeen = 0;
    for (var index = 0; index < formatted.length; index++) {
      if (formatted[index] != '/') digitsSeen++;
      if (digitsSeen == digitsToSkip) {
        var position = index + 1;
        if (position < formatted.length && formatted[position] == '/') {
          position++;
        }
        return position;
      }
    }
    return formatted.length;
  }
}

class _QuickRangeButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _QuickRangeButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) => OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white70,
          side: BorderSide(color: Colors.white.withValues(alpha: 0.22)),
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
          visualDensity: VisualDensity.compact,
        ),
        child: Text(label, style: const TextStyle(fontSize: 12)),
      );
}

String _formatDate(DateTime date) =>
    '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
