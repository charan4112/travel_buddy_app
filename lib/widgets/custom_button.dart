import 'package:flutter/material.dart';

/// A reusable button widget that adapts to the app’s theme.
/// Supports both filled and outlined styles, with optional icons.
class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isOutlined;
  final IconData? icon;

  const CustomButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.isOutlined = false,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonChild = icon != null
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 20),
              const SizedBox(width: 8),
              Text(label),
            ],
          )
        : Text(label);

    if (isOutlined) {
      return OutlinedButton(
        onPressed: onPressed,
        style: Theme.of(context).outlinedButtonTheme.style,
        child: buttonChild,
      );
    } else {
      return ElevatedButton(
        onPressed: onPressed,
        style: Theme.of(context).elevatedButtonTheme.style,
        child: buttonChild,
      );
    }
  }
}
