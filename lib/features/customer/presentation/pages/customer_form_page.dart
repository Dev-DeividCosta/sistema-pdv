import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_form_utils.dart';
import '../../../../core/utils/cpf_validator.dart';
import '../../../../core/utils/email_validator.dart';
import '../../../../core/utils/input_formatters.dart';
import '../../../../core/widgets/forms/app_form_components.dart';
import '../../../../core/widgets/forms/app_form_layout.dart';
import '../../../../core/widgets/forms/app_form_select_field.dart';
import '../../../../core/widgets/forms/app_form_status_card.dart';
import '../../../../core/widgets/forms/app_form_text_field.dart';
import '../../../../core/widgets/forms/form_mode.dart';
import '../../../city/domain/entities/city.dart';
import '../../../city/presentation/pages/city_form_page.dart';
import '../../../city/presentation/providers/city_form_provider.dart';
import '../../domain/entities/customer.dart';
import '../providers/customer_form_provider.dart';

class CustomerFormPage extends ConsumerStatefulWidget {
  final CustomerEntity? customer;
  final AppFormMode mode;

  const CustomerFormPage({
    super.key,
    this.customer,
    this.mode = AppFormMode.create,
  });

  @override
  ConsumerState<CustomerFormPage> createState() => _CustomerFormPageState();
}

class _CustomerFormPageState extends ConsumerState<CustomerFormPage> {
  final _formKey = GlobalKey<FormState>();
  late AppFormMode _currentMode;
  late final TextEditingController _nomeController;
  late final TextEditingController _apelidoController;
  late final TextEditingController _cpfController;
  late final TextEditingController _ruaController;
  late final TextEditingController _numeroController;
  late final TextEditingController _complementoController;
  late final TextEditingController _bairroController;
  late final TextEditingController _cepController;
  late final TextEditingController _telefoneFixoController;
  late final TextEditingController _celularController;
  late final TextEditingController _emailController;
  late final TextEditingController _observacoesController;
  String? _selectedCityId;
  late bool _isAtivo;

  bool get _isReadOnly => _currentMode.isReadOnly;

  @override
  void initState() {
    super.initState();
    _currentMode = widget.mode;
    final customer = widget.customer;
    _nomeController = TextEditingController(text: customer?.nome ?? '');
    _apelidoController = TextEditingController(text: customer?.apelido ?? '');
    _cpfController = TextEditingController(text: customer?.cpf ?? '');
    _ruaController = TextEditingController(text: customer?.rua ?? '');
    _numeroController = TextEditingController(text: customer?.numero ?? '');
    _complementoController = TextEditingController(text: customer?.complemento ?? '');
    _bairroController = TextEditingController(text: customer?.bairro ?? '');
    _cepController = TextEditingController(text: customer?.cep ?? '');
    _telefoneFixoController = TextEditingController(text: customer?.telefoneFixo ?? '');
    _celularController = TextEditingController(text: customer?.celular ?? '');
    _emailController = TextEditingController(text: customer?.email ?? '');
    _observacoesController = TextEditingController(text: customer?.observacoes ?? '');
    _selectedCityId = customer?.cityId;
    _isAtivo = customer?.isAtivo ?? true;
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _apelidoController.dispose();
    _cpfController.dispose();
    _ruaController.dispose();
    _numeroController.dispose();
    _complementoController.dispose();
    _bairroController.dispose();
    _cepController.dispose();
    _telefoneFixoController.dispose();
    _celularController.dispose();
    _emailController.dispose();
    _observacoesController.dispose();
    super.dispose();
  }

  void _requestEdit() {
    if (!_isReadOnly) return;
    AppFormUtils.showEditModeDialog(
      context: context,
      onConfirm: () => setState(() => _currentMode = AppFormMode.edit),
    );
  }

  String? _validateCpf(String? value) {
    if (_isReadOnly || value == null || value.trim().isEmpty) return null;
    return CpfValidator.isValid(value) ? null : 'CPF inválido';
  }

  String? _validateEmail(String? value) {
    if (_isReadOnly || value == null || value.trim().isEmpty) return null;
    return EmailValidator.isValid(value) ? null : 'E-mail inválido';
  }

  String? _optionalValue(TextEditingController controller) {
    final value = controller.text.trim();
    return value.isEmpty ? null : value;
  }

  void _save() {
    if (_isReadOnly || !_formKey.currentState!.validate()) return;
    final current = widget.customer;
    final customerToSave = (_currentMode.isEditing && current != null)
        ? current.copyWith(
            nome: _nomeController.text.trim(),
            apelido: _optionalValue(_apelidoController),
            cpf: _optionalValue(_cpfController),
            rua: _optionalValue(_ruaController),
            numero: _optionalValue(_numeroController),
            complemento: _optionalValue(_complementoController),
            bairro: _optionalValue(_bairroController),
            cityId: _selectedCityId,
            cep: _optionalValue(_cepController),
            telefoneFixo: _optionalValue(_telefoneFixoController),
            celular: _optionalValue(_celularController),
            email: _optionalValue(_emailController),
            observacoes: _optionalValue(_observacoesController),
            isAtivo: _isAtivo,
          )
        : CustomerEntity.createNew(
            nome: _nomeController.text.trim(),
            apelido: _optionalValue(_apelidoController),
            cpf: _optionalValue(_cpfController),
            rua: _optionalValue(_ruaController),
            numero: _optionalValue(_numeroController),
            complemento: _optionalValue(_complementoController),
            bairro: _optionalValue(_bairroController),
            cityId: _selectedCityId,
            cep: _optionalValue(_cepController),
            telefoneFixo: _optionalValue(_telefoneFixoController),
            celular: _optionalValue(_celularController),
            email: _optionalValue(_emailController),
            observacoes: _optionalValue(_observacoesController),
            isAtivo: _isAtivo,
          );
    ref.read(customerFormProvider.notifier).saveCustomer(customerToSave);
  }

  Future<void> _openCityRegistration() async {
    if (_isReadOnly) return;

    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CityFormPage()),
    );

    if (!mounted) return;
    ref.invalidate(citiesStreamProvider);
  }

  String get _titleText {
    switch (_currentMode) {
      case AppFormMode.create:
        return 'Novo Cliente';
      case AppFormMode.edit:
        return 'Editar Cliente';
      case AppFormMode.view:
        return 'Visualizar Cliente';
    }
  }

  Widget _buildCityField() {
    final citiesAsync = ref.watch(citiesStreamProvider);
    return citiesAsync.when(
      loading: () => const InputDecorator(
        decoration: InputDecoration(labelText: 'Cidade'),
        child: LinearProgressIndicator(),
      ),
      error: (error, stack) => InputDecorator(
        decoration: const InputDecoration(labelText: 'Cidade'),
        child: Text('Erro ao carregar cidades: $error'),
      ),
      data: (cities) {
        final activeCities = cities.where((city) => city.isAtivo).toList()
          ..sort((a, b) => a.nome.toLowerCase().compareTo(b.nome.toLowerCase()));
        final options = <String, String>{
          for (final CityEntity city in activeCities) city.id: '${city.nome} - ${city.estado}',
        };
        final selectedCityId = options.containsKey(_selectedCityId) ? _selectedCityId : null;
        return AppFormSelectField<String>(
          label: 'Cidade',
          value: selectedCityId,
          options: options,
          readOnly: _isReadOnly,
          onReadOnlyTap: _requestEdit,
          sheetTitle: 'Selecione a Cidade',
          onChanged: (value) => setState(() => _selectedCityId = value),
          action: _isReadOnly
              ? null
              : AppFormSelectAction(
                  label: 'Cadastrar nova cidade',
                  icon: Icons.add_location_alt_outlined,
                  onPressed: _openCityRegistration,
                ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(customerFormProvider, (_, next) {
      next.whenOrNull(
        data: (_) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cliente salvo com sucesso!'), backgroundColor: Colors.green),
          );
          Navigator.pop(context);
        },
        error: (error, stack) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao salvar cliente: $error'), backgroundColor: Colors.red),
          );
        },
      );
    });

    final loading = ref.watch(customerFormProvider).isLoading;
    return AppFormLayout(
      title: _titleText,
      appBarColor: AppMenuColors.customer,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppFormStatusCard(
              value: _isAtivo,
              readOnly: _isReadOnly,
              title: 'Status do Cliente',
              subtitle: 'Este cliente está ${_isAtivo ? 'ativo' : 'inativo'}.',
              onChanged: (value) => setState(() => _isAtivo = value),
              onReadOnlyTap: _requestEdit,
            ),
            const SizedBox(height: 16),
            AppFormSection(
              icon: Icons.person_outline,
              title: 'Informações do Cliente',
              child: Column(
                children: [
                  AppFormTextField(
                    controller: _nomeController,
                    label: 'Nome',
                    readOnly: _isReadOnly,
                    onReadOnlyTap: _requestEdit,
                    validator: (value) => !_isReadOnly && (value == null || value.trim().isEmpty)
                        ? 'O nome é obrigatório'
                        : null,
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
                    validator: _validateCpf,
                  ),
                  const SizedBox(height: 12),
                  AppFormTextField(
                    controller: _observacoesController,
                    label: 'Observações',
                    readOnly: _isReadOnly,
                    onReadOnlyTap: _requestEdit,
                    maxLines: 4,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            AppFormSection(
              icon: Icons.location_on_outlined,
              title: 'Endereço do Cliente',
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: AppFormTextField(
                          controller: _ruaController,
                          label: 'Rua',
                          readOnly: _isReadOnly,
                          onReadOnlyTap: _requestEdit,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppFormTextField(
                          controller: _numeroController,
                          label: 'Nº',
                          readOnly: _isReadOnly,
                          onReadOnlyTap: _requestEdit,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  AppFormTextField(
                    controller: _complementoController,
                    label: 'Complemento',
                    readOnly: _isReadOnly,
                    onReadOnlyTap: _requestEdit,
                  ),
                  const SizedBox(height: 12),
                  AppFormTextField(
                    controller: _bairroController,
                    label: 'Bairro',
                    readOnly: _isReadOnly,
                    onReadOnlyTap: _requestEdit,
                  ),
                  const SizedBox(height: 12),
                  _buildCityField(),
                  const SizedBox(height: 12),
                  AppFormTextField(
                    controller: _cepController,
                    label: 'CEP',
                    readOnly: _isReadOnly,
                    onReadOnlyTap: _requestEdit,
                    keyboardType: TextInputType.number,
                    inputFormatters: [CepInputFormatter()],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            AppFormSection(
              icon: Icons.phone_outlined,
              title: 'Contato do Cliente',
              child: Column(
                children: [
                  AppFormTextField(
                    controller: _telefoneFixoController,
                    label: 'Telefone Fixo',
                    readOnly: _isReadOnly,
                    onReadOnlyTap: _requestEdit,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [TelefoneFixoInputFormatter()],
                  ),
                  const SizedBox(height: 12),
                  AppFormTextField(
                    controller: _celularController,
                    label: 'Celular',
                    readOnly: _isReadOnly,
                    onReadOnlyTap: _requestEdit,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [CelularInputFormatter()],
                  ),
                  const SizedBox(height: 12),
                  AppFormTextField(
                    controller: _emailController,
                    label: 'E-mail',
                    readOnly: _isReadOnly,
                    onReadOnlyTap: _requestEdit,
                    keyboardType: TextInputType.emailAddress,
                    validator: _validateEmail,
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
