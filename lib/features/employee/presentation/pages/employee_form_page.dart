import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_form_utils.dart';
import '../../../../core/utils/cpf_validator.dart';
import '../../../../core/utils/input_formatters.dart';
import '../../../../core/widgets/forms/app_form_components.dart';
import '../../../../core/widgets/forms/app_form_layout.dart';
import '../../../../core/widgets/forms/app_form_status_card.dart';
import '../../../../core/widgets/forms/app_form_text_field.dart';
import '../../../../core/widgets/forms/form_mode.dart';
import '../../domain/entities/employee.dart';
import '../providers/employee_provider.dart';

class EmployeeFormPage extends ConsumerStatefulWidget {
  final EmployeeEntity? employee;
  final AppFormMode mode;

  const EmployeeFormPage({
    super.key,
    this.employee,
    this.mode = AppFormMode.create,
  });

  @override
  ConsumerState<EmployeeFormPage> createState() => _EmployeeFormPageState();
}

class _EmployeeFormPageState extends ConsumerState<EmployeeFormPage> {
  final _formKey = GlobalKey<FormState>();
  
  late AppFormMode _currentMode;
  late final TextEditingController _nomeController;
  late final TextEditingController _apelidoController;
  late final TextEditingController _cpfController;
  late bool _isAtivo;

  bool get _isReadOnly => _currentMode.isReadOnly;

  @override
  void initState() {
    super.initState();
    _currentMode = widget.mode;
    
    final e = widget.employee;
    _nomeController = TextEditingController(text: e?.nome ?? '');
    _apelidoController = TextEditingController(text: e?.apelido ?? '');
    _cpfController = TextEditingController(text: e?.cpf ?? '');
    _isAtivo = e?.isAtivo ?? true;
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _apelidoController.dispose();
    _cpfController.dispose();
    super.dispose();
  }

  String? _cpfValidator(String? value) =>
      _isReadOnly || value == null || value.trim().isEmpty
          ? null
          : CpfValidator.isValid(value)
              ? null
              : 'CPF inválido';

  String? _optional(TextEditingController c) =>
      c.text.trim().isEmpty ? null : c.text.trim();

  void _requestEdit() {
    if (!_isReadOnly) return;
    AppFormUtils.showEditModeDialog(
      context: context,
      onConfirm: () => setState(() => _currentMode = AppFormMode.edit),
    );
  }

  void _save() {
    if (_isReadOnly || !_formKey.currentState!.validate()) return;
    
    final current = widget.employee;
    final employeeToSave = (_currentMode.isEditing && current != null)
        ? current.copyWith(
            nome: _nomeController.text.trim(),
            apelido: _optional(_apelidoController),
            cpf: _optional(_cpfController),
            isAtivo: _isAtivo,
          )
        : EmployeeEntity.createNew(
            nome: _nomeController.text.trim(),
            apelido: _optional(_apelidoController),
            cpf: _optional(_cpfController),
            isAtivo: _isAtivo,
          );
          
    ref.read(employeeFormProvider.notifier).saveEmployee(employeeToSave);
  }

  String get _titleText {
    switch (_currentMode) {
      case AppFormMode.create: return 'Novo Funcionário';
      case AppFormMode.edit: return 'Editar Funcionário';
      case AppFormMode.view: return 'Visualizar Funcionário';
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(employeeFormProvider, (_, next) {
      next.whenOrNull(
        data: (_) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Funcionário salvo com sucesso!'), backgroundColor: Colors.green),
          );
          Navigator.pop(context);
        },
        error: (error, _) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao salvar funcionário: $error'), backgroundColor: Colors.red),
          );
        },
      );
    });

    final loading = ref.watch(employeeFormProvider).isLoading;

    return AppFormLayout(
      title: _titleText,
      appBarColor: AppMenuColors.employees,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppFormStatusCard(
              value: _isAtivo,
              readOnly: _isReadOnly,
              title: 'Status do Funcionário',
              subtitle: 'Este funcionário está ${_isAtivo ? 'ativo' : 'inativo'}.',
              onChanged: (val) => setState(() => _isAtivo = val),
              onReadOnlyTap: _requestEdit,
            ),
            const SizedBox(height: 16),
            AppFormSection(
              icon: Icons.badge_outlined,
              title: 'Informações do Funcionário',
              child: Column(
                children: [
                  AppFormTextField(
                    controller: _nomeController,
                    label: 'Nome completo',
                    readOnly: _isReadOnly,
                    onReadOnlyTap: _requestEdit,
                    validator: (val) => !_isReadOnly && (val == null || val.trim().isEmpty)
                        ? 'O nome completo é obrigatório' : null,
                  ),
                  const SizedBox(height: 12),
                  AppFormTextField(
                    controller: _apelidoController,
                    label: 'Apelido',
                    readOnly: _isReadOnly,
                    onReadOnlyTap: _requestEdit,
                  ),
                  const SizedBox(height: 12),
                  AppFormTextField(
                    controller: _cpfController,
                    label: 'CPF',
                    readOnly: _isReadOnly,
                    onReadOnlyTap: _requestEdit,
                    keyboardType: TextInputType.number,
                    inputFormatters: [CpfInputFormatter()],
                    validator: _cpfValidator,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            AppFormActions(
              readOnly: _isReadOnly,
              loading: loading,
              saveLabel: _currentMode.isEditing ? 'ATUALIZAR' : 'SALVAR',
              onCancel: () => Navigator.pop(context),
              onSave: _save,
            ),
          ],
        ),
      ),
    );
  }
}