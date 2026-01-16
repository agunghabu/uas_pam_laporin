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

class LDropdownMenu extends StatelessWidget {
  final double? width;
  final String labelText;
  final int initialSelection;
  final IconData leadingIcon;
  final ValueChanged<int?>? onSelected;
  final List<DropdownMenuEntry<int>> dropdownMenuEntries;
  const LDropdownMenu({
    super.key,
    this.width,
    required this.onSelected,
    required this.labelText,
    required this.leadingIcon,
    required this.initialSelection,
    required this.dropdownMenuEntries,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      width: width,
      onSelected: onSelected,
      initialSelection: initialSelection,
      leadingIcon: Icon(leadingIcon),
      dropdownMenuEntries: dropdownMenuEntries,
      label: Text(labelText),
    );
  }
}
