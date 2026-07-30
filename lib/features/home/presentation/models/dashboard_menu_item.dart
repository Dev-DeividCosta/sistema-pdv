import 'package:flutter/material.dart';

class DashboardMenuItem {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const DashboardMenuItem({
    required this.title,
    required this.icon,
    required this.color,
    this.onTap,
  });
}