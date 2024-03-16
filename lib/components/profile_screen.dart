import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/my_button.dart';
import 'package:flutter_application_1/constants/colors.dart';

class ProfileScreen extends StatefulWidget {
  String imgUrl;
  String fullName;
  int postsNumber;
  int followersNumber;
  int followingNumber;
  bool isMyAccount;
  void Function()? onPressed;
  ProfileScreen(
      {required this.imgUrl,
      required this.fullName,
      required this.postsNumber,
      required this.followersNumber,
      required this.followingNumber,
      required this.isMyAccount,
      required this.onPressed,
      super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image:
                          DecorationImage(image: NetworkImage(widget.imgUrl))),
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  widget.fullName,
                  style: const TextStyle(fontSize: 22, letterSpacing: 1.2),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      '${widget.postsNumber}',
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      'Posts',
                      style: TextStyle(color: Color(0xff606A81), fontSize: 18),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '${widget.followersNumber}',
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      'Followers',
                      style: TextStyle(fontSize: 18, color: Color(0xff606A81)),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '${widget.followingNumber}',
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      'Following',
                      style: TextStyle(fontSize: 18, color: Color(0xff606A81)),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            !widget.isMyAccount
                ? SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: MyButton(widget.onPressed, 'Follow +', primaryColor))
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
