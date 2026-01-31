import 'package:intl/intl.dart';

String formatNumberFromString(String value) {
  final number = int.tryParse(value) ?? 0;
  return NumberFormat('#,##0', 'en_US').format(number);
}
