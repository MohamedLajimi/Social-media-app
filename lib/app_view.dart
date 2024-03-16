import 'package:flutter/material.dart';
import 'package:flutter_application_1/blocs/auth_bloc/auth_bloc.dart';
import 'package:flutter_application_1/blocs/my_user_bloc/my_user_bloc.dart';
import 'package:flutter_application_1/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:flutter_application_1/blocs/update_user_info_bloc/update_user_info_bloc.dart';
import 'package:flutter_application_1/constants/colors.dart';
import 'package:flutter_application_1/screens/features/main_screen.dart';
import 'package:flutter_application_1/screens/auth/welcome_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'WePost',
        theme: ThemeData(
            fontFamily: 'Jost',
            colorScheme: const ColorScheme.light(
                primary: primaryColor, outline: primaryColor)),
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state.status == AuthStatus.authenticated) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => SignInBloc(
                        myUserRepository:
                            context.read<AuthBloc>().userRepository),
                  ),
                  BlocProvider(
                    create: (context) => UpdateUserInfoBloc(
                        userRepository:
                            context.read<AuthBloc>().userRepository),
                  ),
                  BlocProvider(
                    create: (context) => MyUserBloc(
                        myUserRepository:
                            context.read<AuthBloc>().userRepository)
                      ..add(GetMyUser(
                          myUserId: context.read<AuthBloc>().state.user!.uid)),
                  ),
                ],
                child: const MainScreen(),
              );
             
            } else {
              return const WelcomeScreen();
            }
          },
        ));
  }
}
