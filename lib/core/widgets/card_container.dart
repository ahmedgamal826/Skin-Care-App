import 'package:flutter/material.dart';

class CardContainer extends StatelessWidget {
  final Widget? child;
  final String title;
  final TextStyle? textStyle;
  final String measuredValue;
  final String? measurementUnit;
  final String? subtitle;
  final String? description;
  final Widget? actionButton;
  final String? imagePath;
  final IconData? icon;

  const CardContainer(
      {super.key,
      this.child,
      required this.title,
      required this.measuredValue,
      this.measurementUnit,
      this.imagePath,
      this.icon,
      this.subtitle,
      this.description,
      this.actionButton,
      this.textStyle});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: colorScheme.surfaceContainerHighest,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.50,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    measuredValue,
                    style: textStyle ??
                        TextStyle(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 22,
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                  Text(
                    measurementUnit ?? "",
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.50,
                    ),
                  )
                ],
              ),
              CircleAvatar(
                backgroundColor: colorScheme.secondaryContainer,
                radius: 24,
                child: icon != null
                    ? Icon(
                        icon,
                        size: 24,
                        color: colorScheme.onSecondaryContainer,
                      )
                    : Image.asset(
                        imagePath!,
                        height: 24,
                        width: 24,
                        color: colorScheme.onSecondaryContainer,
                      ),
              )
            ],
          ),
          (subtitle != null || description != null)
              ? const SizedBox(
                  height: 8,
                )
              : Container(),
          subtitle != null
              ? Text(
                  subtitle ?? "",
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.25,
                  ),
                )
              : Container(),
          description != null
              ? Text(
                  description!,
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.50,
                  ),
                )
              : Container(),
          actionButton != null
              ? Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: actionButton,
                )
              : Container(),
          child != null ? child! : Container(),
        ],
      ),
    );
  }
}
