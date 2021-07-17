import 'dart:convert';

import 'package:project_5_sqflite/Data/data_provider.dart';
import 'package:project_5_sqflite/constant.dart';
import 'package:project_5_sqflite/model/todo.dart';
import 'package:http/http.dart' as http;

class DataProviderAPI implements DataProvider {
  final _baseURL = BASE_URL;
  final Map<String, String> header = HTTP_HEADER;
  Future<Todo> createTodo(Todo todo) async {
    final url = '$_baseURL';
    final response = await http.post(
      Uri.parse(url),
      headers: header,
      body: todo.toJson(),
    );
    if (response.statusCode == 201) {
      return Todo.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('Create Error');
    }
  }

  @override
  Future<List<Todo>> loadTodos(String? table) async {
    final response = await http.get(
      Uri.parse('$_baseURL'),
      headers: header,
    );
    if (response.statusCode == 200) {
      List<dynamic> y = jsonDecode(response.body);
      List<Todo> resultOnline = y.map((e) => Todo.fromMap(e)).toList();
      return resultOnline;
    } else {
      throw Exception('Failed to load');
    }
  }

  @override
  Future<List<Todo>> saveTodos(List<Todo> todos, String? table) async {
    throw UnimplementedError();
  }

  @override
  Future<String> deleteTodo(Todo todo) async {
    final response = await http.delete(
      Uri.parse('$_baseURL/${todo.id}'),
      headers: header,
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to delete');
    }
  }

  @override
  Future<Todo> updateTodo(Todo todo) async {
    final response = await http.put(
      Uri.parse('$_baseURL/${todo.id}'),
      headers: header,
      body: todo.toJson(),
    );
    if (response.statusCode == 200) {
      return Todo.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update');
    }
  }

  @override
  Future deleteTodos(String table) {
    throw UnimplementedError();
  }

  Future<dynamic> syncTodo(String todos) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseURL/sync'),
            headers: header,
            body: todos,
          )
          .timeout(Duration(seconds: 30));
      if (response.statusCode == 200) {
        var y = jsonDecode(response.body);
        return y;
      } else {
        throw Exception('Failed to update');
      }
    } catch (e) {
      http.Client().close();
      throw Exception(e);
    }
  }
}
