import 'package:flutter/material.dart';
import '../models/app_menu_item.dart';
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
    return GridView.builder(
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
    );
  }
}