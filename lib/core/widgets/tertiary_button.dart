//t2 Core Packages Imports
import 'package:flutter/material.dart';

//t2 Dependencies Imports
//t3 Services
//t3 Models
//t1 Exports
class TertiaryButton extends StatelessWidget {
  //SECTION - Widget Arguments
  final String title;
  final Function onPressed;

  //!SECTION
  //
  const TertiaryButton({
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
    return TextButton(
      onPressed: () => onPressed(),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
    //!SECTION
  }
}
