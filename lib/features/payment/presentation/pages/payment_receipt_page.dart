import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../company/domain/entities/company.dart';
import '../../../customer/domain/entities/customer.dart';
import '../../../employee/domain/entities/employee.dart';
import '../../../sale/domain/entities/sale.dart';
import '../../domain/entities/payment.dart';
import '../utils/receipt_pdf_builder.dart';

class PaymentReceiptPage extends StatefulWidget {
  final SaleEntity sale;
  final PaymentEntity payment;
  final CustomerEntity? customer;
  final EmployeeEntity? employee;
  final CompanyEntity? company;
  final int totalPaidAfterPayment;

  const PaymentReceiptPage({
    super.key,
    required this.sale,
    required this.payment,
    required this.totalPaidAfterPayment,
    this.customer,
    this.employee,
    this.company,
  });

  @override
  State<PaymentReceiptPage> createState() => _PaymentReceiptPageState();
}

class _PaymentReceiptPageState extends State<PaymentReceiptPage> {
  bool _sharing = false;

  Future<void> _share() async {
    setState(() => _sharing = true);
    try {
      final bytes = await _buildPdf();
      final directory = await getTemporaryDirectory();
      final file = File(
        '${directory.path}/Comprovante_de_pagamento_${widget.payment.id}.pdf',
      );
      await file.writeAsBytes(bytes, flush: true);
      if (!mounted) return;
      await Share.shareXFiles(
        [XFile(file.path, mimeType: 'application/pdf')],
        text: 'Comprovante de pagamento — venda ${widget.sale.id}',
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

  Future<Uint8List> _buildPdf() => ReceiptPdfBuilder.buildPaymentReceipt(
        sale: widget.sale,
        payment: widget.payment,
        customer: widget.customer,
        employee: widget.employee,
        company: widget.company,
        totalPaidAfterPayment: widget.totalPaidAfterPayment,
      );

  String _money(int cents) =>
      'R\$ ${(cents / 100).toStringAsFixed(2).replaceAll('.', ',')}';

  @override
  Widget build(BuildContext context) {
    final remaining = widget.sale.totalCentavos - widget.totalPaidAfterPayment;
    return Scaffold(
      backgroundColor: const Color(0xFF171717),
      appBar: AppBar(
        title: const Text('Pagamento registrado'),
        backgroundColor: AppMenuColors.sale,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, color: Colors.greenAccent, size: 88),
                const SizedBox(height: 16),
                const Text(
                  'Pagamento registrado',
                  style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _line('Total da compra', widget.sale.totalCentavos),
                _line('Pagou agora', widget.payment.amountCentavos),
                _line('Falta pagar', remaining),
                const SizedBox(height: 28),
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
                        : const Icon(Icons.picture_as_pdf),
                    label: Text(_sharing ? 'GERANDO...' : 'COMPARTILHAR COMPROVANTE'),
                    style: FilledButton.styleFrom(backgroundColor: AppMenuColors.sale),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.check),
                    label: const Text('CONCLUIR'),
                    style: OutlinedButton.styleFrom(foregroundColor: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _line(String label, int value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: Colors.white70)),
            Text(_money(value), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      );
}