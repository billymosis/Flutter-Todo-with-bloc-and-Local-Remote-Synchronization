import 'dart:convert';

import 'package:uuid/uuid.dart';

final String todoTable = 'todos';
final String todoTableUpdate = 'todos_update';
final String todoTableCreate = 'todos_create';
final String todoTableDelete = 'todos_delete';

class TodoField {
  static final List<String> values = [id, title, done, createdAt, updatedAt];
  static final String id = 'id';
  static final String title = 'title';
  static final String done = 'done';
  static final String createdAt = 'created_at';
  static final String updatedAt = 'updated_at';
}

class Todo {
  String id;
  String title;
  bool done;
  String createdAt;
  String updatedAt;
  Todo({
    String? id,
    required this.title,
    this.done = false,
    String? createdAt,
    String? updatedAt,
  })  : id = id ?? Uuid().v4(),
        createdAt = createdAt ??
            DateTime.now()
                .toUtc()
                .toIso8601String()
                .replaceAll('T', ' ')
                .replaceAll('Z', ''),
        updatedAt = updatedAt ??
            DateTime.now()
                .toUtc()
                .toIso8601String()
                .replaceAll('T', ' ')
                .replaceAll('Z', '');

  Map<String, dynamic> toMap() {
    return {
      TodoField.id: id,
      TodoField.title: title,
      TodoField.done: done ? 1 : 0,
      TodoField.createdAt: createdAt.replaceAll('T', ' ').replaceAll('Z', ''),
      TodoField.updatedAt: updatedAt.replaceAll('T', ' ').replaceAll('Z', ''),
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    var target = map[TodoField.done];
    bool result;
    if (target == "1" || target == 1) {
      result = true;
    } else {
      result = false;
    }
    return Todo(
      id: map[TodoField.id],
      title: map[TodoField.title],
      done: result,
      createdAt: map[TodoField.createdAt],
      updatedAt: map[TodoField.updatedAt],
    );
  }

  String toJson() => json.encode(toMap());

  factory Todo.fromJson(dynamic source) => Todo.fromMap(source);

  @override
  String toString() {
    return 'Todo(id: $id, title: $title, done: $done, created_at: $createdAt, updated_at: $updatedAt)';
  }

  Todo copyWith({
    String? id,
    String? title,
    bool? done,
    String? createdAt,
    String? updatedAt,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      done: done ?? this.done,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
