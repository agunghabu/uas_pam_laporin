import 'package:flutter/material.dart';

class LTextField extends StatelessWidget {
  final int maxLines;
  final int? maxLengths;
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
    this.maxLengths,
    this.maxLines = 1,
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
  final Icon? leadingIcon;
  final double? menuHeight;
  final int initialSelection;
  final ValueChanged<int?>? onSelected;
  final TextEditingController? controller;
  final List<DropdownMenuEntry<int>> dropdownMenuEntries;
  const LDropdownMenu({
    super.key,
    this.width,
    this.controller,
    this.leadingIcon,
    this.menuHeight,
    required this.onSelected,
    required this.labelText,
    required this.initialSelection,
    required this.dropdownMenuEntries,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      width: width,
      menuHeight: menuHeight,
      controller: controller,
      onSelected: onSelected,
      leadingIcon: leadingIcon,
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
  final List<Widget>? actions;
  const LAlertDialog({super.key, this.actions, required this.icon, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: Icon(icon, color: Theme.of(context).colorScheme.onSurfaceVariant, size: 48),
      title: Text(title),
      actions: actions ?? [TextButton(onPressed: () => Navigator.pop(context), child: Text('OK'))],
      content: content,
    );
  }
}

class LStatusCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final int count;

  const LStatusCard({super.key, required this.icon, required this.color, required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 24, color: color),
                SizedBox(width: 8),
                Text(title, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: color)),
              ],
            ),
            SizedBox(height: 12),
            Text('$count', style: Theme.of(context).textTheme.headlineMedium),
          ],
        ),
      ),
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
