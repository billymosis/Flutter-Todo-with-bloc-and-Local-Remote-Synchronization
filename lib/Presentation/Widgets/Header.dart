import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_5_sqflite/Data/data_provider_memory.dart';
import 'package:project_5_sqflite/Data/data_provider_sqlite.dart';
import 'package:project_5_sqflite/bloc/todos_bloc.dart';

class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                (BlocProvider.of<TodosBloc>(context).todoRepository
                        is DataProviderOfflineSQLITE)
                    ? TextButton(
                        onPressed: () {
                          BlocProvider.of<TodosBloc>(context)
                              .add(TodosSynchronized());
                        },
                        child: Text('Sync'))
                    : Container(),
                (BlocProvider.of<TodosBloc>(context).todoRepository
                        is DataProviderMemory)
                    ? TextButton(
                        onPressed: () {
                          BlocProvider.of<TodosBloc>(context)
                              .add(TodosDeleteAll());
                        },
                        child: Text('delete All'))
                    : Container()
              ],
            )
          ],
        ));
  }
}
