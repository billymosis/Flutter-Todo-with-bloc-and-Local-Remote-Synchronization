import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_5_sqflite/bloc/todos_bloc.dart';

class TodosBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _state = BlocProvider.of<TodosBloc>(context).state as TodosLoadSuccess;
    return ListView.builder(
      itemCount: _state.todos.length,
      itemBuilder: (context, index) {
        return ListTile(
            onTap: () {
              var updatedTodo = _state.todos[index].copyWith(
                  done: _state.todos[index].done ? false : true,
                  updatedAt: DateTime.now()
                      .toUtc()
                      .toIso8601String()
                      .replaceAll('T', ' ')
                      .replaceAll('Z', ''));
              BlocProvider.of<TodosBloc>(context)
                  .add(TodosUpdated(updatedTodo));
            },
            title: Text(
              _state.todos[index].title,
              style: TextStyle(
                decoration: _state.todos[index].done
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    onPressed: () => {
                          BlocProvider.of<TodosBloc>(context)
                              .add(TodosDeleted(_state.todos[index]))
                        },
                    icon: Icon(Icons.delete)),
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/edit_todo',
                          arguments: _state.todos[index]);
                    },
                    icon: Icon(Icons.edit))
              ],
            ));
      },
    );
  }
}
