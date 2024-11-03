import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/core/utils/helper.dart';
import 'package:todo_app/features/global_bloc/bloc/auth_bloc.dart';
import 'package:todo_app/features/home/add_todo/presentation/add_todo_screen.dart';
import 'package:todo_app/features/home/bloc/bloc/todo_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/features/home/todo_detail/presentation/todo_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            if (authState is AuthSuccess) {
              // Load todos once the user is authenticated
              context.read<TodoBloc>().add(TodoLoad(authState.user));

              return BlocConsumer<TodoBloc, TodoState>(
                listener: (context, todoState) {},
                builder: (context, todoState) {
                  if (todoState is TodoInitial || todoState is TodoLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (todoState is TodoLoaded) {
                    return ListView.builder(
                      itemCount: todoState.todos.length,
                      itemBuilder: (context, index) {
                        final todo = todoState.todos[index];
                        return ListTile(
                          title: Text(todo.title),
                          onTap: () {
                            context.push(
                              "${HomeScreen.routeName}${TodoDetailScreen.routeName}",
                              extra: {
                                'id': todo.id,
                                'user': authState.user,
                              },
                            );
                          },
                          subtitle: Text(todo.dueDate != null
                              ? "Due: ${formatDate(todo.dueDate!)}"
                              : 'No Due Date'),
                          trailing: Checkbox(
                            value: todo.isCompleted,
                            onChanged: (bool? value) {
                              if (value != null) {
                                // Dispatch event to update the todo's completion status
                                context.read<TodoBloc>().add(
                                      TodoUpdate(
                                          todo.copyWith(isCompleted: value),
                                          authState.user,
                                          isCompleted: value),
                                    );
                              }
                            },
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: Text('Error loading todos'),
                    );
                  }
                },
              );
            } else {
              return const Center(
                child: Text('Authentication Error'),
              );
            }
          },
        ),
      ),
      // Sign Out Button
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, authState) {
              if (authState is AuthSuccess) {
                return BlocBuilder<TodoBloc, TodoState>(
                  builder: (context, todoState) {
                    if (todoState is TodoLoaded) {
                      // Add Todo button, only visible when todos are loaded
                      return FloatingActionButton(
                        heroTag: 'addTodoButton',
                        onPressed: () {
                          // FirebaseCrashlytics.instance.crash();
                          context.push(
                            "${HomeScreen.routeName}${AddTodoScreen.routeName}",
                            extra: authState.user,
                          );
                        },
                        child: const Icon(Icons.add),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
          const SizedBox(height: 10),
          // Logout Button
          FloatingActionButton(
            heroTag: 'logoutButton',
            onPressed: () async {
              await FirebaseAnalytics.instance.logEvent(
                name: 'tess',
              );
              // context.read<AuthBloc>().add(AuthSignedOut());
            },
            child: const Icon(Icons.logout),
          ),
        ],
      ),
    );
  }
}
