import 'package:flutter/material.dart';

class LTextField extends StatelessWidget {
  final int maxLines;
  final IconData icon;
  final bool obscureText;
  final String labelText, hintText;
  final TextEditingController controller;
  const LTextField({
    super.key,
    required this.controller,
    required this.icon,
    required this.labelText,
    required this.hintText,
    this.maxLines = 1,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: maxLines,
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        border: OutlineInputBorder(),
        prefixIcon: Icon(icon),
      ),
    );
  }
}
