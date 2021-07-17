import 'package:project_5_sqflite/model/todo.dart';

abstract class DataProvider {
  Future<List<Todo>> saveTodos(List<Todo> todos, String table);
  Future deleteTodos(String table);
  Future<List<Todo>> loadTodos(String? table);
  Future<Todo> createTodo(Todo todo);
  Future<Todo> updateTodo(Todo todo);
  Future<String> deleteTodo(Todo todo);
}
