import 'package:flutter/material.dart';
import 'package:hikaronsfa/source/env/env.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String? text;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  const CustomButton({
    super.key,
    this.text = "Button",
    this.onTap,
    this.backgroundColor = hijau,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.0),
      child: Ink(
        decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(8.0), boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 1.1,
            spreadRadius: 1.1,
            offset: const Offset(0, 2),
          )
        ]),
        child: Container(
          height: 55,
          margin: const EdgeInsets.only(left: 6, right: 6),
          decoration: BoxDecoration(
      
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Center(
            child: Text(text!, style: textStyle),
          ),
        ),
      ),
    );
  }
}
