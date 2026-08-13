import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/customer.dart';
import '../providers/customer_form_provider.dart'; 

class NewCustomerScreen extends ConsumerStatefulWidget {
  const NewCustomerScreen({super.key});

  @override
  ConsumerState<NewCustomerScreen> createState() => _NewCustomerScreenState();
}

class _NewCustomerScreenState extends ConsumerState<NewCustomerScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _isAtivo = true;
  String? _selectedUF;

  final _nomeController = TextEditingController();
  final _apelidoController = TextEditingController();
  final _ruaController = TextEditingController();
  final _numeroController = TextEditingController();
  final _complementoController = TextEditingController();
  final _bairroController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _cepController = TextEditingController();
  final _telefoneFixoController = TextEditingController();
  final _celularController = TextEditingController();
  final _emailController = TextEditingController();
  final _observacoesController = TextEditingController();

  final List<String> _estadosBrasil = [
    'AC', 'AL', 'AP', 'AM', 'BA', 'CE', 'DF', 'ES', 'GO', 'MA', 'MT', 'MS', 'MG',
    'PA', 'PB', 'PR', 'PE', 'PI', 'RJ', 'RN', 'RS', 'RO', 'RR', 'SC', 'SP', 'SE', 'TO'
  ];

  @override
  void dispose() {
    _nomeController.dispose();
    _apelidoController.dispose();
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

  void _salvarCliente() {
    if (_formKey.currentState!.validate()) {
      // 1. Criamos a entidade através dos controllers
      final novoCliente = CustomerEntity.createNew(
        nome: _nomeController.text.trim(),
        apelido: _apelidoController.text.trim().isEmpty ? null : _apelidoController.text.trim(),
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

      // 2. Disparamos a ação no Notifier do Riverpod
      ref.read(customerFormProvider.notifier).saveCustomer(novoCliente);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Escuta o estado para disparar Snackbars e fechar a tela em caso de sucesso
    ref.listen<AsyncValue<void>>(customerFormProvider, (previous, next) {
      next.when(
        data: (_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Cliente salvo com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context); // Se estiver usando go_router com context.pop(), pode substituir aqui
        },
        error: (err, stack) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao salvar cliente: $err'),
              backgroundColor: Colors.red,
            ),
          );
        },
        loading: () {}, // O loading altera a UI no build abaixo
      );
    });

    // Observa o estado atual para ver se está salvando
    final formState = ref.watch(customerFormProvider);
    final isLoading = formState.isLoading;

    return Scaffold(
      backgroundColor: const Color(0xFF2C2C2C),
      appBar: AppBar(
        title: const Text('Novo Cliente'),
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
                        _buildSectionHeader(Icons.people, 'Informações do Cliente'),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _nomeController, 
                          label: 'Nome',
                          validator: (value) => value == null || value.isEmpty ? 'O nome é obrigatório' : null,
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(controller: _apelidoController, label: 'Apelido'),
                        const SizedBox(height: 12),
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
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildCardContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader(Icons.phone, 'Contato com o cliente'),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _telefoneFixoController,
                          label: 'Telefone Fixo',
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(
                          controller: _celularController,
                          label: 'Celular',
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(
                          controller: _emailController,
                          label: 'E-mail',
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildCardContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTextField(
                          controller: _observacoesController,
                          label: 'Observações sobre o cliente:',
                          maxLines: 4,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
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
                              : const Text('SALVAR', style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    final Color baseColor = _isAtivo ? Colors.greenAccent : Colors.redAccent;
    final Color backgroundColor = baseColor.withValues(alpha: 0.15);
    final Color borderColor = baseColor.withValues(alpha: 0.5);

    final IconData iconData = _isAtivo ? Icons.check_circle_outline : Icons.error_outline;
    final String subtitleText = _isAtivo ? 'O seu cliente está ativo.' : 'O seu cliente está inativo.';

    return AnimatedContainer(
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
        onChanged: (bool value) {
          setState(() {
            _isAtivo = value;
          });
        },
      ),
    );
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
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: const Color(0xFF2C2C2C),
        isDense: true,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFB71C1C)),
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
    return DropdownButtonFormField<String>(
      initialValue: _selectedUF,
      dropdownColor: const Color(0xFF383838),
      style: const TextStyle(color: Colors.white),
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
          borderSide: const BorderSide(color: Color(0xFFB71C1C)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      items: _estadosBrasil.map((String uf) {
        return DropdownMenuItem<String>(
          value: uf,
          child: Text(uf),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedUF = newValue;
        });
      },
    );
  }
}