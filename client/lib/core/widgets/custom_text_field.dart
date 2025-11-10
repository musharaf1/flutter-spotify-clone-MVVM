import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final bool readOnly;
  final VoidCallback? onTap;
  const CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.obscureText = false,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      readOnly: readOnly,
      validator: (value) {
        if (value!.trim().isEmpty) {
          return "$hintText is missing";
        }
        return null;
      },
      obscureText: obscureText,
      decoration: InputDecoration(hintText: hintText),
      controller: controller,
    );
  }
}
