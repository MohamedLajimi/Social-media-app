import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/blocs/password_recovery_bloc/password_recovery_bloc.dart';
import 'package:flutter_application_1/components/custom_alert_dialog.dart';
import 'package:flutter_application_1/components/my_button.dart';
import 'package:flutter_application_1/components/my_text_field.dart';
import 'package:flutter_application_1/components/strings.dart';
import 'package:flutter_application_1/constants/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocListener<PasswordRecoveryBloc, PasswordRecoveryState>(
      listener: (context, state) {
        if (state is EmailSentSuccessfully) {
          showDialog(
            context: context,
            builder: (context) {
              return const CustomAlertDialog(
                  'Email Sent Successfully!',
                  primaryColor,
                  'Check your email to reset your password.',
                  'Ok');
            },
          );
        } else if (state is EmailSentFailure) {
          showDialog(
            context: context,
            builder: (context) {
              return const CustomAlertDialog('Email Sent Failure',
                  Colors.redAccent, 'Somthing went wrong.', 'Try Again');
            },
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.grey[100],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Password Recovery',
                  style: TextStyle(
                      color: secondaryColor,
                      fontSize: 28,
                      fontWeight: FontWeight.w700),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Please enter your email to recieve a link to reset your password.',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(
                  height: 30,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: MyTextField(
                              controller: emailController,
                              hintText: 'Email',
                              obscureText: false,
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: const Icon(Icons.email),
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return 'Please fill in this field';
                                } else if (!emailRexExp.hasMatch(val)) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              })),
                      const SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width * 0.5,
                        child: MyButton(() {
                          if (_formKey.currentState!.validate()) {
                            context.read<PasswordRecoveryBloc>().add(
                                PasswordRecoveryRequired(emailController.text));
                          }
                        }, 'Submit', secondaryColor),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
