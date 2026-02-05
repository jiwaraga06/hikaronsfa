import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hikaronsfa/source/env/env.dart';

class CustomField2 extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText, labelText, messageError, initialValue;
  final bool readOnly, hidePassword, obscureText;
  final Widget? preffixIcon, suffixIcon;
  final VoidCallback? onTap;
  final int maxLines;
  final TextStyle? textStyle;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final List<TextInputFormatter>? inputFormatters;


  const CustomField2({
    super.key,
    this.hintText,
    this.labelText,
    this.initialValue,
    this.messageError,
    this.readOnly = false,
    this.hidePassword = false,
    this.obscureText = false,
    this.preffixIcon,
    this.suffixIcon,
    this.controller,
    this.keyboardType,
    this.maxLines = 1,
    this.textStyle,
    this.onTap,
    this.onChanged,
    this.inputFormatters
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: controller == null ? initialValue : null,
      readOnly: readOnly,
      obscureText: obscureText,
      keyboardType: keyboardType,
      maxLines: maxLines,
      onTap: onTap,
      inputFormatters: inputFormatters,
      style: textStyle ?? const TextStyle(fontFamily: 'InterMedium', fontSize: 12),
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        prefixIcon: preffixIcon,
        suffixIcon: suffixIcon,

        // ✨ Soft & elegan
        filled: true,
        fillColor: Colors.grey.shade50,

        hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 12, fontFamily: 'InterMedium'),
        labelStyle: TextStyle(color: Colors.grey.shade700, fontSize: 12, fontFamily: 'InterMedium'),

        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),

        border: outlineBorder(Colors.grey.shade300),
        enabledBorder: outlineBorder(Colors.grey.shade300),
        focusedBorder: outlineBorder(biru),
        errorBorder: outlineBorder(merah),
        focusedErrorBorder: outlineBorder(merah),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return messageError;
        }
        return null;
      },
    );
  }

  OutlineInputBorder outlineBorder(Color color) {
    return OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: color, width: 1.2));
  }
}
