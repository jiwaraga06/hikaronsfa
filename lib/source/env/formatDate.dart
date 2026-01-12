import 'package:intl/intl.dart';

String formatDate(DateTime time) {
  final now = DateTime.now();
  final formattedTime = DateFormat('yyyy MMMM dd').format(
    DateTime(time.year, time.month, time.day, time.hour, time.minute),
  );
  return formattedTime;
}
String formatDate2(DateTime time) {
  final now = DateTime.now();
  final formattedTime = DateFormat('dd MMMM yyyy').format(
    DateTime(time.year, time.month, time.day, time.hour, time.minute),
  );
  return formattedTime;
}