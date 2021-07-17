import 'dart:convert';

class DeleteTodo {
  final String id;

  DeleteTodo(this.id);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
    };
  }

  factory DeleteTodo.fromMap(Map<String, dynamic> map) {
    return DeleteTodo(
      map['id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory DeleteTodo.fromJson(String source) =>
      DeleteTodo.fromMap(json.decode(source));

  @override
  String toString() => 'DeleteTodo(id: $id)';
}
