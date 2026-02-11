import 'package:flutter/material.dart';
import '../../app_colors.dart';

class PrimaryButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final Color? color;
  final Widget? child;

  const PrimaryButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.color,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isEnabled
            ? (color ?? AppColors.darkWarm)
            : Theme.of(context).disabledColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      child: child ??
          Text(
            title,
            style: TextStyle(
              color: isEnabled
                  ? Colors.white
                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
    );
  }
}
