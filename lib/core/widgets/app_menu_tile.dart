import 'package:flutter/material.dart';
import '../models/app_menu_item.dart';

enum TileShape { square, rectangle }

class AppMenuTile extends StatelessWidget {
  final AppMenuItem item;
  final TileShape shape;

  const AppMenuTile({
    super.key, 
    required this.item, 
    this.shape = TileShape.square,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: item.color,
      borderRadius: BorderRadius.circular(14),
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: item.onTap,
        hoverColor: Colors.white.withValues(alpha: 0.15),
        mouseCursor: SystemMouseCursors.click,
        splashColor: Colors.white24,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: shape == TileShape.square ? _buildSquareLayout() : _buildRectangleLayout(),
        ),
      ),
    );
  }

  Widget _buildSquareLayout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(item.icon, size: 32, color: Colors.white),
        const SizedBox(height: 6),
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              item.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                height: 1.1,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRectangleLayout() {
    return Row(
      children: [
        Icon(item.icon, size: 28, color: Colors.white),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            item.title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white,
              height: 1.2,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}