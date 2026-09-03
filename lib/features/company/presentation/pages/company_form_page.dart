import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_form_utils.dart';
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
import '../../domain/entities/company.dart';
import '../providers/company_provider.dart';

class CompanyFormPage extends ConsumerStatefulWidget {
  final CompanyEntity? company;
  final AppFormMode mode;

  const CompanyFormPage({
    super.key,
    this.company,
    this.mode = AppFormMode.create,
  });

  @override
  ConsumerState<CompanyFormPage> createState() => _CompanyFormPageState();
}

class _CompanyFormPageState extends ConsumerState<CompanyFormPage> {
  final _formKey = GlobalKey<FormState>();
  late AppFormMode _currentMode;
  late final Map<String, TextEditingController> _controllers;
  late bool _isAtivo;
  String? _selectedCityId;
  String? _hydratedCompanyId;

  bool get _isReadOnly => _currentMode.isReadOnly;
  TextEditingController _controller(String key) => _controllers[key]!;

  @override
  void initState() {
    super.initState();
    _currentMode = widget.mode;
    _isAtivo = widget.company?.isAtivo ?? true;
    _controllers = {
      'nomeEmpresa': TextEditingController(text: widget.company?.razaoSocial ?? ''),
      'cnpj': TextEditingController(text: widget.company?.cnpj ?? ''),
      'telefone': TextEditingController(text: widget.company?.telefone ?? ''),
      'email': TextEditingController(text: widget.company?.email ?? ''),
      'endereco': TextEditingController(text: widget.company?.endereco ?? ''),
      'numero': TextEditingController(text: widget.company?.numero ?? ''),
      'complemento': TextEditingController(text: widget.company?.complemento ?? ''),
      'bairro': TextEditingController(text: widget.company?.bairro ?? ''),
      'cep': TextEditingController(text: widget.company?.cep ?? ''),
    };
    _hydratedCompanyId = widget.company?.id;
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _hydrate(CompanyEntity? company) {
    if (!mounted || company == null || _hydratedCompanyId == company.id) return;
    _hydratedCompanyId = company.id;
    final values = {
      'nomeEmpresa': company.razaoSocial,
      'cnpj': company.cnpj,
      'telefone': company.telefone,
      'email': company.email,
      'endereco': company.endereco,
      'numero': company.numero,
      'complemento': company.complemento,
      'bairro': company.bairro,
      'cep': company.cep,
    };
    for (final entry in values.entries) {
      _controller(entry.key).text = entry.value ?? '';
    }
    _isAtivo = company.isAtivo;
  }

  void _requestEdit() {
    if (!_isReadOnly) return;
    AppFormUtils.showEditModeDialog(
      context: context,
      onConfirm: () => setState(() => _currentMode = AppFormMode.edit),
    );
  }

  String? _validateEmail(String? value) {
    if (_isReadOnly || value == null || value.trim().isEmpty) return null;
    return EmailValidator.isValid(value) ? null : 'E-mail inválido';
  }

  String? _optional(String key) {
    final value = _controller(key).text.trim();
    return value.isEmpty ? null : value;
  }

  void _save() {
    if (_isReadOnly || !_formKey.currentState!.validate()) return;
    final current = ref.read(companyProvider).valueOrNull ?? widget.company;
    final cities = ref.read(citiesStreamProvider).valueOrNull ?? const <CityEntity>[];
    final selectedCity = _selectedCityId == null
        ? null
        : cities.where((city) => city.id == _selectedCityId).firstOrNull;
    final values = {
      'razaoSocial': _controller('nomeEmpresa').text.trim(),
      'cnpj': _optional('cnpj'),
      'telefone': _optional('telefone'),
      'email': _optional('email'),
      'endereco': _optional('endereco'),
      'numero': _optional('numero'),
      'complemento': _optional('complemento'),
      'bairro': _optional('bairro'),
      'cidade': selectedCity?.nome ?? current?.cidade,
      'uf': selectedCity?.estado ?? current?.uf,
      'cep': _optional('cep'),
    };
    final company = current == null
        ? CompanyEntity.createNew(
            razaoSocial: values['razaoSocial']!,
            nomeFantasia: null,
            cnpj: values['cnpj'],
            telefone: values['telefone'],
            email: values['email'],
            endereco: values['endereco'],
            numero: values['numero'],
            complemento: values['complemento'],
            bairro: values['bairro'],
            cidade: values['cidade'],
            uf: values['uf'],
            cep: values['cep'],
            isAtivo: _isAtivo,
          )
        : current.copyWith(
            razaoSocial: values['razaoSocial'],
            nomeFantasia: null,
            cnpj: values['cnpj'],
            telefone: values['telefone'],
            email: values['email'],
            endereco: values['endereco'],
            numero: values['numero'],
            complemento: values['complemento'],
            bairro: values['bairro'],
            cidade: values['cidade'],
            uf: values['uf'],
            cep: values['cep'],
            isAtivo: _isAtivo,
          );
    ref.read(companyFormProvider.notifier).saveCompany(company);
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

  Widget _buildCityField(CompanyEntity? company) {
    final citiesAsync = ref.watch(citiesStreamProvider);
    return citiesAsync.when(
      loading: () => const InputDecorator(
        decoration: InputDecoration(labelText: 'Cidade / UF'),
        child: LinearProgressIndicator(),
      ),
      error: (error, stack) => InputDecorator(
        decoration: const InputDecoration(labelText: 'Cidade / UF'),
        child: Text('Erro ao carregar cidades: $error'),
      ),
      data: (cities) {
        final activeCities = cities.where((city) => city.isAtivo).toList()
          ..sort((a, b) => a.nome.toLowerCase().compareTo(b.nome.toLowerCase()));
        final options = <String, String>{
          for (final CityEntity city in activeCities) city.id: '${city.nome} - ${city.estado}',
        };
        final matchingCity = activeCities.where(
          (city) => city.nome.toLowerCase() == company?.cidade?.toLowerCase() &&
              city.estado.toUpperCase() == company?.uf?.toUpperCase(),
        ).firstOrNull;
        final selectedCityId = options.containsKey(_selectedCityId)
            ? _selectedCityId
            : matchingCity?.id;
        return AppFormSelectField<String>(
          label: 'Cidade / UF',
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

  String get _titleText => switch (_currentMode) {
        AppFormMode.create => 'Dados da Empresa',
        AppFormMode.edit => 'Editar Dados da Empresa',
        AppFormMode.view => 'Visualizar Dados da Empresa',
      };

  @override
  Widget build(BuildContext context) {
    final companyAsync = ref.watch(companyProvider);
    final company = companyAsync.valueOrNull;
    if (company != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _hydrate(company));
    }
    ref.listen(companyFormProvider, (_, next) {
      next.whenOrNull(
        data: (_) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Dados da empresa salvos com sucesso!'), backgroundColor: Colors.green,
          ));
          Navigator.pop(context);
        },
        error: (error, _) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Erro ao salvar dados da empresa: $error'), backgroundColor: Colors.red,
          ));
        },
      );
    });
    final loading = ref.watch(companyFormProvider).isLoading;

    return AppFormLayout(
      title: _titleText,
      appBarColor: AppMenuColors.company,
      child: Form(
        key: _formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          AppFormStatusCard(
            value: _isAtivo, readOnly: _isReadOnly,
            title: 'Status da Empresa',
            subtitle: 'Esta empresa está ${_isAtivo ? 'ativa' : 'inativa'}.',
            onChanged: (value) => setState(() => _isAtivo = value),
            onReadOnlyTap: _requestEdit,
          ),
          const SizedBox(height: 16),
          AppFormSection(icon: Icons.business_outlined, title: 'Identificação', child: Column(children: [
            AppFormTextField(
              controller: _controller('nomeEmpresa'),
              label: 'Nome da empresa',
              readOnly: _isReadOnly,
              onReadOnlyTap: _requestEdit,
              validator: (value) => !_isReadOnly && (value == null || value.trim().isEmpty)
                  ? 'O nome da empresa é obrigatório'
                  : null,
            ),
            const SizedBox(height: 12),
            AppFormTextField(
              controller: _controller('cnpj'),
              label: 'CNPJ',
              readOnly: _isReadOnly,
              onReadOnlyTap: _requestEdit,
              keyboardType: TextInputType.number,
              inputFormatters: [CnpjInputFormatter()],
            ),
          ])),
          const SizedBox(height: 16),
          AppFormSection(icon: Icons.contact_phone_outlined, title: 'Contato', child: Column(children: [
            AppFormTextField(
              controller: _controller('telefone'),
              label: 'Telefone',
              readOnly: _isReadOnly,
              onReadOnlyTap: _requestEdit,
              keyboardType: TextInputType.phone,
              inputFormatters: [TelefoneInputFormatter()],
            ),
            const SizedBox(height: 12),
            AppFormTextField(
              controller: _controller('email'),
              label: 'E-mail',
              readOnly: _isReadOnly,
              onReadOnlyTap: _requestEdit,
              keyboardType: TextInputType.emailAddress,
              validator: _validateEmail,
            ),
          ])),
          const SizedBox(height: 16),
          AppFormSection(icon: Icons.location_on_outlined, title: 'Endereço', child: Column(children: [
            AppFormTextField(controller: _controller('endereco'), label: 'Logradouro', readOnly: _isReadOnly, onReadOnlyTap: _requestEdit),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: AppFormTextField(
                controller: _controller('numero'),
                label: 'Número',
                readOnly: _isReadOnly,
                onReadOnlyTap: _requestEdit,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              )),
              const SizedBox(width: 12),
              Expanded(child: AppFormTextField(controller: _controller('complemento'), label: 'Complemento', readOnly: _isReadOnly, onReadOnlyTap: _requestEdit)),
            ]),
            const SizedBox(height: 12),
            AppFormTextField(controller: _controller('bairro'), label: 'Bairro', readOnly: _isReadOnly, onReadOnlyTap: _requestEdit),
            const SizedBox(height: 12),
            _buildCityField(company),
            const SizedBox(height: 12),
            AppFormTextField(
              controller: _controller('cep'),
              label: 'CEP',
              readOnly: _isReadOnly,
              onReadOnlyTap: _requestEdit,
              keyboardType: TextInputType.number,
              inputFormatters: [CepInputFormatter()],
            ),
          ])),
          const SizedBox(height: 24),
          AppFormActions(readOnly: _isReadOnly, loading: loading, saveLabel: _currentMode.isEditing ? 'ATUALIZAR' : 'SALVAR', onCancel: () => Navigator.pop(context), onSave: _save),
        ]),
      ),
    );
  }
}
