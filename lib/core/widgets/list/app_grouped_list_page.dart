import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../navigation/app_app_bar.dart';
import '../navigation/app_navigation_bar.dart';
import 'app_group_card.dart';

class AppGroupedListPage<T> extends StatefulWidget {
  final String title;
  final Color appBarColor;
  final String searchHint;
  final String emptyMessage;
  final String noResultsMessage;
  final String loadingErrorLabel;
  final AsyncValue<List<T>> itemsAsync;
  final List<String> Function(T item) searchFields;
  final String Function(T item) groupKey;
  final Widget Function(BuildContext context, T item, int index, int totalItems) itemBuilder;
  final VoidCallback? onAdd;
  final String? actionLabel;
  final IconData actionIcon;
  final Color? actionBackgroundColor;

  const AppGroupedListPage({
    super.key,
    required this.title,
    required this.appBarColor,
    required this.searchHint,
    required this.emptyMessage,
    required this.noResultsMessage,
    required this.loadingErrorLabel,
    required this.itemsAsync,
    required this.searchFields,
    required this.groupKey,
    required this.itemBuilder,
    this.onAdd,
    this.actionLabel,
    this.actionIcon = Icons.add,
    this.actionBackgroundColor,
  });

  @override
  State<AppGroupedListPage<T>> createState() => _AppGroupedListPageState<T>();
}

class _AppGroupedListPageState<T> extends State<AppGroupedListPage<T>> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xFF171717),
      appBar: AppAppBar(
        title: widget.title,
        backgroundColor: widget.appBarColor,
      ),
      bottomNavigationBar: AppNavigationBar(
        contextualAction: widget.onAdd != null
            ? ContextualActionButton(
                icon: widget.actionIcon,
                label: widget.actionLabel,
                backgroundColor: widget.actionBackgroundColor,
                onTap: widget.onAdd!,
              )
            : null,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 8,
                      bottom: 120,
                    ),
                    child: Column(
                      children: [
                        _SearchField(
                          controller: _searchController,
                          hintText: widget.searchHint,
                          onChanged: (value) {
                            setState(() => _searchQuery = value.trim().toLowerCase());
                          },
                        ),
                        const SizedBox(height: 24),
                        _buildContent(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent() {
    return widget.itemsAsync.when(
      data: (items) {
        final filteredItems = items.where(_matchesSearch).toList();
        if (filteredItems.isEmpty) {
          return _Message(
            text: _searchQuery.isEmpty
                ? widget.emptyMessage
                : '${widget.noResultsMessage} "$_searchQuery".',
          );
        }

        final groupedItems = <String, List<T>>{};
        for (final item in filteredItems) {
          final key = _normalizedGroupKey(widget.groupKey(item));
          groupedItems.putIfAbsent(key, () => []).add(item);
        }

        final sortedKeys = groupedItems.keys.toList()..sort();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final key in sortedKeys)
              AppGroupCard<T>(
                title: key,
                items: [...groupedItems[key]!]..sort(_compareItems),
                itemBuilder: widget.itemBuilder,
              ),
          ],
        );
      },
      loading: () => const _Message(
        child: CircularProgressIndicator(color: Colors.white),
      ),
      error: (error, _) => _Message(
        text: '${widget.loadingErrorLabel}: $error',
        textColor: Colors.redAccent,
      ),
    );
  }

  bool _matchesSearch(T item) {
    return widget.searchFields(item).any(
      (field) => field.toLowerCase().contains(_searchQuery),
    );
  }

  int _compareItems(T a, T b) {
    return widget.groupKey(a).toLowerCase().compareTo(
          widget.groupKey(b).toLowerCase(),
        );
  }

  String _normalizedGroupKey(String value) {
    final normalized = value.trim();
    return normalized.isEmpty ? '#' : normalized[0].toUpperCase();
  }
}

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String> onChanged;

  const _SearchField({
    required this.controller,
    required this.hintText,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[500]),
        prefixIcon: const Icon(Icons.search, color: Colors.grey),
        filled: true,
        fillColor: const Color(0xFF262626),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
      ),
    );
  }
}

class _Message extends StatelessWidget {
  final String? text;
  final Widget? child;
  final Color textColor;

  const _Message({this.text, this.child, this.textColor = Colors.grey});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32),
      child: Center(
        child: child ?? Text(text!, style: TextStyle(color: textColor)),
      ),
    );
  }
}