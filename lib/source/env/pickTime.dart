import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future selectTime(BuildContext context) async {
  TimeOfDay? picked = await showTimePicker(
    context: context,
    initialTime: TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute),
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData.light().copyWith(
          timePickerTheme: TimePickerThemeData(
            dialBackgroundColor: Colors.blue.shade100,
            hourMinuteTextStyle: TextStyle(
              color: Colors.blue.shade800,
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
            dayPeriodTextStyle: TextStyle(
              color: Colors.blue.shade700,
              fontSize: 18,
            ),
            entryModeIconColor: Colors.blue.shade700,
          ),
          colorScheme: const ColorScheme.light(
            primary: Colors.blue,
          ),
        ),
        child: child!,
      );
    },
  );
  
    return picked; 
}

String formatTimes(TimeOfDay time) {
  final now = DateTime.now();
  final formattedTime = DateFormat('HH:mm:ss').format(
    DateTime(now.year, now.month, now.day, time.hour, time.minute),
  );
  return formattedTime;
}
