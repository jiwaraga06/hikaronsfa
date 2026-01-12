import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

Future pickMonth(BuildContext context) async {
  DateTime? datetime;
  datetime = await showMonthPicker(
    context: context,
    firstDate: DateTime(1900),
    lastDate: DateTime(5000),
    initialDate: DateTime.now(),
    
  );
  return datetime;
}
