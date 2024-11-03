part of 'todo_detail_bloc.dart';

sealed class TodoDetailState extends Equatable {
  const TodoDetailState();

  @override
  List<Object> get props => [];
}

final class TodoDetailInitial extends TodoDetailState {}

final class TodoDetailLoading extends TodoDetailState {}

final class TodoDetailLoaded extends TodoDetailState {
  final Todo todo;

  TodoDetailLoaded(this.todo);

  @override
  List<Object> get props => [todo];
}

final class TodoDetailError extends TodoDetailState {
  final String message;

  TodoDetailError(this.message);

  @override
  List<Object> get props => [message];
}

final class TodoDetailUpdated extends TodoDetailState {
  final Todo todo;

  TodoDetailUpdated(this.todo);
}

final class TodoDetailDeleted extends TodoDetailState {}
