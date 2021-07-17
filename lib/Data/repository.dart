import 'package:project_5_sqflite/Data/data_provider.dart';
import 'package:project_5_sqflite/model/todo.dart';

class Repository implements DataProvider {
  DataProvider curretDataProvider;

  Repository(
    this.curretDataProvider,
  );

  @override
  Future<Todo> createTodo(Todo todo) {
    return curretDataProvider.createTodo(todo);
  }

  @override
  Future<String> deleteTodo(Todo todo) {
    return curretDataProvider.deleteTodo(todo);
  }

  @override
  Future<List<Todo>> loadTodos(String? table) {
    return curretDataProvider.loadTodos(table);
  }

  @override
  Future<List<Todo>> saveTodos(List<Todo> todos, String table) {
    return curretDataProvider.saveTodos(todos, table);
  }

  @override
  Future<Todo> updateTodo(Todo todo) {
    return curretDataProvider.updateTodo(todo);
  }

  @override
  Future deleteTodos(String table) {
    return curretDataProvider.deleteTodos(table);
  }
}
