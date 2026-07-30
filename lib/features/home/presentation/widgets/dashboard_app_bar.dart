import 'package:flutter/material.dart';

class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  // 🗑️ REMOVIDO: final Color backgroundColor; (Apagamos a variável)
  
  // 🗑️ REMOVIDO: required this.backgroundColor do construtor
  const DashboardAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 2,
      centerTitle: true,
      title: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _StatItem(text: 'Minhas\nParcelas'),
            _StatItem(text: 'Estoque\nBaixo'),
            _StatItem(text: 'Pagamentos\nRecebidos'),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String text;
  const _StatItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 12, color: Colors.white70, fontWeight: FontWeight.w600),
    );
  }
}