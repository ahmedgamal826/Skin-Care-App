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
    return Container(
      padding: const EdgeInsets.all(16),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFBDC9C5)),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style:
                TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
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
                    style:textStyle ?? TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 22,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    measurementUnit ?? "",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.50,
                    ),
                  )
                ],
              ),
              CircleAvatar(
                backgroundColor:
                    Theme.of(context).colorScheme.secondaryContainer,
                radius: 24,
                child: icon != null
                    ? Icon(
                        icon,
                        size: 24,
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                      )
                    : Image.asset(
                        imagePath!,
                        height: 24,
                        width: 24,
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer,
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
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.25,
                  ),
                )
              : Container(),
          description != null
              ? Text(
                  description!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
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
