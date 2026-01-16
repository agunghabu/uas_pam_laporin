import 'package:flutter/material.dart';

class LTextField extends StatelessWidget {
  final String labelText, hintText;
  final TextEditingController controller;
  const LTextField({super.key, required this.controller, required this.labelText, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.title_outlined),
      ),
    );
  }
}
