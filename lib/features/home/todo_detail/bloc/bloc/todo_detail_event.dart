part of 'todo_detail_bloc.dart';

sealed class TodoDetailEvent extends Equatable {
  const TodoDetailEvent();

  @override
  List<Object> get props => [];
}

class TodoDetailLoad extends TodoDetailEvent {
  final String id;
  final User user;

  TodoDetailLoad(this.id, this.user);

  @override
  List<Object> get props => [id];
}

class TodoDetailUpdate extends TodoDetailEvent {
  final Todo todo;
  final User user;

  TodoDetailUpdate(this.todo, this.user);

  @override
  List<Object> get props => [todo];
}

class TodoDetailDelete extends TodoDetailEvent {
  final String id;
  final User user;

  TodoDetailDelete(this.id, this.user);

  @override
  List<Object> get props => [id];
}
