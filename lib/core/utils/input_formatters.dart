import 'package:flutter/services.dart';

class NameInputFormatter {
  static final TextInputFormatter formatter = FilteringTextInputFormatter.allow(
    RegExp(r'[a-zA-ZáàâãéèêíïóôõöúçñÁÀÂÃÉÈÊÍÏÓÔÕÖÚÇÑ\s]'),
  );
}

class CpfInputFormatter extends TextInputFormatter {
  static String format(String text) {
    final digitsOnly = text.replaceAll(RegExp(r'\D'), '');
    final limited = digitsOnly.length > 11 ? digitsOnly.substring(0, 11) : digitsOnly;
    final buffer = StringBuffer();
    for (int i = 0; i < limited.length; i++) {
      if (i == 3 || i == 6) {
        buffer.write('.');
      } else if (i == 9) {
        buffer.write('-');
      }
      buffer.write(limited[i]);
    }
    return buffer.toString();
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final formatted = format(newValue.text);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class CepInputFormatter extends TextInputFormatter {
  static String format(String text) {
    final digitsOnly = text.replaceAll(RegExp(r'\D'), '');
    final limited = digitsOnly.length > 8 ? digitsOnly.substring(0, 8) : digitsOnly;
    final buffer = StringBuffer();
    for (int i = 0; i < limited.length; i++) {
      if (i == 5) {
        buffer.write('-');
      }
      buffer.write(limited[i]);
    }
    return buffer.toString();
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final formatted = format(newValue.text);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class TelefoneFixoInputFormatter extends TextInputFormatter {
  static String format(String text) {
    final digitsOnly = text.replaceAll(RegExp(r'\D'), '');
    final limited = digitsOnly.length > 10 ? digitsOnly.substring(0, 10) : digitsOnly;
    final buffer = StringBuffer();
    for (int i = 0; i < limited.length; i++) {
      if (i == 0) {
        buffer.write('(');
      }
      if (i == 2) {
        buffer.write(') ');
      }
      if (i == 6) {
        buffer.write('-');
      }
      buffer.write(limited[i]);
    }
    return buffer.toString();
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final formatted = format(newValue.text);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class CelularInputFormatter extends TextInputFormatter {
  static String format(String text) {
    final digitsOnly = text.replaceAll(RegExp(r'\D'), '');
    final limited = digitsOnly.length > 11 ? digitsOnly.substring(0, 11) : digitsOnly;
    final buffer = StringBuffer();
    for (int i = 0; i < limited.length; i++) {
      if (i == 0) {
        buffer.write('(');
      }
      if (i == 2) {
        buffer.write(') ');
      }
      if (i == 7) {
        buffer.write('-');
      }
      buffer.write(limited[i]);
    }
    return buffer.toString();
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final formatted = format(newValue.text);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}