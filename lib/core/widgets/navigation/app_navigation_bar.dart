import 'package:flutter/material.dart';

class AppNavigationBar extends StatelessWidget {
  final Widget? contextualAction;
  final Alignment alignment;

  const AppNavigationBar({
    super.key,
    this.contextualAction,
    this.alignment = Alignment.bottomCenter,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final bool hasAction = contextualAction != null;
    final bool showHome = hasAction ? screenWidth >= 260 : true;
    final bool showBack = hasAction ? screenWidth >= 340 : screenWidth >= 240;

    return SafeArea(
      top: false,
      child: Align(
        alignment: alignment,
        // O bottomNavigationBar pode receber constraints maiores que o
        // conteúdo. Sem fatores de tamanho, o Align expande e sua área
        // transparente pode capturar os toques da tela inteira.
        widthFactor: 1.0,
        heightFactor: 1.0,
        child: Padding(

          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            decoration: ShapeDecoration(
              color: const Color(0xFF1C1C1E),
              shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(60.0),
              ),
              shadows: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (showBack)
                  _NavBarIcon(
                    icon: Icons.arrow_back,
                    onTap: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      final navigator = Navigator.of(context, rootNavigator: true);
                      if (navigator.canPop()) {
                        navigator.pop();
                      }
                    },
                  ),
                if (showBack && (showHome || hasAction))
                  const SizedBox(width: 6),
                if (showHome)
                  _NavBarIcon(
                    icon: Icons.home_outlined,
                    onTap: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      Navigator.of(context, rootNavigator: true).popUntil(
                        (route) => route.isFirst,
                      );
                    },
                  ),
                if (showHome && hasAction)
                  const SizedBox(width: 6),
                if (hasAction) contextualAction!,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavBarIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _NavBarIcon({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      clipBehavior: Clip.antiAlias,
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.circular(36.0),
      ),
      child: InkWell(
        customBorder: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(36.0),
        ),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Icon(
            icon,
            color: Colors.white70,
            size: 26,
          ),
        ),
      ),
    );
  }
}

class ContextualActionButton extends StatelessWidget {
  final IconData icon;
  final String? label;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const ContextualActionButton({
    super.key,
    required this.icon,
    this.label,
    required this.onTap,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final bool showLabel = label != null && screenWidth >= 180;
    
    final bgColor = backgroundColor ?? const Color(0xFFE5E5EA);
    final fgColor = foregroundColor ?? (backgroundColor != null ? Colors.white : const Color(0xFF1C1C1E));

    return Material(
      color: bgColor,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: showLabel ? 16.0 : 12.0,
            vertical: 12.0,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: fgColor, size: 22),
              if (showLabel) ...[
                const SizedBox(width: 8),
                Text(
                  label!,
                  style: TextStyle(
                    color: fgColor,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                    fontSize: 15,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}