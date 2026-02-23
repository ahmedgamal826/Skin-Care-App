//t2 Core Packages Imports
import 'package:flutter/material.dart';

import '../../app_colors.dart';

//t2 Dependancies Imports
//t3 Services
//t3 Models
//t1 Exports
class SecondaryButton extends StatelessWidget {
  //SECTION - Widget Arguments
  final String title;
  final Function onPressed;

  //!SECTION
  //
  const SecondaryButton({
    Key? key,
    required this.title,
    required this.onPressed,
  }) : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    //SECTION - Build Return
    return OutlinedButton(
      onPressed: () => onPressed(),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        side: const BorderSide(
          color: AppColors.darkWarm,
          width: 1.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: AppColors.darkWarm,
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
    );
    //!SECTION
  }
}
