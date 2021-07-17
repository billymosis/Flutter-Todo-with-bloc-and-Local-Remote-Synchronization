import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_5_sqflite/Data/data_provider_api.dart';
import 'package:project_5_sqflite/Data/data_provider_memory.dart';
import 'package:project_5_sqflite/Data/data_provider_sqlite.dart';

import 'package:project_5_sqflite/Presentation/Widgets/Header.dart';
import 'package:project_5_sqflite/Presentation/Widgets/TodoBody.dart';
import 'package:project_5_sqflite/bloc/todos_bloc.dart';
import 'package:project_5_sqflite/constant.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Container(
                child: Text(
                  '''
API Target: $BASE_URL
API Token: $API_TOKEN
''',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 10),
                ),
              ),
            ),
            ListTile(
              title: Text('Online API'),
              onTap: () {
                BlocProvider.of<TodosBloc>(context).todoRepository =
                    DataProviderAPI();
                BlocProvider.of<TodosBloc>(context).add(TodosLoaded(todos: []));
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Offline SQLITE'),
              onTap: () {
                BlocProvider.of<TodosBloc>(context).todoRepository =
                    DataProviderOfflineSQLITE();
                BlocProvider.of<TodosBloc>(context).add(TodosLoaded(todos: []));
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Fake Memory API'),
              onTap: () {
                BlocProvider.of<TodosBloc>(context).todoRepository =
                    DataProviderMemory();
                BlocProvider.of<TodosBloc>(context).add(TodosLoaded(todos: []));
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('TODOS APP'),
      ),
      body: BlocConsumer<TodosBloc, TodosState>(
        builder: (context, state) {
          switch (state.runtimeType) {
            case TodosLoadInProgress:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [CircularProgressIndicator()],
                ),
              );
            case TodosLoadSuccess:
              return Column(
                children: [
                  Header(),
                  Expanded(child: TodosBody()),
                ],
              );
            case TodosLoadFailure:
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text((state as TodosLoadFailure).message),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                          onPressed: () {
                            BlocProvider.of<TodosBloc>(context)
                                .add(TodosLoaded(todos: []));
                          },
                          child: Text('Back To Home')),
                      TextButton(
                          onPressed: () {
                            BlocProvider.of<TodosBloc>(context).todoRepository =
                                DataProviderAPI();
                            BlocProvider.of<TodosBloc>(context)
                                .add(TodosLoaded(todos: []));
                          },
                          child: Text('Change Online API')),
                      TextButton(
                          onPressed: () {
                            BlocProvider.of<TodosBloc>(context).todoRepository =
                                DataProviderOfflineSQLITE();
                            BlocProvider.of<TodosBloc>(context)
                                .add(TodosLoaded(todos: []));
                          },
                          child: Text('Change Offline SQLITE')),
                      TextButton(
                          onPressed: () {
                            BlocProvider.of<TodosBloc>(context).todoRepository =
                                DataProviderMemory();
                            BlocProvider.of<TodosBloc>(context)
                                .add(TodosLoaded(todos: []));
                          },
                          child: Text('Change Fake Memory API'))
                    ],
                  )
                ],
              );
            default:
              return Text('default');
          }
        },
        listener: (context, state) {},
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, '/add_todo');
        },
      ),
    );
  }
}
