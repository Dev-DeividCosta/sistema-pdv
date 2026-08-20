import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/models/app_menu_item.dart';
import '../../domain/entities/customer.dart';
import '../pages/customer_form_page.dart';
import '../../../../core/widgets/forms/form_mode.dart';

abstract class CustomerHubMenuBuilder {
  List<AppMenuItem> getMenuItems(BuildContext context, CustomerEntity customer);
}

class CustomerHubMenuBuilderImpl implements CustomerHubMenuBuilder {
  const CustomerHubMenuBuilderImpl();

  // --- Feedback em SnackBar padronizado com o design do seu projeto ---
  void _showWarningSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).clearSnackBars(); // Limpa avisos anteriores
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        backgroundColor: const Color(0xFF262626), // Mesmo fundo dos seus dialogs
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Color(0xFFE2B93B), width: 1), // Borda de alerta dourada
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _launchWhatsApp(BuildContext context, String? phone) async {
    // Validação completa: nulo, apenas espaços ou sem dígitos suficientes
    final cleanPhone = phone?.replaceAll(RegExp(r'[^0-9]'), '') ?? '';

    if (cleanPhone.isEmpty) {
      _showWarningSnackBar(context, 'Cliente não possui número de celular cadastrado.');
      return;
    }

    final formattedPhone = cleanPhone.startsWith('55') ? cleanPhone : '55$cleanPhone';
    final Uri url = Uri.parse('https://wa.me/$formattedPhone');

    try {
      final launched = await launchUrl(url, mode: LaunchMode.externalApplication);
      if (!launched && context.mounted) {
        _showWarningSnackBar(context, 'Não foi possível abrir o WhatsApp.');
      }
    } catch (_) {
      if (context.mounted) {
        _showWarningSnackBar(context, 'Erro ao tentar abrir o aplicativo do WhatsApp.');
      }
    }
  }

  @override
  List<AppMenuItem> getMenuItems(BuildContext context, CustomerEntity customer) {
    return [
      AppMenuItem(
        title: 'Visualizar',
        icon: Icons.visibility,
        color: const Color(0xFFB71C1C),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CustomerFormPage(
                customer: customer,
                mode: AppFormMode.view,
              ),
            ),
          );
        },
      ),
      AppMenuItem(
        title: 'Editar',
        icon: Icons.edit,
        color: const Color(0xFFB71C1C),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CustomerFormPage(
                customer: customer,
                mode: AppFormMode.edit,
              ),
            ),
          );
        },
      ),
      AppMenuItem(
        title: 'Conversar via WhatsApp',
        icon: Icons.chat,
        color: const Color(0xFF25D366),
        onTap: () => _launchWhatsApp(context, customer.celular),
      ),
    ];
  }
}