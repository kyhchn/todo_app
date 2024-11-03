import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/config/themes/colors.dart';
import 'package:todo_app/config/themes/typography.dart';
import 'package:todo_app/core/resources/remote_config.dart';
import 'package:todo_app/features/auth/presentation/auth_screen.dart';
import 'package:todo_app/features/global_bloc/bloc/auth_bloc.dart';
import 'package:todo_app/features/home/presentation/home_screen.dart';
import 'package:todo_app/service_locater.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    print(sl<AuthBloc>().state);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        Future.delayed(const Duration(seconds: 2), () async {
          int minVersion = remoteConfig.getInt('min_version');
          int currentVersion = 1;

          if (currentVersion < minVersion) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Please update the app to the latest version',
                ),
              ),
            );

            return;
          }
          if (state is AuthSuccess) {
            await FirebaseAnalytics.instance.logLogin(
              loginMethod: 'Google',
            );
            context.push(HomeScreen.routeName);
          } else {
            context.push(AuthScreen.routeName);
          }
        });
      },
      child: buildSplash(),
    );
  }

  Scaffold buildSplash() {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Todo App',
              style: h1.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
