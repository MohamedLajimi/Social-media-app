import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/colors.dart';

class ProfileStat extends StatelessWidget {
  const ProfileStat({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: primaryColor),
        borderRadius: BorderRadius.circular(20),
      ),
      height: 70,
      width: 70,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite,
            color: Colors.red,
            size: 35,
          ),
          Text(
            '300',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          )
        ],
      ),
    );
  }
}
