import 'package:flutter/material.dart';

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool centerTitle;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final Color backgroundColor;
  final Color foregroundColor;
  final double? elevation;

  const AppAppBar({
    super.key,
    required this.title,
    required this.backgroundColor,
    this.centerTitle = true,
    this.showBackButton = true,
    this.onBackPressed,
    this.actions,
    this.foregroundColor = Colors.white,
    this.elevation,
  });

  void _goBack(BuildContext context) {
    if (onBackPressed != null) {
      onBackPressed!();
      return;
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: showBackButton
          ? IconButton(
              tooltip: 'Voltar',
              icon: const Icon(Icons.arrow_back),
              onPressed: () => _goBack(context),
            )
          : null,
      title: Text(title),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      elevation: elevation ?? 0,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}