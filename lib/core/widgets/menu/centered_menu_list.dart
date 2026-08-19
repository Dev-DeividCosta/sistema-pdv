import 'package:flutter/material.dart';
import '../../models/app_menu_item.dart';
import 'app_menu_tile.dart';

class CenteredMenuList extends StatelessWidget {
  final List<AppMenuItem> items;
  final double maxWidth;

  const CenteredMenuList({
    super.key,
    required this.items,
    this.maxWidth = 400.0,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: items.map((item) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: AppMenuTile(
                item: item,
                shape: TileShape.rectangle,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}