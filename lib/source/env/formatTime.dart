import 'package:intl/intl.dart';

String formatTime(String time) {
  DateTime parsedTime = DateFormat("HH:mm:ss").parse(time);
  return DateFormat("HH:mm").format(parsedTime).toString();
}

String formatDateToTime(DateTime date) {
  return DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
}

String formatDateToTime2(DateTime date) {
  return DateFormat('HH:mm:ss').format(date);
}

String formatDateToTime3(DateTime date) {
  if (date == null) return '-';
  return DateFormat('HH:mm').format(date);
}
