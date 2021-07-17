part of 'todos_bloc.dart';

@immutable
abstract class TodosState extends Equatable {
  const TodosState();
}

class TodosLoadInProgress extends TodosState {
  const TodosLoadInProgress();

  @override
  List<Object?> get props => [];
}

class TodosLoadSuccess extends TodosState {
  const TodosLoadSuccess({
    this.todos = const [],
  });
  final List<Todo> todos;

  @override
  List<Object?> get props => [todos];
}

class TodosLoadFailure extends TodosState {
  final String message;
  const TodosLoadFailure(this.message);

  @override
  List<Object?> get props => [message];
}
