import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final Color titleColor;
  final String description;
  final String buttonContent;
  const CustomAlertDialog(
      this.title, this.titleColor, this.description, this.buttonContent,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 0,
      title: Text(
        title,
        style: TextStyle(
            color: titleColor, fontSize: 24, fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            description,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
      actions: [
        TextButton(
          child: Text(
            buttonContent,
            style: TextStyle(fontSize: 16.0, color: titleColor),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }
}
