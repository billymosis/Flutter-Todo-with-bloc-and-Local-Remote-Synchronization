part of 'todos_bloc.dart';

@immutable
abstract class TodosEvent extends Equatable {
  const TodosEvent();
}

class TodosLoaded extends TodosEvent {
  final List<Todo> todos;
  TodosLoaded({required this.todos});

  @override
  List<Object?> get props => [todos];
}

class TodosAdded extends TodosEvent {
  final Todo todo;
  TodosAdded(this.todo);

  @override
  List<Object?> get props => [todo];
}

class TodoChecked extends TodosEvent {
  @override
  List<Object?> get props => [];
}

class TodosUpdated extends TodosEvent {
  final Todo todo;

  TodosUpdated(this.todo);

  @override
  List<Object?> get props => [todo];
}

class TodosDeleted extends TodosEvent {
  final Todo todo;

  TodosDeleted(this.todo);

  @override
  List<Object?> get props => [todo];
}

class InternetChecked extends TodosEvent {
  final bool mybool;

  InternetChecked(this.mybool);
  @override
  List<Object?> get props => [mybool];
}

class TodosSynchronized extends TodosEvent {
  TodosSynchronized();

  @override
  List<Object?> get props => [];
}

class TodosDeleteAll extends TodosEvent {
  @override
  List<Object?> get props => [];
}
