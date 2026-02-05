import 'package:intl/intl.dart';

String formatNumberFromString(String value) {
  final number = int.tryParse(value) ?? 0;
  return NumberFormat('#,##0', 'en_US').format(number);
}

String formatRupiah(int number) {
  final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
  return formatter.format(number);
}
