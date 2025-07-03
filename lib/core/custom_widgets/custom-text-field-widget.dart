import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final String? initialValue;
  final TextInputType keyboardType;
  final bool enabledText;

  final bool obscureText;
  final bool hasSuffixIcon;
  final Widget? suffixIcon;
  final ValueChanged<String> onChanged;
  final String? Function(String?)? validator;
  TextEditingController? controller;

  CustomTextField({
    required this.labelText,
    required this.hintText,
    this.initialValue,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.hasSuffixIcon = false,
    this.enabledText = true,
    this.suffixIcon,
    required this.onChanged,
    this.validator,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabledText,
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        labelStyle: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        suffixIconConstraints: BoxConstraints(minHeight: 24, minWidth: 24),
        suffixIcon: hasSuffixIcon ? suffixIcon : null,
      ),
      initialValue: initialValue,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
    );
  }
}
