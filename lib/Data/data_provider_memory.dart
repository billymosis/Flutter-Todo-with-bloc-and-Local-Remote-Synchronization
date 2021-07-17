import 'package:project_5_sqflite/Data/data_provider.dart';
import 'package:project_5_sqflite/model/todo.dart';

class DataProviderMemory implements DataProvider {
  final List<Todo> _todos = [];
  final Duration duration = Duration(seconds: 1);

  @override
  Future<List<Todo>> loadTodos(String? table) {
    return Future.delayed(duration, () {
      return _todos;
    });
  }

  @override
  Future<List<Todo>> saveTodos(List<Todo> todos, String? table) {
    return Future.delayed(duration, () {
      return _todos
        ..clear()
        ..addAll(todos);
    });
  }

  @override
  Future<Todo> createTodo(Todo todo) {
    return Future.delayed(duration, () {
      _todos.add(todo);
      return todo;
    });
  }

  @override
  Future<String> deleteTodo(Todo todo) {
    return Future.delayed(duration, () {
      _todos.remove(todo);
      return todo.id;
    });
  }

  @override
  Future<Todo> updateTodo(Todo todo) {
    return Future.delayed(duration, () {
      var index = _todos.indexWhere((element) => element.id == todo.id);
      _todos[index] = todo;
      return todo;
    });
  }

  @override
  Future deleteTodos(String table) {
    return Future.delayed(duration, () {
      return _todos..clear();
    });
  }
}
