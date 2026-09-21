import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../company/domain/entities/company.dart';
import '../../../customer/domain/entities/customer.dart';
import '../../../employee/domain/entities/employee.dart';
import '../../domain/entities/sale.dart';

class SaleCompletedPage extends StatefulWidget {
  final SaleDraft draft;
  final CustomerEntity? customer;
  final EmployeeEntity? employee;
  final CompanyEntity? company;

  const SaleCompletedPage({
    super.key,
    required this.draft,
    this.customer,
    this.employee,
    this.company,
  });

  @override
  State<SaleCompletedPage> createState() => _SaleCompletedPageState();
}

class _SaleCompletedPageState extends State<SaleCompletedPage> {
  bool _sharing = false;

  Future<void> _share() async {
    setState(() => _sharing = true);
    try {
      final bytes = await _buildPdf();
      final directory = await getTemporaryDirectory();
      final safeId = widget.draft.id ?? 'sem-id';
      final file = File('${directory.path}/Comprovante_de_compra_$safeId.pdf');
      
      await file.writeAsBytes(bytes, flush: true);
      if (!mounted) return;
      
      await Share.shareXFiles(
        [XFile(file.path, mimeType: 'application/pdf')],
        text: 'Comprovante de compra — venda $safeId',
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Não foi possível compartilhar o comprovante: $error'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  Future<Uint8List> _buildPdf() async {
    final pdf = pw.Document();
    String money(int cents) => 'R\$ ${(cents / 100).toStringAsFixed(2).replaceAll('.', ',')}';
    
    final company = widget.company;
    final customer = widget.customer;
    final employee = widget.employee;

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(36),
        build: (_) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('COMPROVANTE DE COMPRA', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 6),
            pw.Text('Venda: ${widget.draft.id ?? 'não informado'}'),
            pw.Text('Data: ${_date(widget.draft.soldAt)}'),
            pw.Divider(),
            
            pw.Text('EMPRESA', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text(company?.nomeFantasia?.trim().isNotEmpty == true ? company!.nomeFantasia! : company?.razaoSocial ?? 'Não informado'),
            if (company?.cnpj != null) pw.Text('CNPJ: ${company!.cnpj}'),
            if (company?.telefone != null) pw.Text('Telefone: ${company!.telefone}'),
            pw.SizedBox(height: 12),
            
            pw.Text('CLIENTE', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text(customer?.nome ?? 'Não informado'),
            if (customer?.cpf != null) pw.Text('CPF: ${customer!.cpf}'),
            if (customer?.celular != null) pw.Text('Celular: ${customer!.celular}'),
            pw.SizedBox(height: 12),
            
            pw.Text('FUNCIONÁRIO', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text(employee?.nome ?? 'Não informado'),
            if (employee?.cpf != null) pw.Text('CPF: ${employee!.cpf}'),
            pw.SizedBox(height: 16),
            
            pw.Text('ITENS DA VENDA', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.TableHelper.fromTextArray(
              headers: const ['Produto', 'Qtd.', 'Unitário', 'Total'],
              data: widget.draft.items.map((item) => [
                item.productNome,
                '${item.quantity}',
                money(item.unitPriceCentavos),
                money(item.totalCentavos)
              ]).toList(),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              cellPadding: const pw.EdgeInsets.all(6),
            ),
            pw.SizedBox(height: 14),
            
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text('Subtotal: ${money(widget.draft.subtotalCentavos)}'),
                  pw.Text('Desconto: ${money(widget.draft.discountCentavos)}'),
                  pw.Text(
                    'Total: ${money(widget.draft.totalCentavos)}',
                    style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
                  ),
                  if (widget.draft.paymentMethod != null) pw.Text('Pagamento: ${widget.draft.paymentMethod}'),
                  pw.Text('Parcelas: ${widget.draft.installments}x'),
                ],
              ),
            ),
            pw.Spacer(),
            
            pw.Center(
              child: pw.Text(
                'Documento gerado pelo sistema de vendas',
                style: const pw.TextStyle(color: PdfColors.grey),
              ),
            ),
          ],
        ),
      ),
    );
    return pdf.save();
  }

  String _date(DateTime date) => '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF171717),
    appBar: AppBar(
      title: const Text('Venda realizada'),
      backgroundColor: AppMenuColors.sale,
    ),
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.greenAccent, size: 88),
            const SizedBox(height: 16),
            const Text(
              'Venda realizada',
              style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Venda ${widget.draft.id}', style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _sharing ? null : _share,
                icon: _sharing
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.share),
                label: Text(_sharing ? 'GERANDO...' : 'COMPARTILHAR'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                icon: const Icon(Icons.check),
                label: const Text('CONCLUIR'),
                style: OutlinedButton.styleFrom(foregroundColor: Colors.white),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
