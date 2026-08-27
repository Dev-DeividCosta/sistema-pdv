import 'package:flutter/material.dart';
import '../../models/app_menu_item.dart';
import 'app_menu_tile.dart';

class ResponsiveMenuGrid extends StatelessWidget {
  final List<AppMenuItem> items;
  final TileShape shape;

  const ResponsiveMenuGrid({
    super.key, 
    required this.items,
    this.shape = TileShape.square,
  });

  @override
  Widget build(BuildContext context) {
    final double maxWidth = shape == TileShape.square ? 450.0 : 600.0;

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: shape == TileShape.square ? 140.0 : 190.0,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              mainAxisExtent: shape == TileShape.rectangle ? 80.0 : null,
              childAspectRatio: 1.0, 
            ),
            itemBuilder: (context, index) {
              return AppMenuTile(
                item: items[index],
                shape: shape,
              );
            },
          ),
        ),
      ),
    );
  }
}