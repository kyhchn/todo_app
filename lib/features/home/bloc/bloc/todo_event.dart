part of 'todo_bloc.dart';

sealed class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object> get props => [];
}

class TodoLoad extends TodoEvent {
  final User user;

  TodoLoad(this.user);

  @override
  List<Object> get props => [user];
}

class TodoAdd extends TodoEvent {
  final Todo todo;

  TodoAdd(this.todo);

  @override
  List<Object> get props => [todo];
}

class TodoUpdate extends TodoEvent {
  final Todo todo;
  final User user;
  bool isCompleted;

  TodoUpdate(this.todo, this.user, {this.isCompleted = false});

  @override
  List<Object> get props => [todo, user];
}

class TodoDelete extends TodoEvent {
  final String id;

  TodoDelete(this.id);

  @override
  List<Object> get props => [id];
}
