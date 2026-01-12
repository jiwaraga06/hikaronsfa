import 'package:flutter/material.dart';

class CustomButton2 extends StatelessWidget {
  final VoidCallback? onTap;
  final String? text;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final RoundedRectangleBorder? roundedRectangleBorder;
  const CustomButton2({super.key, this.onTap, this.text = "Button", this.backgroundColor, this.textStyle, this.roundedRectangleBorder});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(backgroundColor: backgroundColor, shape: roundedRectangleBorder),
        child: Text(
          text!,
          style: textStyle,
        ));
  }
}
