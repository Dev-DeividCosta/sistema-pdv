import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/app_menu_item.dart';
import '../menu/app_menu_tile.dart';

/// Template compartilhado para hubs de entidades com preview e ações.
/// A feature fornece somente a fonte reativa, a identidade e o preview.
class AppEntityHubPage<T> extends ConsumerWidget {
  final T item;
  final String title;
  final ProviderListenable<AsyncValue<List<T>>> itemsProvider;
  final Object Function(T item) idOf;
  final List<AppMenuItem> Function(BuildContext context, T item) menuItemsBuilder;
  final Widget Function(BuildContext context, T item) previewBuilder;

  const AppEntityHubPage({
    super.key,
    required this.item,
    required this.title,
    required this.itemsProvider,
    required this.idOf,
    required this.menuItemsBuilder,
    required this.previewBuilder,
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
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFF171717),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(minimumSize: const Size(200, 50)),
                      child: const Text('Voltar'),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
