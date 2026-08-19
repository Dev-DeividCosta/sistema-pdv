import 'package:flutter/material.dart';

class AppFormStatusCard extends StatelessWidget {
  final bool value;
  final bool readOnly;
  final ValueChanged<bool>? onChanged;
  final String title;
  final String subtitle;
  final VoidCallback? onReadOnlyTap;

  const AppFormStatusCard({
    super.key,
    required this.value,
    required this.readOnly,
    required this.onChanged,
    required this.title,
    required this.subtitle,
    this.onReadOnlyTap,
  });

  @override
  Widget build(BuildContext context) {
    final baseColor = value ? Colors.greenAccent : Colors.redAccent;
    final card = AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: baseColor.withValues(alpha: 0.15),
        border: Border.all(color: baseColor.withValues(alpha: 0.5), width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: SwitchListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        title: Row(children: [
          Icon(value ? Icons.check_circle_outline : Icons.error_outline, color: baseColor),
          const SizedBox(width: 12),
          Text(title, style: TextStyle(color: baseColor, fontWeight: FontWeight.bold)),
        ]),
        subtitle: Padding(
          padding: const EdgeInsets.only(left: 36, top: 4),
          child: Text(subtitle, style: TextStyle(color: baseColor.withValues(alpha: 0.8))),
        ),
        value: value,
        activeThumbColor: Colors.greenAccent,
        inactiveThumbColor: Colors.redAccent,
        inactiveTrackColor: Colors.red.withValues(alpha: 0.3),
        onChanged: readOnly ? null : onChanged,
      ),
    );
    return readOnly
        ? GestureDetector(onTap: onReadOnlyTap, behavior: HitTestBehavior.opaque, child: AbsorbPointer(child: card))
        : card;
  }
}