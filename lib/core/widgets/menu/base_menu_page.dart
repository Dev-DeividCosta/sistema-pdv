import 'package:flutter/material.dart';

import '../../models/app_menu_item.dart';
import 'centered_menu_list.dart';

class BaseMenuPage extends StatelessWidget {
  final String title;
  final List<AppMenuItem> items;
  final VoidCallback? onBackPressed;
  final VoidCallback? onHomePressed;

  const BaseMenuPage({
    super.key,
    required this.title,
    required this.items,
    this.onBackPressed,
    this.onHomePressed,
  });

  void _goBack(BuildContext context) {
    if (onBackPressed != null) {
      onBackPressed!();
      return;
    }

    Navigator.of(context).pop();
  }

  void _goHome(BuildContext context) {
    if (onHomePressed != null) {
      onHomePressed!();
      return;
    }

    // Remove as telas intermediárias e retorna para a primeira rota,
    // normalmente a Home ou Dashboard.
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C2C2C),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leadingWidth: 104,
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: 'Voltar',
              icon: const Icon(Icons.arrow_back),
              onPressed: () => _goBack(context),
            ),
            IconButton(
              tooltip: 'Ir para Home',
              icon: const Icon(Icons.home_outlined),
              onPressed: () => _goHome(context),
            ),
          ],
        ),
        title: Text(title),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
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
                        CenteredMenuList(items: items),
                        const Spacer(),
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
