import 'package:flutter/material.dart';
import '../models/dashboard_menu_item.dart';

class DashboardTile extends StatelessWidget {
  final DashboardMenuItem item;

  const DashboardTile({super.key, required this.item});

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
          padding: const EdgeInsets.all(6.0), 
          child: Column(
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
          ),
        ),
      ),
    );
  }
}