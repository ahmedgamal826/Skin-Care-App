//t2 Core Packages Imports
import 'package:flutter/material.dart';

//t2 Dependencies Imports
//t3 Services
//t3 Models
//t1 Exports
class CustomTextFormField extends StatelessWidget {
  //SECTION - Widget Arguments
  final TextEditingController? controller;
  final String hintText;
  final String? Function(String?)? validator;
  final Function(String)? onFieldSubmitted;
  final bool isObscure;
  final bool isEnabled;
  final Widget? prefixIcon;

  //!SECTION
  //
  const CustomTextFormField({
    Key? key,
    this.controller,
    required this.hintText,
    this.validator,
    this.isObscure = false,
    this.isEnabled = true,
    this.onFieldSubmitted,
    this.prefixIcon,
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
    return TextFormField(
      enabled: isEnabled,
      controller: controller,
      obscureText: isObscure,
      onFieldSubmitted: onFieldSubmitted,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        hintText: hintText,
        filled: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color(0xFFF2F2F2),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color(0xFFF2F2F2),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color(0xFFF2F2F2),
          ),
        ),
        hintStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.43,
        ),
      ),
      validator: validator,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.43,
      ),
    );
    //!SECTION
  }
}
