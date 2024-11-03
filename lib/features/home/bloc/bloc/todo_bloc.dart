import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/core/resources/data_state.dart';
import 'package:todo_app/data/models/remote/todo.dart';
import 'package:todo_app/data/repository/todo_repository.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc(this._todoRepository) : super(TodoInitial()) {
    on<TodoLoad>(_onGetAllTodos);
    on<TodoUpdate>(_updateTodo);
  }

  TodoRepository _todoRepository;

  void _onGetAllTodos(
    TodoLoad event,
    Emitter<TodoState> emit,
  ) async {
    emit(TodoLoading());
    final result = await _todoRepository.getAllTodos(event.user);

    if (result is DataSuccess) {
      emit(TodoLoaded(result.data!));
    } else {
      emit(TodoError(result.message!));
    }
  }

  void _updateTodo(
    TodoUpdate event,
    Emitter<TodoState> emit,
  ) async {
    emit(TodoLoading());
    await _todoRepository.updateTodo(
      event.user,
      event.todo,
      isCompleted: event.isCompleted,
    );

    final result = await _todoRepository.getAllTodos(event.user);

    if (result is DataSuccess) {
      emit(TodoLoaded(result.data!));
    } else {
      emit(TodoError(result.message!));
    }
  }
}
