import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final bool obscureText;
  final int? maxLines;
  final Widget? suffixIcon;

  const CustomTextFormField({
    super.key,
    required this.labelText,
    required this.hintText,
    this.validator,
    this.onSaved,
    this.keyboardType = TextInputType.text,
    this.controller,
    this.obscureText = false,
    this.maxLines,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: maxLines,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        labelText: labelText,
        hintText: hintText,
        border: const OutlineInputBorder(),
      ),
      validator: validator,
      onSaved: onSaved,
    );
  }
}
