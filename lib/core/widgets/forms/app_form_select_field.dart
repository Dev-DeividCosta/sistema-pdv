import 'package:flutter/material.dart';

class AppFormSelectAction {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const AppFormSelectAction({
    required this.label,
    required this.icon,
    required this.onPressed,
  });
}

class AppFormSelectField<T> extends StatelessWidget {
  final String label;
  final T? value;
  final Map<T, String> options;
  final ValueChanged<T?>? onChanged;
  final FormFieldValidator<T>? validator;
  final bool readOnly;
  final VoidCallback? onReadOnlyTap;
  final String? sheetTitle;
  final AppFormSelectAction? action;

  const AppFormSelectField({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    this.onChanged,
    this.validator,
    this.readOnly = false,
    this.onReadOnlyTap,
    this.sheetTitle,
    this.action,
  });

  void _showBottomSheet(BuildContext context, FormFieldState<T> fieldState) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF383838),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40, height: 4, margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(color: Colors.white30, borderRadius: BorderRadius.circular(2)),
              ),
              Text(sheetTitle ?? 'Selecione $label', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                            const Divider(color: Colors.white12),
              if (action != null) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        action!.onPressed();
                      },
                      icon: Icon(action!.icon, size: 18),
                      label: Text(action!.label),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(46),
                        foregroundColor: Colors.white,
                        side: BorderSide(color: Colors.white.withValues(alpha: 0.35)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
              Expanded(

                child: ListView.builder(
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final entry = options.entries.elementAt(index);
                    final isSelected = entry.key == value;
                    return ListTile(
                      title: Text(entry.value, style: TextStyle(color: isSelected ? const Color(0xFFB71C1C) : Colors.white)),
                      trailing: isSelected ? const Icon(Icons.check_circle, color: Color(0xFFB71C1C)) : null,
                      onTap: () {
                        onChanged?.call(entry.key);
                        fieldState.didChange(entry.key);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedText = value != null ? options[value] : 'Selecione...';

    return FormField<T>(
      initialValue: value,
      validator: validator,
      builder: (fieldState) {
        // Usamos o TextFormField como base (mesmo sendo um seletor) 
        // para garantir o mesmo layout e comportamento do TextField normal.
        return TextFormField(
          readOnly: true, // O input é readOnly, o modal controla o valor
          onTap: readOnly ? onReadOnlyTap : () => _showBottomSheet(context, fieldState),
          controller: TextEditingController(text: selectedText),
          style: TextStyle(
            color: readOnly ? Colors.white70 : Colors.white,
          ),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(color: Colors.white54),
            filled: true,
            fillColor: readOnly ? Colors.white.withValues(alpha: 0.05) : const Color(0xFF424242),
            errorText: fieldState.errorText,
            suffixIcon: Icon(
              readOnly ? Icons.lock_outline : Icons.arrow_drop_down,
              color: Colors.white54,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        );
      },
    );
  }
}