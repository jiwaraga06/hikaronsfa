import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hikaronsfa/source/env/env.dart';

class MyDialog {
  static dialogLoading(context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const AlertDialog(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [CircularProgressIndicator(color: biru3), SizedBox(width: 20), Text("Loading...", style: TextStyle(fontFamily: "InterMedium"))],
          ),
        );
      },
    );
  }

  static dialogAlert(context, message) {
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.rightSlide,
      title: 'Alert',
      desc: '$message',
      btnCancelOnPress: () {},
      btnOkOnPress: () {},
      titleTextStyle: TextStyle(fontFamily: "InterSemiBold"),
      descTextStyle: TextStyle(fontFamily: "InterMedium"),
    )..show();
  }

  static dialogAlertList(context, list_error) {
    final Map<String, dynamic> errors = list_error;
    List<String> errorMessages = [];
    errors.forEach((key, value) {
      if (value is List) {
        errorMessages.addAll(value.map((e) => e.toString()));
      }
    });
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.rightSlide,
      title: 'Alert',
      desc: '$errorMessages',
      btnCancelOnPress: () {},
      btnOkOnPress: () {},
      titleTextStyle: TextStyle(fontFamily: "InterSemiBold"),
      descTextStyle: TextStyle(fontFamily: "InterMedium"),
    )..show();
  }

  static dialogSuccess(context, message, {VoidCallback? onPressedOk}) {
    return AwesomeDialog(
      dismissOnTouchOutside: false,
      dismissOnBackKeyPress: false,
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.rightSlide,
      title: 'Success',
      desc: '$message',
      btnOkOnPress: onPressedOk,
      titleTextStyle: TextStyle(fontFamily: "InterSemiBold"),
      descTextStyle: TextStyle(fontFamily: "InterMedium"),
    )..show();
  }

  static dialogSuccess2(context, message) {
    return AwesomeDialog(
      dismissOnTouchOutside: false,
      dismissOnBackKeyPress: false,
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.rightSlide,
      title: 'Success',
      desc: '$message',
      btnOkOnPress: () {},
      titleTextStyle: TextStyle(fontFamily: "InterSemiBold"),
      descTextStyle: TextStyle(fontFamily: "InterMedium"),
    )..show();
  }

  static dialogAlert2(context, message, {VoidCallback? onPressedOk}) {
    return AwesomeDialog(
      dismissOnTouchOutside: false,
      dismissOnBackKeyPress: false,
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.rightSlide,
      title: 'Alert',
      desc: '$message',
      btnCancelOnPress: () {},
      btnOkOnPress: onPressedOk,
      titleTextStyle: TextStyle(fontFamily: "InterSemiBold"),
      descTextStyle: TextStyle(fontFamily: "InterMedium"),
    )..show();
  }

  static dialogInfo(context, message, VoidCallback onPressedCancel, VoidCallback onPressedOk) {
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.info,
      animType: AnimType.rightSlide,
      title: 'Info',
      desc: '$message',
      btnCancelOnPress: onPressedCancel,
      btnOkOnPress: onPressedOk,
      titleTextStyle: TextStyle(fontFamily: "InterSemiBold"),
      descTextStyle: TextStyle(fontFamily: "InterMedium"),
    )..show();
  }
}
