import 'package:flutter/material.dart';
import '../../models/app_menu_item.dart';
import 'centered_menu_list.dart';

class BaseMenuPage extends StatelessWidget {
  final String title;
  final List<AppMenuItem> items;
  final VoidCallback? onBackPressed;

  const BaseMenuPage({
    super.key,
    required this.title,
    required this.items,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C2C2C),
      appBar: AppBar(
        title: Text(title),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              // Permite o scroll na tela inteira mesmo se o conteúdo for pequeno
              physics: const AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Lista alinhada no topo da tela
                        CenteredMenuList(items: items),

                        // Empurra o botão de voltar para o final da tela
                        const Spacer(),

                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: onBackPressed ?? () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(200, 50),
                          ),
                          child: const Text('Voltar'),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}