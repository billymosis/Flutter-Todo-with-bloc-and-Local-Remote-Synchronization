import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

import 'package:project_5_sqflite/Data/data_provider.dart';
import 'package:project_5_sqflite/Data/data_provider_api.dart';
import 'package:project_5_sqflite/Data/data_provider_sqlite.dart';
import 'package:project_5_sqflite/Data/database_helper.dart';
import 'package:project_5_sqflite/model/todo.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'todos_event.dart';
part 'todos_state.dart';

class TodosBloc extends Bloc<TodosEvent, TodosState> {
  TodosBloc(this.todoRepository) : super(TodosLoadInProgress());
  DataProvider todoRepository;
  late bool isConnected;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Stream<TodosState> _mapLoadTodosToState() async* {
    yield TodosLoadInProgress();
    try {
      final todos = await todoRepository.loadTodos(todoTable);
      yield TodosLoadSuccess(todos: todos);
    } catch (e) {
      yield TodosLoadFailure('Load Error');
    }
  }

  Stream<TodosState> _mapAddTodoToState(
    TodosAdded event,
    TodosState state,
  ) async* {
    yield TodosLoadInProgress();
    try {
      final List<Todo> updatedTodo = [
        event.todo,
        ...(state as TodosLoadSuccess).todos
      ];
      await todoRepository.createTodo(event.todo);
      yield TodosLoadSuccess(todos: updatedTodo);
    } catch (e) {
      yield TodosLoadFailure('Failure Creating Todo');
    }
  }

  Stream<TodosState> _mapDeleteTodoToState(
      TodosDeleted event, TodosState state) async* {
    yield TodosLoadInProgress();
    try {
      final List<Todo> updatedTodo = (state as TodosLoadSuccess).todos
        ..removeWhere((element) => element == event.todo);
      yield TodosLoadSuccess(todos: updatedTodo);
      await todoRepository.deleteTodo(event.todo);
    } catch (e) {
      yield TodosLoadFailure('Delete Error');
    }
  }

  Stream<TodosState> _mapUpdateTodoToState(
      TodosUpdated event, TodosState state) async* {
    try {
      final List<Todo> updatedTodo = (state as TodosLoadSuccess).todos;
      int index =
          updatedTodo.indexWhere((element) => element.id == event.todo.id);
      updatedTodo[index] = event.todo;
      yield TodosLoadSuccess(todos: updatedTodo);
      await todoRepository.updateTodo(event.todo);
      yield* _mapLoadTodosToState();
    } catch (e) {
      yield TodosLoadFailure('Update Error');
    }
  }

  Stream<TodosState> _mapSyncedTodosToState() async* {
    yield TodosLoadInProgress();
    final SharedPreferences prefs = await _prefs;
    String localLastSync = prefs.getString('localLastSync') ?? 'never';
    try {
      dynamic localRequest =
          await DataProviderOfflineSQLITE().synchronize(localLastSync);
      dynamic webResponse =
          await DataProviderAPI().syncTodo(localRequest.toString());
      List<Todo> newTodo = (webResponse['newRecords'] as List<dynamic>)
          .map((e) => Todo.fromMap(e))
          .toList();
      localLastSync = webResponse['lastSync']
          .toString()
          .replaceAll('T', ' ')
          .replaceAll('Z', '');
      todoRepository.saveTodos(newTodo, todoTable);
      yield* _mapLoadTodosToState();
      todoRepository.deleteTodos(todoTableCreate);
      todoRepository.deleteTodos(todoTableUpdate);
      todoRepository.deleteTodos(todoTableDelete);
      prefs.setString('localLastSync', localLastSync);
    } catch (e) {
      yield TodosLoadFailure(e.toString());
    }
  }

  Stream<TodosState> _mapTodoCheckDebug(
      TodoChecked event, TodosState state) async* {
    printWarning((await todoRepository.loadTodos(todoTable)).toString());
    var x = await DatabaseHelper.instance.readAll(todoTableUpdate);
    var y = await DatabaseHelper.instance.readAll(todoTableCreate);
    var z = await DatabaseHelper.instance.readDeleted();
    printWarning("created: " + y.toString());
    printWarning("updated: " + x.toString());
    printWarning("deleted: " + z.toString());
  }

  @override
  Stream<TodosState> mapEventToState(
    TodosEvent event,
  ) async* {
    switch (event.runtimeType) {
      case TodosLoaded:
        yield* _mapLoadTodosToState();
        break;
      case TodosAdded:
        yield* _mapAddTodoToState((event as TodosAdded), state);
        break;
      case TodosUpdated:
        yield* _mapUpdateTodoToState((event as TodosUpdated), state);
        break;
      case TodosDeleted:
        yield* _mapDeleteTodoToState((event as TodosDeleted), state);
        break;
      case TodoChecked:
        yield* _mapTodoCheckDebug((event as TodoChecked), state);
        break;
      case TodosSynchronized:
        yield* _mapSyncedTodosToState();
        break;
      case InternetChecked:
        isConnected = (event as InternetChecked).mybool;
        break;
      case TodosDeleteAll:
        todoRepository.deleteTodos(todoTable);
        yield* _mapLoadTodosToState();
        break;
      default:
    }
  }

  void printWarning(String text) {
    print('\x1B[31m$text\x1B[0m');
  }
}
