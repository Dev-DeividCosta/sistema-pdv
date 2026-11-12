import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/forms/app_form_components.dart';
import '../../../../core/widgets/forms/app_form_layout.dart';
import '../../../employee/domain/entities/employee.dart';
import '../../../sale/domain/entities/sale_status.dart';
import '../../domain/entities/financial_query.dart';
import 'financial_results_page.dart';

class FinancialPeriodPage extends ConsumerStatefulWidget {
  final EmployeeEntity employee;

  const FinancialPeriodPage({
    super.key,
    required this.employee,
  });

  @override
  ConsumerState<FinancialPeriodPage> createState() => _FinancialPeriodPageState();
}

class _FinancialPeriodPageState extends ConsumerState<FinancialPeriodPage> {
  late final TextEditingController _startDateController;
  late final TextEditingController _endDateController;

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    _startDateController = TextEditingController();
    _endDateController = TextEditingController(
      text: _formatDate(DateTime(today.year, today.month, today.day)),
    );
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final startDate = _parseDate(_startDateController.text);
    final endDate = _parseDate(_endDateController.text);
    final canContinue =
        startDate != null && endDate != null && !endDate.isBefore(startDate);

    return AppFormLayout(
      title: 'Período do Relatório',
      appBarColor: AppMenuColors.company,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppFormSection(
            icon: Icons.person_outline,
            title: 'Funcionário selecionado',
            child: Text(
              widget.employee.apelido?.isNotEmpty == true
                  ? '${widget.employee.apelido} • ${widget.employee.nome}'
                  : widget.employee.nome,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
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
                if (startDate == null || endDate == null) ...[
                  const SizedBox(height: 8),
                  const Text(
                    'Digite as datas no formato DD/MM/AAAA.',
                    style: TextStyle(color: Colors.orangeAccent, fontSize: 12),
                  ),
                ] else if (endDate.isBefore(startDate)) ...[
                  const SizedBox(height: 8),
                  const Text(
                    'A data final deve ser igual ou posterior à data inicial.',
                    style: TextStyle(color: Colors.redAccent, fontSize: 12),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              onPressed: canContinue ? _openResults : null,
              icon: const Icon(Icons.query_stats_outlined),
              label: const Text('CONFIRMAR PERÍODO'),
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

  void _openResults() {
    final startDate = _parseDate(_startDateController.text);
    final endDate = _parseDate(_endDateController.text);
    if (startDate == null || endDate == null || endDate.isBefore(startDate)) {
      return;
    }

    final query = FinancialQuery(
      cityId: null,
      employeeId: widget.employee.id,
      startDate: startDate,
      endDate: endDate,
      statuses: [...SaleStatus.values.map((status) => status.value), 'voucher'],
    );

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => FinancialResultsPage(
          query: query,
          cityLabel: 'Todas as cidades',
          employeeLabel: widget.employee.nome,
        ),
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
    if (digits.length > 8) digits = digits.substring(0, 8);
    final formatted = _applyDateMask(digits);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  String _applyDateMask(String digits) {
    if (digits.length < 2) return digits;
    final day = digits.substring(0, 2);
    if (digits.length == 2) return '$day/';
    final monthEnd = digits.length < 4 ? digits.length : 4;
    final month = digits.substring(2, monthEnd);
    if (digits.length < 4) return '$day/$month';
    return '$day/$month/${digits.substring(4)}';
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
