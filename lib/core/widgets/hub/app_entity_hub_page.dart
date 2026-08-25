import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../navigation/app_app_bar.dart';
import '../navigation/app_navigation_bar.dart';

import '../../models/app_menu_item.dart';
import '../menu/app_menu_tile.dart';

class AppEntityHubPage<T> extends ConsumerWidget {
  final T item;
  final String title;
  final Color appBarColor;
  final ProviderListenable<AsyncValue<List<T>>> itemsProvider;
  final Object Function(T item) idOf;
  final List<AppMenuItem> Function(BuildContext context, T item) menuItemsBuilder;
  final Widget Function(BuildContext context, T item) previewBuilder;
  final VoidCallback? onAction;
  final String? actionLabel;
  final IconData actionIcon;
  final Color? actionBackgroundColor;

  const AppEntityHubPage({
    super.key,
    required this.item,
    required this.title,
    required this.appBarColor,
    required this.itemsProvider,
    required this.idOf,
    required this.menuItemsBuilder,
    required this.previewBuilder,
    this.onAction,
    this.actionLabel,
    this.actionIcon = Icons.add,
    this.actionBackgroundColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(itemsProvider);
    final currentItem = itemsAsync.maybeWhen(
      data: (items) => items.firstWhere(
        (candidate) => idOf(candidate) == idOf(item),
        orElse: () => item,
      ),
      orElse: () => item,
    );
    final menuItems = menuItemsBuilder(context, currentItem);

    return Scaffold(
      backgroundColor: const Color(0xFF171717),
      extendBody: true,
      appBar: AppAppBar(
        title: title,
        backgroundColor: appBarColor,
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
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  previewBuilder(context, currentItem),
                  const SizedBox(height: 24),
                  ...menuItems.map(
                    (menuItem) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: SizedBox(
                        height: 54,
                        child: AppMenuTile(item: menuItem, shape: TileShape.rectangle),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}