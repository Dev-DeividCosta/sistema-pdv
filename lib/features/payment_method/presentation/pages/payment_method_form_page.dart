import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_form_utils.dart';
import '../../../../core/widgets/forms/app_form_layout.dart';
import '../../../../core/widgets/forms/app_form_status_card.dart';
import '../../../../core/widgets/forms/app_form_text_field.dart';
import '../../../../core/widgets/forms/form_mode.dart';
import '../../domain/entities/payment_method.dart';
import '../providers/payment_method_provider.dart';

class PaymentMethodFormPage extends ConsumerStatefulWidget {
  final PaymentMethodEntity? paymentMethod;
  final AppFormMode mode;

  const PaymentMethodFormPage({
    super.key,
    this.paymentMethod,
    this.mode = AppFormMode.create,
  });

  @override
  ConsumerState<PaymentMethodFormPage> createState() => _PaymentMethodFormPageState();
}

class _PaymentMethodFormPageState extends ConsumerState<PaymentMethodFormPage> {
  final _formKey = GlobalKey<FormState>();
  late AppFormMode _currentMode;
  late final TextEditingController _nomeController;
  late bool _isAtivo;

  bool get _isReadOnly => _currentMode.isReadOnly;

  @override
  void initState() {
    super.initState();
    _currentMode = widget.mode;
    _nomeController = TextEditingController(text: widget.paymentMethod?.nome ?? '');
    _isAtivo = widget.paymentMethod?.isAtivo ?? true;
  }

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }

  void _requestEdit() {
    if (!_isReadOnly) return;
    AppFormUtils.showEditModeDialog(
      context: context,
      onConfirm: () => setState(() => _currentMode = AppFormMode.edit),
    );
  }

  void _save() {
    if (_isReadOnly || !_formKey.currentState!.validate()) return;
    final current = widget.paymentMethod;
    final item = (_currentMode.isEditing && current != null)
        ? current.copyWith(nome: _nomeController.text.trim(), isAtivo: _isAtivo)
        : PaymentMethodEntity.createNew(nome: _nomeController.text.trim(), isAtivo: _isAtivo);
    ref.read(paymentMethodFormProvider.notifier).savePaymentMethod(item);
  }

  String get _titleText {
    switch (_currentMode) {
      case AppFormMode.create: return 'Nova Forma de Pagamento';
      case AppFormMode.edit: return 'Editar Forma de Pagamento';
      case AppFormMode.view: return 'Visualizar Forma de Pagamento';
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(paymentMethodFormProvider, (_, next) {
      next.whenOrNull(
        data: (_) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Forma de pagamento salva com sucesso!'), backgroundColor: Colors.green),
          );
          Navigator.pop(context);
        },
        error: (error, _) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao salvar forma de pagamento: $error'), backgroundColor: Colors.red),
          );
        },
      );
    });

    final isLoading = ref.watch(paymentMethodFormProvider).isLoading;
    return AppFormLayout(
      title: _titleText,
      appBarColor: AppMenuColors.paymentMethods,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppFormStatusCard(
              value: _isAtivo,
              readOnly: _isReadOnly,
              title: 'Status da Forma de Pagamento',
              subtitle: 'Esta forma está ${_isAtivo ? 'ativa' : 'inativa'}.',
              onChanged: (value) => setState(() => _isAtivo = value),
              onReadOnlyTap: _requestEdit,
            ),
            const SizedBox(height: 16),
            AppFormTextField(
              controller: _nomeController,
              label: 'Nome',
              readOnly: _isReadOnly,
              onReadOnlyTap: _requestEdit,
              validator: (value) => !_isReadOnly && (value == null || value.trim().isEmpty)
                  ? 'O nome é obrigatório'
                  : null,
            ),
            const SizedBox(height: 24),
            if (!_isReadOnly)
              FilledButton.icon(
                onPressed: isLoading ? null : _save,
                icon: isLoading
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.save_outlined),
                label: Text(isLoading ? 'SALVANDO...' : 'SALVAR'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppMenuColors.paymentMethods,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
