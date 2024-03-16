import 'package:flutter/material.dart';
import 'package:flutter_application_1/blocs/auth_bloc/auth_bloc.dart';
import 'package:flutter_application_1/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:flutter_application_1/blocs/sign_up_bloc/sign_up_bloc.dart';
import 'package:flutter_application_1/constants/colors.dart';
import 'package:flutter_application_1/screens/auth/sign_in_screen.dart';
import 'package:flutter_application_1/screens/auth/sign_up_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late TabController tabController;
  late int tabIndex;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    tabIndex = tabController.index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Welcome SocialMed',
                  style: TextStyle(
                      color: secondaryColor,
                      fontSize: 30,
                      fontWeight: FontWeight.w700),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Welcome to our innovative social platform, where connections flourish and creativity thrives.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                ),
                const SizedBox(
                  height: 30,
                ),
                TabBar(
                    indicatorColor: const Color(0xFF3D5CFF),
                    unselectedLabelColor: Theme.of(context)
                        .colorScheme
                        .onBackground
                        .withOpacity(0.5),
                    labelColor: Theme.of(context).colorScheme.onBackground,
                    controller: tabController,
                    tabs: const [
                      Padding(
                        padding: EdgeInsets.all(12),
                        child: Text('Sign In',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: EdgeInsets.all(12),
                        child: Text('Sign Up',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      )
                    ]),
                Expanded(
                  child: TabBarView(controller: tabController, children: [
                    BlocProvider(
                      create: (context) => SignInBloc(
                          myUserRepository:
                              context.read<AuthBloc>().userRepository),
                      child: const SignInScreen(),
                    ),
                    BlocProvider(
                      create: (context) => SignUpBloc(
                        userRepository: context.read<AuthBloc>().userRepository,
                      ),
                      child: const SignUpScreen(),
                    )
                  ]),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
