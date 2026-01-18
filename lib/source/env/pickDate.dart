import 'package:flutter/material.dart';

Future pickDate(BuildContext context) async {
  DateTime? datetime;
  datetime = await showDatePicker(
    context: context,
    firstDate: DateTime(1900),
    lastDate: DateTime(5000),
    initialDate: DateTime.now(),
  );
  return datetime;
}

Future pickDateNextWeek(BuildContext context) async {
  DateTime? datetime;
  final DateTime currentDate = DateTime.now();
  final DateTime nextWeek = currentDate.add(const Duration(days: 7));
  datetime = await showDatePicker(
    context: context,
    firstDate: nextWeek,
    lastDate: DateTime(5000),
    initialDate: nextWeek,
  );
  return datetime;
}