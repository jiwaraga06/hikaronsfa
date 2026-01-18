import 'package:flutter/material.dart';
import 'package:hikaronsfa/source/env/env.dart';

class CustomField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText, labelText, messageError, initialValue;
  final bool? readOnly, hidePassword;
  final Widget? preffixIcon, suffixIcon;
  final VoidCallback? onTap;
  int? maxline;
  TextStyle? textstyle;
  TextInputType? keyboardType;
  CustomField(
      {super.key,
      this.hintText,
      this.labelText,
      this.initialValue,
      this.messageError,
      this.readOnly = false,
      this.hidePassword = false,
      this.preffixIcon,
      this.suffixIcon,
      this.controller,
      this.keyboardType,
      this.maxline,
      this.textstyle,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      onTap: onTap,
      controller: controller,
      readOnly: readOnly!,
      obscureText: hidePassword!,
      keyboardType: keyboardType,
      maxLines: maxline,
      style: textstyle,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        suffixIcon: suffixIcon,
        prefixIcon: preffixIcon,
        hintStyle: const TextStyle(fontFamily: 'MontserratMedium', fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.8), width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey, strokeAlign: 20),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: ungu, strokeAlign: 20),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: merah, strokeAlign: 20),
        ),
        contentPadding: const EdgeInsets.symmetric( horizontal: 10),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return messageError;
        }
        return null;
      },
    );
  }
}
