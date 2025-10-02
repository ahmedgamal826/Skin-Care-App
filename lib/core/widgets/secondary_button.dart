//t2 Core Packages Imports
import 'package:flutter/material.dart';

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
    //SECTION - Build Setup
    //t2 -Values
    //double w = MediaQuery.of(context).size.width;
    //double h = MediaQuery.of(context).size.height;
    //t2 -Values
    //
    //t2 -Widgets
    //t2 -Widgets
    //!SECTION

    //SECTION - Build Return
    return ElevatedButton(
      onPressed: () => onPressed(),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          side:  BorderSide(
            strokeAlign: BorderSide.strokeAlignCenter,
            color: Theme.of(context).colorScheme.primary,
          ),
          borderRadius: BorderRadius.circular(100),
        ),
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style:  const TextStyle(

          fontWeight: FontWeight.w500,
        ),
      ),
    );
    //!SECTION
  }
}
