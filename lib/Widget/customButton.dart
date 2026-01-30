import 'package:flutter/material.dart';
import 'package:hikaronsfa/source/env/env.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String text;
  final Color backgroundColor;
  final TextStyle? textStyle;
  final IconData? icon;
  final Color? iconColor;
  final double height;

  const CustomButton({
    super.key,
    required this.text,
    this.onTap,
    this.backgroundColor = hijau,
    this.textStyle,
    this.icon,
    this.iconColor = Colors.white,
    this.height = 55,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      splashColor: backgroundColor.withOpacity(0.3),
      child: Ink(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 2, spreadRadius: 1, offset: const Offset(0, 2))],
        ),
        child: SizedBox(
          height: height,
          child: Center(
            child:
                icon == null
                    ? Text(text, style: textStyle ?? const TextStyle(color: Colors.white, fontWeight: FontWeight.w600))
                    : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icon, color: iconColor, size: 20),
                        const SizedBox(width: 8),
                        Text(text, style: textStyle ?? const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                      ],
                    ),
          ),
        ),
      ),
    );
  }
}
