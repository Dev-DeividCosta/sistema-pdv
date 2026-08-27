import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_form_utils.dart';
import '../../../../core/widgets/forms/app_form_components.dart';
import '../../../../core/widgets/forms/app_form_layout.dart';
import '../../../../core/widgets/forms/app_form_status_card.dart';
import '../../../../core/widgets/forms/app_form_text_field.dart';
import '../../../../core/widgets/forms/form_mode.dart';
import '../../domain/entities/product.dart';
import '../providers/product_form_provider.dart';

class ProductFormPage extends ConsumerStatefulWidget {
  final ProductEntity? product;
  final AppFormMode mode;

  const ProductFormPage({
    super.key,
    this.product,
    this.mode = AppFormMode.create,
  });

  @override
  ConsumerState<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends ConsumerState<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();
  late AppFormMode _currentMode;
  late final TextEditingController _barcode;
  late final TextEditingController _name;
  late final TextEditingController _cost;
  late final TextEditingController _sale;
  late final TextEditingController _stock;
  late final TextEditingController _minimum;
  late final TextEditingController _description;
  late bool _isAtivo;

  bool get _isReadOnly => _currentMode.isReadOnly;

  String _money(double value) {
    return value.toStringAsFixed(2).replaceAll('.', ',');
  }

  double _number(String value) {
    return double.tryParse(value.replaceAll(',', '.')) ?? 0;
  }

  int _integer(String value) {
    return int.tryParse(value) ?? 0;
  }

  @override
  void initState() {
    super.initState();
    _currentMode = widget.mode;
    final product = widget.product;
    
    _barcode = TextEditingController(text: product?.codigoBarras ?? '');
    _name = TextEditingController(text: product?.nomeProduto ?? '');
    _cost = TextEditingController(text: product == null ? '' : _money(product.precoCusto));
    _sale = TextEditingController(text: product == null ? '' : _money(product.precoVenda));
    _stock = TextEditingController(text: product == null ? '0' : '${product.quantidadeEstoque}');
    _minimum = TextEditingController(text: product == null ? '0' : '${product.estoqueMinimo}');
    _description = TextEditingController(text: product?.descricao ?? '');
    _isAtivo = product?.ativo ?? true;
  }

  @override
  void dispose() {
    _barcode.dispose();
    _name.dispose();
    _cost.dispose();
    _sale.dispose();
    _stock.dispose();
    _minimum.dispose();
    _description.dispose();
    super.dispose();
  }

  void _requestEdit() {
    if (!_isReadOnly) return;
    AppFormUtils.showEditModeDialog(
      context: context,
      onConfirm: () => setState(() => _currentMode = AppFormMode.edit),
    );
  }

  String? _validatePrice(String? value) {
    if (_isReadOnly) return null;
    if (value == null || value.trim().isEmpty) {
      return 'Informe o valor.';
    }
    if (_number(value) < 0) {
      return 'Valor inválido.';
    }
    return null;
  }

  String? _validateInteger(String? value) {
    if (_isReadOnly) return null;
    if (value == null || value.trim().isEmpty) {
      return 'Informe o valor.';
    }
    if (_integer(value) < 0) {
      return 'Valor inválido.';
    }
    return null;
  }

  String? _optionalValue(TextEditingController controller) {
    final value = controller.text.trim();
    return value.isEmpty ? null : value;
  }

  void _save() {
    if (_isReadOnly || !_formKey.currentState!.validate()) return;

    final oldProduct = widget.product;

    final productToSave = ProductEntity(
      id: oldProduct?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      codigoBarras: _optionalValue(_barcode),
      nomeProduto: _name.text.trim(),
      precoCusto: _number(_cost.text),
      precoVenda: _number(_sale.text),
      quantidadeEstoque: _integer(_stock.text),
      ativo: _isAtivo,
      descricao: _optionalValue(_description),
      estoqueMinimo: _integer(_minimum.text),
      createdAt: oldProduct?.createdAt ?? DateTime.now().toUtc(),
      updatedAt: DateTime.now().toUtc(),
    );

    ref.read(productFormProvider.notifier).saveProduct(productToSave);
  }

  String get _titleText {
    switch (_currentMode) {
      case AppFormMode.create:
        return 'Novo Produto';
      case AppFormMode.edit:
        return 'Editar Produto';
      case AppFormMode.view:
        return 'Visualizar Produto';
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(productFormProvider, (_, next) {
      next.whenOrNull(
        data: (_) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Produto salvo com sucesso!'), backgroundColor: Colors.green),
          );
          Navigator.pop(context);
        },
        error: (error, stack) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao salvar produto: $error'), backgroundColor: Colors.red),
          );
        },
      );
    });

    final loading = ref.watch(productFormProvider).isLoading;

    return AppFormLayout(
      title: _titleText,
      appBarColor: AppMenuColors.products,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppFormStatusCard(
              value: _isAtivo,
              readOnly: _isReadOnly,
              title: 'Status do Produto',
              subtitle: 'Este produto está ${_isAtivo ? 'ativo' : 'inativo'}.',
              onChanged: (value) => setState(() => _isAtivo = value),
              onReadOnlyTap: _requestEdit,
            ),
            const SizedBox(height: 16),
            AppFormSection(
              icon: Icons.inventory_2_outlined,
              title: 'Informações do Produto',
              child: Column(
                children: [
                  AppFormTextField(
                    controller: _name,
                    label: 'Nome do produto',
                    readOnly: _isReadOnly,
                    onReadOnlyTap: _requestEdit,
                    validator: (value) => !_isReadOnly && (value == null || value.trim().isEmpty)
                        ? 'Informe o nome do produto.'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  AppFormTextField(
                    controller: _barcode,
                    label: 'Código de barras',
                    readOnly: _isReadOnly,
                    onReadOnlyTap: _requestEdit,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 12),
                  AppFormTextField(
                    controller: _description,
                    label: 'Descrição',
                    readOnly: _isReadOnly,
                    onReadOnlyTap: _requestEdit,
                    maxLines: 4,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            AppFormSection(
              icon: Icons.attach_money_outlined,
              title: 'Precificação',
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: AppFormTextField(
                      controller: _cost,
                      label: 'Preço de custo (R\$)',
                      readOnly: _isReadOnly,
                      onReadOnlyTap: _requestEdit,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: _validatePrice,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppFormTextField(
                      controller: _sale,
                      label: 'Preço de venda (R\$)',
                      readOnly: _isReadOnly,
                      onReadOnlyTap: _requestEdit,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: _validatePrice,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            AppFormSection(
              icon: Icons.layers_outlined,
              title: 'Estoque',
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: AppFormTextField(
                      controller: _stock,
                      label: 'Estoque atual',
                      readOnly: _isReadOnly,
                      onReadOnlyTap: _requestEdit,
                      keyboardType: TextInputType.number,
                      validator: _validateInteger,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppFormTextField(
                      controller: _minimum,
                      label: 'Estoque mínimo',
                      readOnly: _isReadOnly,
                      onReadOnlyTap: _requestEdit,
                      keyboardType: TextInputType.number,
                      validator: _validateInteger,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
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