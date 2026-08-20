import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppFormTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool readOnly;
  final VoidCallback? onReadOnlyTap;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;

  const AppFormTextField({
    super.key,
    required this.controller,
    required this.label,
    this.readOnly = false,
    this.onReadOnlyTap,
    this.validator,
    this.keyboardType,
    this.inputFormatters,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      // O pulo do gato: o próprio TextFormField intercepta o clique se estiver em readOnly
      onTap: (readOnly && onReadOnlyTap != null) ? onReadOnlyTap : null,
      validator: validator,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: readOnly ? Colors.white.withValues(alpha: 0.05) : const Color(0xFF424242),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        // UX: Botão de copiar apenas no modo de leitura se houver texto
        suffixIcon: readOnly && controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.copy, color: Colors.white54, size: 20),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: controller.text));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Copiado!'), duration: Duration(seconds: 1)),
                  );
                },
              )
            : null,
      ),
    );
  }
}