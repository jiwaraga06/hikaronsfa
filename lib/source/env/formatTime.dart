import 'package:intl/intl.dart';

String formatTime(String time) {
  DateTime parsedTime = DateFormat("HH:mm:ss").parse(time);
  return DateFormat("HH:mm").format(parsedTime).toString();
}