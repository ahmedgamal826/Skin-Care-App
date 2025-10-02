import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final Color? color;

  const PrimaryButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isEnabled
            ? (color ?? Theme.of(context).colorScheme.primary)
            : Theme.of(context).disabledColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isEnabled
              ? Theme.of(context).colorScheme.onPrimary
              : Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
        ),
      ),
    );
  }
}
