import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/blocs/sign_up_bloc/sign_up_bloc.dart';
import 'package:flutter_application_1/components/my_button.dart';
import 'package:flutter_application_1/components/my_text_field.dart';
import 'package:flutter_application_1/components/strings.dart';
import 'package:flutter_application_1/constants/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscureText = true;
  String? _errorMsg;
  bool signUpRequired = false;
  bool containsUpperCase = false;
  bool containsLowerCase = false;
  bool containsNumber = false;
  bool containsSpecialChar = false;
  bool contains8Length = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpBloc, SignUpState>(
      listener: (context, state) {
        if (state is SignUpSuccess) {
          setState(() {
            signUpRequired = false;
          });
        } else if (state is SignUpProcess) {
          setState(() {
            signUpRequired = true;
          });
        } else if (state is SignUpFailure) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text(state.errorMsg!),
              );
            },
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(color: Colors.grey[100]),
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: MyTextField(
                        controller: nameController,
                        hintText: 'Full Name',
                        obscureText: false,
                        keyboardType: TextInputType.text,
                        prefixIcon: const Icon(Icons.person),
                        errorMsg: _errorMsg,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Please fill in this field';
                          } else if (val.length > 20) {
                            return 'Name too long';
                          }
                          return null;
                        })),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: MyTextField(
                        controller: emailController,
                        hintText: 'Email',
                        obscureText: false,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: const Icon(Icons.email),
                        errorMsg: _errorMsg,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Please fill in this field';
                          } else if (!emailRexExp.hasMatch(val)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        })),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: MyTextField(
                        controller: passwordController,
                        hintText: 'Password',
                        obscureText: obscureText,
                        keyboardType: TextInputType.visiblePassword,
                        prefixIcon: const Icon(CupertinoIcons.lock_fill),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              obscureText = !obscureText;
                            });
                          },
                          icon: obscureText
                              ? const Icon(Icons.visibility_off)
                              : const Icon(Icons.visibility),
                        ),
                        onChanged: (val) {
                          if (val!.contains(RegExp(r'[A-Z]'))) {
                            setState(() {
                              containsUpperCase = true;
                            });
                          } else {
                            setState(() {
                              containsUpperCase = false;
                            });
                          }
                          if (val.contains(RegExp(r'[a-z]'))) {
                            setState(() {
                              containsLowerCase = true;
                            });
                          } else {
                            setState(() {
                              containsLowerCase = false;
                            });
                          }
                          if (val.contains(RegExp(r'[0-9]'))) {
                            setState(() {
                              containsNumber = true;
                            });
                          } else {
                            setState(() {
                              containsNumber = false;
                            });
                          }
                          if (val.contains(specialCharRexExp)) {
                            setState(() {
                              containsSpecialChar = true;
                            });
                          } else {
                            setState(() {
                              containsSpecialChar = false;
                            });
                          }
                          if (val.length >= 8) {
                            setState(() {
                              contains8Length = true;
                            });
                          } else {
                            setState(() {
                              contains8Length = false;
                            });
                          }
                          return null;
                        },
                        errorMsg: _errorMsg,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Please fill in this field';
                          } else if (!passwordRexExp.hasMatch(val)) {
                            return 'Please enter a valid password';
                          }
                          return null;
                        })),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "⚈  1 uppercase",
                          style: TextStyle(
                              color: containsUpperCase
                                  ? Colors.green
                                  : Theme.of(context).colorScheme.onBackground),
                        ),
                        Text(
                          "⚈  1 lowercase",
                          style: TextStyle(
                              color: containsLowerCase
                                  ? Colors.green
                                  : Theme.of(context).colorScheme.onBackground),
                        ),
                        Text(
                          "⚈  1 number",
                          style: TextStyle(
                              color: containsNumber
                                  ? Colors.green
                                  : Theme.of(context).colorScheme.onBackground),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "⚈  1 special character",
                          style: TextStyle(
                              color: containsSpecialChar
                                  ? Colors.green
                                  : Theme.of(context).colorScheme.onBackground),
                        ),
                        Text(
                          "⚈  8 minimum character",
                          style: TextStyle(
                              color: contains8Length
                                  ? Colors.green
                                  : Theme.of(context).colorScheme.onBackground),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                !signUpRequired
                    ? SizedBox(
                        height: 55,
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: MyButton(() {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              context.read<SignUpBloc>().add(SignUpRequired(
                                  nameController.text,
                                  emailController.text,
                                  passwordController.text));
                            });
                          }
                        }, "Sign Up", Color(0xff3D5CFF)),
                      )
                    : const CircularProgressIndicator()
              ],
            )),
      ),
    );
  }
}
