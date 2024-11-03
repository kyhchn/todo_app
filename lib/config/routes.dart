import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/features/auth/presentation/auth_screen.dart';
import 'package:todo_app/features/home/add_todo/bloc/bloc/add_todo_bloc.dart';
import 'package:todo_app/features/home/add_todo/presentation/add_todo_screen.dart';
import 'package:todo_app/features/home/presentation/home_screen.dart';
import 'package:todo_app/features/home/todo_detail/bloc/bloc/todo_detail_bloc.dart';
import 'package:todo_app/features/home/todo_detail/presentation/todo_detail_screen.dart';
import 'package:todo_app/features/splash_screen.dart';
import 'package:todo_app/service_locater.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: SplashScreen.routeName,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AuthScreen.routeName,
      builder: (context, state) => const AuthScreen(),
    ),
    GoRoute(
        path: HomeScreen.routeName,
        builder: (context, state) => const HomeScreen(),
        routes: [
          ShellRoute(
            builder: (context, state, child) {
              return BlocProvider<AddTodoBloc>(
                create: (context) => sl<AddTodoBloc>(),
                child: child,
              );
            },
            routes: [
              GoRoute(
                path: AddTodoScreen.routeName,
                builder: (context, state) => AddTodoScreen(
                  user: state.extra as User,
                ),
              ),
            ],
          ),
          ShellRoute(
            builder: (context, state, child) {
              return BlocProvider<TodoDetailBloc>(
                create: (context) => sl<TodoDetailBloc>(),
                child: child,
              );
            },
            routes: [
              GoRoute(
                  path: TodoDetailScreen.routeName,
                  builder: (context, state) {
                    final data = state.extra as Map<String, dynamic>;
                    return TodoDetailScreen(
                        id: data['id'], user: data['user'] as User);
                  }),
            ],
          )
        ])
  ],
);
