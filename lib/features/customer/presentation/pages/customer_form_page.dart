import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/customer.dart';
import '../providers/customer_form_provider.dart';
import '../../../../core/utils/cpf_validator.dart';
import '../../../../core/utils/email_validator.dart';
import '../../../../core/utils/input_formatters.dart';

enum CustomerFormMode { create, view, edit }

class CustomerFormPage extends ConsumerStatefulWidget {
  final CustomerEntity? customer;
  final CustomerFormMode mode;

  const CustomerFormPage({
    super.key,
    this.customer,
    this.mode = CustomerFormMode.create,
  });

  @override
  ConsumerState<CustomerFormPage> createState() => _CustomerFormPageState();
}

class _CustomerFormPageState extends ConsumerState<CustomerFormPage> {
  final _formKey = GlobalKey<FormState>();

  late CustomerFormMode _currentMode; // Estado interno para controlar o modo
  late bool _isAtivo;
  String? _selectedUF;

  late final TextEditingController _nomeController;
  late final TextEditingController _apelidoController;
  late final TextEditingController _cpfController;
  late final TextEditingController _ruaController;
  late final TextEditingController _numeroController;
  late final TextEditingController _complementoController;
  late final TextEditingController _bairroController;
  late final TextEditingController _cidadeController;
  late final TextEditingController _cepController;
  late final TextEditingController _telefoneFixoController;
  late final TextEditingController _celularController;
  late final TextEditingController _emailController;
  late final TextEditingController _observacoesController;

  final List<String> _estadosBrasil = const [
    'AC', 'AL', 'AP', 'AM', 'BA', 'CE', 'DF', 'ES', 'GO', 'MA', 'MT', 'MS', 'MG',
    'PA', 'PB', 'PR', 'PE', 'PI', 'RJ', 'RN', 'RS', 'RO', 'RR', 'SC', 'SP', 'SE', 'TO'
  ];

  bool get _isReadOnly => _currentMode == CustomerFormMode.view;

  @override
  void initState() {
    super.initState();
    final c = widget.customer;
    
    _currentMode = widget.mode; // Inicializa com o modo passado para a página

    _isAtivo = c?.isAtivo ?? true;
    _selectedUF = c?.uf;

    _nomeController = TextEditingController(text: c?.nome ?? '');
    _apelidoController = TextEditingController(text: c?.apelido ?? '');
    _cpfController = TextEditingController(text: CpfInputFormatter.format(c?.cpf ?? ''));
    _ruaController = TextEditingController(text: c?.rua ?? '');
    _numeroController = TextEditingController(text: c?.numero ?? '');
    _complementoController = TextEditingController(text: c?.complemento ?? '');
    _bairroController = TextEditingController(text: c?.bairro ?? '');
    _cidadeController = TextEditingController(text: c?.cidade ?? '');
    _cepController = TextEditingController(text: CepInputFormatter.format(c?.cep ?? ''));
    _telefoneFixoController = TextEditingController(text: TelefoneFixoInputFormatter.format(c?.telefoneFixo ?? ''));
    _celularController = TextEditingController(text: CelularInputFormatter.format(c?.celular ?? ''));
    _emailController = TextEditingController(text: c?.email ?? '');
    _observacoesController = TextEditingController(text: c?.observacoes ?? '');
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
    _cidadeController.dispose();
    _cepController.dispose();
    _telefoneFixoController.dispose();
    _celularController.dispose();
    _emailController.dispose();
    _observacoesController.dispose();
    super.dispose();
  }

  String? _validarCPF(String? value) {
    if (_isReadOnly || value == null || value.trim().isEmpty) {
      return null;
    }

    if (!CpfValidator.isValid(value)) {
      return 'CPF inválido';
    }

    return null;
  }

  String? _validarEmail(String? value) {
    if (_isReadOnly || value == null || value.trim().isEmpty) {
      return null;
    }

    if (!EmailValidator.isValid(value)) {
      return 'E-mail inválido';
    }

    return null;
  }

  void _salvarCliente() {
    if (_isReadOnly) return;

    if (_formKey.currentState!.validate()) {
      final CustomerEntity clienteParaSalvar;

      // Usando _currentMode para saber se é edição
      if (_currentMode == CustomerFormMode.edit && widget.customer != null) {
        clienteParaSalvar = widget.customer!.copyWith(
          nome: _nomeController.text.trim(),
          apelido: _apelidoController.text.trim().isEmpty ? null : _apelidoController.text.trim(),
          cpf: _cpfController.text.trim().isEmpty ? null : _cpfController.text.trim(),
          rua: _ruaController.text.trim().isEmpty ? null : _ruaController.text.trim(),
          numero: _numeroController.text.trim().isEmpty ? null : _numeroController.text.trim(),
          complemento: _complementoController.text.trim().isEmpty ? null : _complementoController.text.trim(),
          bairro: _bairroController.text.trim().isEmpty ? null : _bairroController.text.trim(),
          cidade: _cidadeController.text.trim().isEmpty ? null : _cidadeController.text.trim(),
          uf: _selectedUF,
          cep: _cepController.text.trim().isEmpty ? null : _cepController.text.trim(),
          telefoneFixo: _telefoneFixoController.text.trim().isEmpty ? null : _telefoneFixoController.text.trim(),
          celular: _celularController.text.trim().isEmpty ? null : _celularController.text.trim(),
          email: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
          observacoes: _observacoesController.text.trim().isEmpty ? null : _observacoesController.text.trim(),
          isAtivo: _isAtivo,
        );
      } else {
        clienteParaSalvar = CustomerEntity.createNew(
          nome: _nomeController.text.trim(),
          apelido: _apelidoController.text.trim().isEmpty ? null : _apelidoController.text.trim(),
          cpf: _cpfController.text.trim().isEmpty ? null : _cpfController.text.trim(),
          rua: _ruaController.text.trim().isEmpty ? null : _ruaController.text.trim(),
          numero: _numeroController.text.trim().isEmpty ? null : _numeroController.text.trim(),
          complemento: _complementoController.text.trim().isEmpty ? null : _complementoController.text.trim(),
          bairro: _bairroController.text.trim().isEmpty ? null : _bairroController.text.trim(),
          cidade: _cidadeController.text.trim().isEmpty ? null : _cidadeController.text.trim(),
          uf: _selectedUF,
          cep: _cepController.text.trim().isEmpty ? null : _cepController.text.trim(),
          telefoneFixo: _telefoneFixoController.text.trim().isEmpty ? null : _telefoneFixoController.text.trim(),
          celular: _celularController.text.trim().isEmpty ? null : _celularController.text.trim(),
          email: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
          observacoes: _observacoesController.text.trim().isEmpty ? null : _observacoesController.text.trim(),
          isAtivo: _isAtivo,
        );
      }

      ref.read(customerFormProvider.notifier).saveCustomer(clienteParaSalvar);
    }
  }

  String get _titleText {
    switch (_currentMode) {
      case CustomerFormMode.create:
        return 'Novo Cliente';
      case CustomerFormMode.edit:
        return 'Editar Cliente';
      case CustomerFormMode.view:
        return 'Visualizar Cliente';
    }
  }

  void _showEditModeMessage() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF383838),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Icon(Icons.info_outline, color: Colors.white70, size: 48),
        content: const Text(
          'Modo de Visualização',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          const Padding(
            padding: EdgeInsets.only(bottom: 24.0),
            child: Text(
              'Para alterar as informações deste cliente, você precisa entrar no modo de edição. Deseja fazer isso agora?',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: const BorderSide(color: Colors.white54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('CANCELAR', style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Fecha o dialog
                    setState(() {
                      _currentMode = CustomerFormMode.edit; // Muda o estado da página inteira!
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB71C1C),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('EDITAR', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _wrapWithReadOnlyGesture({required Widget child}) {
    if (!_isReadOnly) {
      return child;
    }

    return GestureDetector(
      onTap: _showEditModeMessage,
      behavior: HitTestBehavior.opaque,
      child: AbsorbPointer(
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(customerFormProvider, (previous, next) {
      next.when(
        data: (_) {
          final msg = _currentMode == CustomerFormMode.edit
              ? 'Cliente atualizado com sucesso!'
              : 'Cliente salvo com sucesso!';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(msg),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        },
        error: (err, stack) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao salvar cliente: $err'),
              backgroundColor: Colors.red,
            ),
          );
        },
        loading: () {},
      );
    });

    final formState = ref.watch(customerFormProvider);
    final isLoading = formState.isLoading;

    return Scaffold(
      backgroundColor: const Color(0xFF2C2C2C),
      appBar: AppBar(
        title: Text(_titleText),
        backgroundColor: const Color(0xFF2C2C2C),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildStatusCard(),
                  const SizedBox(height: 16),
                  _buildCardContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader(Icons.person, 'Informações do Cliente'),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _nomeController,
                          label: 'Nome',
                          inputFormatters: [NameInputFormatter.formatter],
                          validator: (value) =>
                              !_isReadOnly && (value == null || value.trim().isEmpty)
                                  ? 'O nome é obrigatório'
                                  : null,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: _buildTextField(
                                controller: _apelidoController,
                                label: 'Apelido',
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 1,
                              child: _buildTextField(
                                controller: _cpfController,
                                label: 'CPF',
                                keyboardType: TextInputType.number,
                                inputFormatters: [CpfInputFormatter()],
                                validator: _validarCPF,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(
                          controller: _observacoesController,
                          label: 'Observações sobre o cliente:',
                          maxLines: 4,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildCardContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader(Icons.location_on, 'Endereço do Cliente'),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: _buildTextField(controller: _ruaController, label: 'Rua'),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 1,
                              child: _buildTextField(
                                controller: _numeroController,
                                label: 'Nº',
                                keyboardType: TextInputType.number,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(controller: _complementoController, label: 'Complemento'),
                        const SizedBox(height: 12),
                        _buildTextField(controller: _bairroController, label: 'Bairro'),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: _buildTextField(controller: _cidadeController, label: 'Cidade'),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 1,
                              child: _buildDropdownUF(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(
                          controller: _cepController,
                          label: 'CEP',
                          keyboardType: TextInputType.number,
                          inputFormatters: [CepInputFormatter()],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildCardContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader(Icons.phone, 'Contato com o Cliente'),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _telefoneFixoController,
                          label: 'Telefone Fixo',
                          keyboardType: TextInputType.phone,
                          inputFormatters: [TelefoneFixoInputFormatter()],
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(
                          controller: _celularController,
                          label: 'Celular',
                          keyboardType: TextInputType.phone,
                          inputFormatters: [CelularInputFormatter()],
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(
                          controller: _emailController,
                          label: 'E-mail',
                          keyboardType: TextInputType.emailAddress,
                          validator: _validarEmail,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildBottomButtons(isLoading),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButtons(bool isLoading) {
    if (_isReadOnly) {
      return ElevatedButton(
        onPressed: () => Navigator.pop(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF383838),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text('VOLTAR', style: TextStyle(color: Colors.white)),
      );
    }

    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: isLoading ? null : () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: const BorderSide(color: Colors.white54),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('CANCELAR', style: TextStyle(color: Colors.white)),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: isLoading ? null : _salvarCliente,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB71C1C),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                : Text(
                    _currentMode == CustomerFormMode.edit ? 'ATUALIZAR' : 'SALVAR',
                    style: const TextStyle(color: Colors.white),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusCard() {
    final Color baseColor = _isAtivo ? Colors.greenAccent : Colors.redAccent;
    final Color backgroundColor = baseColor.withValues(alpha: 0.15);
    final Color borderColor = baseColor.withValues(alpha: 0.5);

    final IconData iconData = _isAtivo ? Icons.check_circle_outline : Icons.error_outline;
    final String subtitleText = _isAtivo ? 'O seu cliente está ativo.' : 'O seu cliente está inativo.';

    final card = AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: SwitchListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        title: Row(
          children: [
            Icon(iconData, color: baseColor),
            const SizedBox(width: 12),
            Text(
              'Status do Cliente',
              style: TextStyle(
                color: baseColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(left: 36.0, top: 4.0),
          child: Text(
            subtitleText,
            style: TextStyle(color: baseColor.withValues(alpha: 0.8)),
          ),
        ),
        value: _isAtivo,
        activeThumbColor: Colors.greenAccent,
        inactiveThumbColor: Colors.redAccent,
        inactiveTrackColor: Colors.red.withValues(alpha: 0.3),
        onChanged: _isReadOnly
            ? null
            : (bool value) {
                setState(() {
                  _isAtivo = value;
                });
              },
      ),
    );
    
    return _wrapWithReadOnlyGesture(child: card);
  }

  Widget _buildCardContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF383838),
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFFB71C1C)),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    int maxLines = 1,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: _isReadOnly,
      onTap: _isReadOnly ? _showEditModeMessage : null,
      keyboardType: keyboardType,
      maxLines: maxLines,
      inputFormatters: inputFormatters,
      validator: validator,
      style: TextStyle(color: _isReadOnly ? Colors.white70 : Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: const Color(0xFF2C2C2C),
        isDense: true,
        suffixIcon: _isReadOnly && controller.text.trim().isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.copy, color: Colors.white54, size: 20),
                tooltip: 'Copiar $label',
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: controller.text.trim()));
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$label copiado com sucesso!'),
                      backgroundColor: Colors.green,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              )
            : null,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: _isReadOnly ? Colors.transparent : const Color(0xFFB71C1C),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.redAccent),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.redAccent),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildDropdownUF() {
    final dropdown = DropdownButtonFormField<String>(
      initialValue: _selectedUF,
      dropdownColor: const Color(0xFF383838),
      style: TextStyle(color: _isReadOnly ? Colors.white70 : Colors.white),
      decoration: InputDecoration(
        labelText: 'UF',
        labelStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: const Color(0xFF2C2C2C),
        isDense: true,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: _isReadOnly ? Colors.transparent : const Color(0xFFB71C1C),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      items: _estadosBrasil.map((String uf) {
        return DropdownMenuItem<String>(
          value: uf,
          child: Text(uf),
        );
      }).toList(),
      onChanged: _isReadOnly
          ? null
          : (String? newValue) {
              setState(() {
                _selectedUF = newValue;
              });
            },
    );

    return _wrapWithReadOnlyGesture(child: dropdown);
  }
}