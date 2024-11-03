import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo_app/data/repository/auth_repository.dart';
import 'package:todo_app/data/repository/todo_repository.dart';
import 'package:todo_app/features/global_bloc/bloc/auth_bloc.dart';
import 'package:todo_app/features/home/add_todo/bloc/bloc/add_todo_bloc.dart';
import 'package:todo_app/features/home/bloc/bloc/todo_bloc.dart';
import 'package:todo_app/features/home/todo_detail/bloc/bloc/todo_detail_bloc.dart';

final sl = GetIt.instance;

void initialize() {
  //general
  sl.registerSingleton(GoogleSignIn());
  sl.registerSingleton(FirebaseAuth.instance);
  sl.registerSingleton(FirebaseFirestore.instance);
  sl.registerSingleton(FirebaseAnalytics.instance);

  //REPOSITORY
  sl.registerSingleton(AuthRepository(sl(), sl()));
  sl.registerSingleton(TodoRepository(sl(), sl()));

  //Bloc
  sl.registerSingleton(AuthBloc(sl()));
  sl.registerSingleton(TodoBloc(sl()));
  sl.registerFactory(() => AddTodoBloc(sl()));
  sl.registerFactory(() => TodoDetailBloc(sl()));
}
