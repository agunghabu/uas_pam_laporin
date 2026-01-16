import 'package:flutter/material.dart';

class LTextField extends StatelessWidget {
  final int maxLines, maxLengths;
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
    this.maxLengths = 30,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: maxLines,
      maxLength: maxLengths,
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
  final TextEditingController? controller;
  final List<DropdownMenuEntry<int>> dropdownMenuEntries;
  const LDropdownMenu({
    super.key,
    this.width,
    this.controller,
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
      controller: controller,
      onSelected: onSelected,
      leadingIcon: Icon(leadingIcon),
      initialSelection: initialSelection,
      dropdownMenuEntries: dropdownMenuEntries,
      label: Text(labelText),
    );
  }
}

class LAlertDialog extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget content;
  final Color iconColor;
  const LAlertDialog({
    super.key,
    required this.icon,
    required this.title,
    required this.content,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: Icon(icon, color: iconColor, size: 48),
      title: Text(title),
      content: content,
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('OK'))],
    );
  }
}

class LText {
  static headlineSmall(BuildContext context, String text, {TextAlign? textAlign = TextAlign.left}) {
    return Text(text, style: Theme.of(context).textTheme.headlineSmall, textAlign: textAlign);
  }

  static headlineMedium(BuildContext context, String text, {TextAlign? textAlign = TextAlign.left}) {
    return Text(text, style: Theme.of(context).textTheme.headlineMedium, textAlign: textAlign);
  }

  static bodyMedium(BuildContext context, String text, {TextAlign? textAlign = TextAlign.left}) {
    return Text(text, style: Theme.of(context).textTheme.bodyMedium, textAlign: textAlign);
  }

  static bodySmall(BuildContext context, String text, {TextAlign? textAlign = TextAlign.left}) {
    return Text(text, style: Theme.of(context).textTheme.bodySmall, textAlign: textAlign);
  }
}
