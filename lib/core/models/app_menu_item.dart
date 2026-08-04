import 'package:flutter/material.dart';

class AppMenuItem {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const AppMenuItem({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}