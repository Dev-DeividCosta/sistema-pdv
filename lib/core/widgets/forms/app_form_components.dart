import 'package:flutter/material.dart';

class AppFormSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;

  const AppFormSection({
    super.key,
    required this.icon,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF383838),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.circle, color: Colors.transparent, size: 0),
            Icon(icon, color: const Color(0xFFB71C1C)),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            )),
          ]),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class AppFormActions extends StatelessWidget {
  final bool readOnly;
  final bool loading;
  final String saveLabel;
  final VoidCallback? onCancel;
  final VoidCallback? onSave;

  const AppFormActions({
    super.key,
    required this.readOnly,
    required this.loading,
    required this.saveLabel,
    this.onCancel,
    this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    if (readOnly) {
      return ElevatedButton(
        onPressed: onCancel,
        style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
        child: const Text('VOLTAR'),
      );
    }
    return Row(children: [
      Expanded(child: OutlinedButton(
        onPressed: loading ? null : onCancel,
        style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
        child: const Text('CANCELAR'),
      )),
      const SizedBox(width: 16),
      Expanded(child: ElevatedButton(
        onPressed: loading ? null : onSave,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFB71C1C),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: loading
            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : Text(saveLabel),
      )),
    ]);
  }
}