import 'package:flutter/material.dart';

class AppFormSelectAction {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final Color? backgroundColor;

  const AppFormSelectAction({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.backgroundColor,
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
  final Color? primaryColor;

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
    this.primaryColor,
  });

  void _showBottomSheet(BuildContext context, FormFieldState<T> fieldState) {
    final activeColor = primaryColor ?? const Color(0xFFB71C1C);

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
              Text(sheetTitle ?? label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
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
                        backgroundColor: action!.backgroundColor,
                        foregroundColor: Colors.white,
                        side: action!.backgroundColor != null
                            ? BorderSide.none
                            : BorderSide(color: Colors.white.withValues(alpha: 0.35)),
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
                      title: Text(entry.value, style: TextStyle(color: isSelected ? activeColor : Colors.white)),
                      trailing: isSelected ? Icon(Icons.check_circle, color: activeColor) : null,
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
    final selectedText = value != null ? options[value] : '';

    return FormField<T>(
      initialValue: value,
      validator: validator,
      builder: (fieldState) {
        return TextField(
          controller: TextEditingController(text: selectedText),
          readOnly: true,
          onTap: readOnly ? onReadOnlyTap : () => _showBottomSheet(context, fieldState),
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(color: Colors.white70),
            filled: true,
            fillColor: readOnly ? Colors.white.withValues(alpha: 0.05) : const Color(0xFF424242),
            errorText: fieldState.errorText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            suffixIcon: Icon(
              readOnly ? Icons.lock_outline : Icons.arrow_drop_down,
              color: Colors.white54,
            ),
          ),
        );
      },
    );
  }
}