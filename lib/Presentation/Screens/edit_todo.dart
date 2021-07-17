import 'package:flutter/material.dart';
import 'package:project_5_sqflite/model/todo.dart';

class AddOrEditTodo extends StatefulWidget {
  final bool isEditing;
  final Function(String title) onSave;
  final Todo? todo;
  const AddOrEditTodo({
    Key? key,
    required this.isEditing,
    required this.onSave,
    this.todo,
  }) : super(key: key);

  @override
  _AddOrEditTodoState createState() => _AddOrEditTodoState();
}

class _AddOrEditTodoState extends State<AddOrEditTodo> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Todo todo = widget.todo ?? Todo(title: '');
    String? _title;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit Todo' : 'Add Todo'),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('id: ${todo.id}'),
            Text('created_at: ${(todo.createdAt)}'),
            Text('updated_at: ${todo.updatedAt}'),
            Text('status: ${todo.done}'),
            Form(
              key: _formKey,
              child: TextFormField(
                initialValue: widget.isEditing ? todo.title : '',
                autofocus: true,
                onSaved: (newValue) {
                  _title = newValue;
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(widget.isEditing ? Icons.edit : Icons.add),
        onPressed: () {
          _formKey.currentState!.save();
          print(_title!);
          widget.onSave(_title!);
          Navigator.pop(context);
        },
      ),
    );
  }
}
