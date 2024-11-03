part of 'add_todo_bloc.dart';

sealed class AddTodoEvent extends Equatable {
  const AddTodoEvent();

  @override
  List<Object> get props => [];
}

class AddTodoAdd extends AddTodoEvent {
  final Todo todo;
  final User user;

  AddTodoAdd(this.todo, this.user);

  @override
  List<Object> get props => [todo, user];
}
