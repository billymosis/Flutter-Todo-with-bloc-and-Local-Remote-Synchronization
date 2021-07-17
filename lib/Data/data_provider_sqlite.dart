import 'dart:convert';

import 'package:project_5_sqflite/Data/data_provider.dart';
import 'package:project_5_sqflite/Data/database_helper.dart';
import 'package:project_5_sqflite/model/deleteTodo.dart';
import 'package:project_5_sqflite/model/todo.dart';

class DataProviderOfflineSQLITE implements DataProvider {
  @override
  Future<List<Todo>> loadTodos(String? table) {
    return DatabaseHelper.instance.readAll(table!);
  }

  @override
  Future<List<Todo>> saveTodos(List<Todo> todos, String? table) {
    for (var item in todos) {
      DatabaseHelper.instance.create(item);
    }
    return DatabaseHelper.instance.readAll(table!);
  }

  @override
  Future<Todo> createTodo(Todo todo) {
    return DatabaseHelper.instance.create(todo);
  }

  @override
  Future<String> deleteTodo(Todo todo) {
    return DatabaseHelper.instance.delete(todo.id);
  }

  @override
  Future<Todo> updateTodo(Todo todo) {
    return DatabaseHelper.instance.update(todo);
  }

  Future synchronize(String localLastSync) async {
    final lastSync = localLastSync;
    List<Todo> create = await DatabaseHelper.instance.readAll(todoTableCreate);
    List<Todo> update = await DatabaseHelper.instance.readAll(todoTableUpdate);
    List<DeleteTodo> delete = await DatabaseHelper.instance.readDeleted();
    var sync = {
      "\"lastSync\"": jsonEncode(lastSync),
      "\"created\"": create.map((e) => e.toJson()).toList(),
      "\"updated\"": update.map((e) => e.toJson()).toList(),
      "\"deleted\"": delete.map((e) => e.toJson()).toList()
    };
    return sync;
  }

  @override
  Future deleteTodos(String table) async {
    await DatabaseHelper.instance.deleteTodos(table);
  }
}
