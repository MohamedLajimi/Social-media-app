import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/colors.dart';

class MyButton extends StatelessWidget {
  final void Function()? onPressed;
  final String buttonContent;
  final Color buttonColor;
  const MyButton(this.onPressed, this.buttonContent, this.buttonColor,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
          elevation: 3,
          backgroundColor: buttonColor,
          foregroundColor: buttonColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 5,
        ),
        child: Text(
          buttonContent,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.w500, fontSize: 18),
        ),
      ),
    );
  }
}
