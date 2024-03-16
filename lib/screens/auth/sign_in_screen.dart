import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/blocs/auth_bloc/auth_bloc.dart';
import 'package:flutter_application_1/blocs/password_recovery_bloc/password_recovery_bloc.dart';
import 'package:flutter_application_1/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:flutter_application_1/components/my_button.dart';
import 'package:flutter_application_1/components/my_text_field.dart';
import 'package:flutter_application_1/components/strings.dart';
import 'package:flutter_application_1/constants/colors.dart';
import 'package:flutter_application_1/screens/auth/reset_password_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscureText = true;
  String? _errorMsg;
  bool signInRequired = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignInBloc, SignInState>(
      listener: (context, state) {
        if (state is SignInSuccess) {
          setState(() {
            signInRequired = false;
          });
        } else if (state is SignInProcess) {
          setState(() {
            signInRequired = true;
          });
        } else if (state is SignInFailure) {
          setState(() {
            _errorMsg = 'Invalid email or password';
            signInRequired = false;
          });
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
                        errorMsg: _errorMsg,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Please fill in this field';
                          } else if (!passwordRexExp.hasMatch(val)) {
                            return 'Please enter a valid password';
                          }
                          return null;
                        })),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SizedBox(),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (context) => PasswordRecoveryBloc(
                                      userRepository: context
                                          .read<AuthBloc>()
                                          .userRepository),
                                  child: const ResetPasswordScreen(),
                                ),
                              ));
                        },
                        child: const Text(
                          'Forgot Password ?',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ))
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                !signInRequired
                    ? SizedBox(
                        height: 55,
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: MyButton(() {
                          if (_formKey.currentState!.validate()) {
                            context.read<SignInBloc>().add(SignInRequired(
                                emailController.text, passwordController.text));
                          }
                        }, "Sign In", Color(0xff3D5CFF)),
                      )
                    : const CircularProgressIndicator(),
              ],
            )),
      ),
    );
  }
}
