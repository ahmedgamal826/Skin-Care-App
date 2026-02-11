//t2 Core Packages Imports
import 'package:flutter/material.dart';

//t2 Dependencies Imports
//t3 Services
//t3 Models
//t1 Exports
class SectionPlaceholder extends StatelessWidget {
  //SECTION - Widget Arguments
  final String title;

  //!SECTION
  //
  const SectionPlaceholder({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    //SECTION - Build Return
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 2, color: colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        title,
        softWrap: true,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.24,
          color: colorScheme.onSurface,
        ),
      ),
    );
    //!SECTION
  }
}
