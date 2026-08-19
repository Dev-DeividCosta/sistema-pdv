import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/app_form_utils.dart';
import '../../../../core/widgets/forms/app_form_components.dart';
import '../../../../core/widgets/forms/app_form_status_card.dart';
import '../../../../core/widgets/forms/app_form_layout.dart';
import '../../../../core/widgets/forms/app_form_select_field.dart';
import '../../../../core/widgets/forms/app_form_text_field.dart';
import '../../../../core/widgets/forms/form_mode.dart';
import '../../domain/entities/city.dart';
import '../providers/city_form_provider.dart';

class CityFormPage extends ConsumerStatefulWidget {
  final CityEntity? city;
  final AppFormMode mode;

  const CityFormPage({
    super.key,
    this.city,
    this.mode = AppFormMode.create,
  });

  @override
  ConsumerState<CityFormPage> createState() => _CityFormPageState();
}

class _CityFormPageState extends ConsumerState<CityFormPage> {
  final _formKey = GlobalKey<FormState>();
  
  late AppFormMode _currentMode;
  late final TextEditingController _nomeController;
  String? _estadoSelecionado;
  late bool _isAtivo;

  bool get _isReadOnly => _currentMode.isReadOnly;

  @override
  void initState() {
    super.initState();
    _currentMode = widget.mode;
    
    final city = widget.city;
    _nomeController = TextEditingController(text: city?.nome ?? '');

    final estadoInicial = city?.estado;
    if (estadoInicial != null && AppConstants.estadosBrasil.containsKey(estadoInicial)) {
      _estadoSelecionado = estadoInicial;
    }

    _isAtivo = city?.isAtivo ?? true;
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
    
    final current = widget.city;
    final cityToSave = (_currentMode.isEditing && current != null)
        ? current.copyWith(
            nome: _nomeController.text.trim(),
            estado: _estadoSelecionado ?? '',
            isAtivo: _isAtivo,
          )
        : CityEntity.createNew(
            nome: _nomeController.text.trim(),
            estado: _estadoSelecionado ?? '',
            isAtivo: _isAtivo,
          );
          
    ref.read(cityFormProvider.notifier).saveCity(cityToSave);
  }

  String get _titleText {
    switch (_currentMode) {
      case AppFormMode.create: return 'Nova Cidade';
      case AppFormMode.edit: return 'Editar Cidade';
      case AppFormMode.view: return 'Visualizar Cidade';
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(cityFormProvider, (_, next) {
      next.whenOrNull(
        data: (_) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cidade salva com sucesso!'), backgroundColor: Colors.green),
          );
          Navigator.pop(context);
        },
      );
    });

    final loading = ref.watch(cityFormProvider).isLoading;

    return AppFormLayout(
      title: _titleText,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppFormStatusCard(
              value: _isAtivo,
              readOnly: _isReadOnly,
              title: 'Status da Cidade',
              subtitle: 'Esta cidade está ${_isAtivo ? 'ativa' : 'inativa'}.',
              onChanged: (val) => setState(() => _isAtivo = val),
              onReadOnlyTap: _requestEdit,
            ),
            const SizedBox(height: 16),
            AppFormSection(
              icon: Icons.location_city,
              title: 'Informações da Cidade',
              child: Column(
                children: [
                  AppFormTextField(
                    controller: _nomeController,
                    label: 'Nome',
                    readOnly: _isReadOnly,
                    onReadOnlyTap: _requestEdit,
                    validator: (val) => !_isReadOnly && (val == null || val.trim().isEmpty) 
                        ? 'O nome é obrigatório' : null,
                  ),
                  const SizedBox(height: 12),
                  AppFormSelectField<String>(
                    label: 'Estado',
                    value: _estadoSelecionado,
                    options: AppConstants.estadosBrasil,
                    readOnly: _isReadOnly,
                    onReadOnlyTap: _requestEdit,
                    sheetTitle: 'Selecione o Estado',
                    onChanged: (val) => setState(() => _estadoSelecionado = val),
                    validator: (val) => !_isReadOnly && (val == null || val.isEmpty) 
                        ? 'O estado é obrigatório' : null,
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