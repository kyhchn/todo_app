import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/core/resources/data_state.dart';
import 'package:todo_app/data/models/remote/todo.dart';
import 'package:todo_app/data/repository/todo_repository.dart';

part 'todo_detail_event.dart';
part 'todo_detail_state.dart';

class TodoDetailBloc extends Bloc<TodoDetailEvent, TodoDetailState> {
  TodoDetailBloc(this._todoRepository) : super(TodoDetailInitial()) {
    on<TodoDetailLoad>(_onGetTodoDetail);
    on<TodoDetailDelete>(_deleteTodo);
    on<TodoDetailUpdate>(_updateTodo);
  }

  final TodoRepository _todoRepository;

  void _onGetTodoDetail(
    TodoDetailLoad event,
    Emitter<TodoDetailState> emit,
  ) async {
    emit(TodoDetailLoading());
    final result = await _todoRepository.getTodoDetail(event.id, event.user);

    if (result is DataSuccess) {
      emit(TodoDetailLoaded(result.data!));
    } else {
      emit(TodoDetailError(result.message!));
    }
  }

  void _deleteTodo(
    TodoDetailDelete event,
    Emitter<TodoDetailState> emit,
  ) async {
    emit(TodoDetailLoading());
    final result = await _todoRepository.deleteTodo(
      event.user,
      event.id,
    );

    if (result is DataSuccess) {
      emit(TodoDetailDeleted());
    } else {
      emit(TodoDetailError(result.message!));
    }
  }

  void _updateTodo(
    TodoDetailUpdate event,
    Emitter<TodoDetailState> emit,
  ) async {
    emit(TodoDetailLoading());
    await _todoRepository.updateTodo(
      event.user,
      event.todo,
    );

    final result =
        await _todoRepository.getTodoDetail(event.todo.id, event.user);

    if (result is DataSuccess) {
      emit(TodoDetailUpdated(result.data!));
    } else {
      emit(TodoDetailError(result.message!));
    }
  }
}
