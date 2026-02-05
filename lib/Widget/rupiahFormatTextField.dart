import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class RupiahInputFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final numericText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    final number = int.parse(numericText);

    final newText = _formatter.format(number);

    return TextEditingValue(text: newText, selection: TextSelection.collapsed(offset: newText.length));
  }
}
