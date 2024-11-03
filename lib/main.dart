import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:todo_app/config/routes.dart';
import 'package:todo_app/config/themes/theme_data.dart';
import 'package:todo_app/core/resources/remote_config.dart';
import 'package:todo_app/features/global_bloc/bloc/auth_bloc.dart';
import 'package:todo_app/features/home/bloc/bloc/todo_bloc.dart';
import 'package:todo_app/features/home/todo_detail/bloc/bloc/todo_detail_bloc.dart';
import 'package:todo_app/firebase_options.dart';
import 'package:todo_app/service_locater.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(minutes: 1),
    minimumFetchInterval: const Duration(hours: 1),
  ));
  await remoteConfig.fetchAndActivate();
  FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
  initialize();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance);
  PlatformDispatcher.instance.onError = (exception, stackTrace) {
    FirebaseCrashlytics.instance
        .recordError(exception, stackTrace, fatal: true);
    return true;
  };
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, screenType) {
      return MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>(
              create: (context) => sl<AuthBloc>()..add(AuthCheckRequested()),
            ),
            BlocProvider<TodoBloc>(
              create: (context) => sl<TodoBloc>(),
            ),
            BlocProvider<TodoDetailBloc>(
              create: (context) => sl<TodoDetailBloc>(),
            ),
          ],
          child: MaterialApp.router(
            routerDelegate: router.routerDelegate,
            routeInformationParser: router.routeInformationParser,
            routeInformationProvider: router.routeInformationProvider,
            title: 'Todo App',
            theme: theme(),
            builder: (context, child) {
              return child!;
            },
          ));
    });
  }
}
