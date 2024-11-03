import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/core/resources/data_state.dart';
import 'package:todo_app/data/models/remote/todo.dart';
import 'package:todo_app/data/repository/todo_repository.dart';

part 'add_todo_event.dart';
part 'add_todo_state.dart';

class AddTodoBloc extends Bloc<AddTodoEvent, AddTodoState> {
  AddTodoBloc(this._todoRepository) : super(AddTodoInitial()) {
    on<AddTodoAdd>(_onAddTodo);
  }

  TodoRepository _todoRepository;

  void _onAddTodo(
    AddTodoAdd event,
    Emitter<AddTodoState> emit,
  ) async {
    emit(AddTodoLoading());
    final result = await _todoRepository.addTodo(
      event.user,
      event.todo,
    );

    if (result is DataSuccess) {
      emit(AddTodoSuccess());
    } else {
      emit(AddTodoError(result.message!));
    }
  }
}
