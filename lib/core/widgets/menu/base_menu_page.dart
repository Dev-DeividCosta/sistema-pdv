import 'package:flutter/material.dart';
import '../../models/app_menu_item.dart';
import '../navigation/app_app_bar.dart';
import '../navigation/app_navigation_bar.dart';
import 'centered_menu_list.dart';

class BaseMenuPage extends StatelessWidget {
  final String title;
  final Color appBarColor;
  final List<AppMenuItem> items;
  final VoidCallback? onBackPressed;
  final VoidCallback? onAction;
  final String? actionLabel;
  final IconData actionIcon;
  final Color? actionBackgroundColor;

  const BaseMenuPage({
    super.key,
    required this.title,
    required this.appBarColor,
    required this.items,
    this.onBackPressed,
    this.onAction,
    this.actionLabel,
    this.actionIcon = Icons.add,
    this.actionBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C2C2C),
      extendBody: true,
      appBar: AppAppBar(
        title: title,
        backgroundColor: appBarColor,
        showBackButton: true,
        onBackPressed: onBackPressed,
      ),
      bottomNavigationBar: AppNavigationBar(
        contextualAction: onAction != null
            ? ContextualActionButton(
                icon: actionIcon,
                label: actionLabel,
                backgroundColor: actionBackgroundColor,
                onTap: onAction!,
              )
            : null,
      ),
      body: SafeArea(
        bottom: false,
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
                    padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 120.0),
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