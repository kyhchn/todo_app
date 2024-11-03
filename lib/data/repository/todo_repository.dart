import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/core/resources/data_state.dart';
import 'package:todo_app/data/models/remote/todo.dart';

class TodoRepository {
  FirebaseFirestore _firestore;
  FirebaseAnalytics _analytics;
  final firebaseAnalytics = FirebaseAnalytics.instance;
  TodoRepository(this._firestore, this._analytics);
  Future<DataState<List<Todo>>> getAllTodos(User user) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('todos')
          .orderBy('createdAt', descending: true)
          .get();
      final todos = snapshot.docs.map((e) => Todo.fromFirestore(e)).toList();
      return DataSuccess(todos);
    } catch (e) {
      return DataInternalError(e.toString());
    }
  }

  Future<DataState<void>> addTodo(User user, Todo todo) async {
    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('todos')
          .add(todo.toFirestore());
      await firebaseAnalytics.logEvent(name: 'add_todo', parameters: {
        'user': user.uid,
        'todo': todo.id,
      });
      return DataSuccess(null);
    } catch (e) {
      return DataInternalError(e.toString());
    }
  }

  Future<DataState<void>> updateTodo(
    User user,
    Todo todo, {
    bool isCompleted = false,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('todos')
          .doc(todo.id)
          .update(todo.toFirestore());
      if (isCompleted) {
        print('invoked');
        await firebaseAnalytics.logEvent(name: 'complete_todo', parameters: {
          'user': user.uid,
          'todo': todo.id,
        });
      }
      return DataSuccess(null);
    } catch (e) {
      return DataInternalError(e.toString());
    }
  }

  Future<DataState<void>> deleteTodo(User user, String id) async {
    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('todos')
          .doc(id)
          .delete();

      await firebaseAnalytics.logEvent(name: 'delete_todo', parameters: {
        'user': user.uid,
        'todo': id,
      });

      return DataSuccess(null);
    } catch (e) {
      return DataInternalError(e.toString());
    }
  }

  Future<DataState<Todo>> getTodoDetail(String id, User user) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('todos')
          .doc(id)
          .get();
      final todo = Todo.fromFirestore(snapshot);
      return DataSuccess(todo);
    } catch (e) {
      return DataInternalError(e.toString());
    }
  }
}
