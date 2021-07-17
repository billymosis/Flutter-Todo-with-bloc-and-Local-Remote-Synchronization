import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:project_5_sqflite/Presentation/Screens/edit_todo.dart';
import 'package:project_5_sqflite/Presentation/Screens/home.dart';
import 'package:project_5_sqflite/bloc/internetcubit_cubit.dart';
import 'package:project_5_sqflite/bloc/todos_bloc.dart';
import 'package:project_5_sqflite/model/todo.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
            builder: (context) => BlocListener<InternetCubit, InternetState>(
                  listener: (context, state) {
                    switch (state.runtimeType) {
                      case InternetSuccess:
                        BlocProvider.of<TodosBloc>(context)
                            .add(InternetChecked(true));
                        BlocProvider.of<TodosBloc>(context)
                            .add(TodosSynchronized());
                        BlocProvider.of<TodosBloc>(context)
                            .add(TodosLoaded(todos: []));
                        break;
                      case InternetFailure:
                        BlocProvider.of<TodosBloc>(context)
                            .add(InternetChecked(false));
                        BlocProvider.of<TodosBloc>(context)
                            .add(TodosLoaded(todos: []));
                        break;
                      case InternetLoading:
                        break;
                      default:
                        throw Exception();
                    }
                  },
                  child: Home(),
                ));

      case '/add_todo':
        return MaterialPageRoute(
          builder: (context) => AddOrEditTodo(
            isEditing: false,
            onSave: (title) => BlocProvider.of<TodosBloc>(context)
                .add(TodosAdded(Todo(title: title))),
          ),
        );

      case '/edit_todo':
        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            final args = ModalRoute.of(context)!.settings.arguments as Todo;
            return AddOrEditTodo(
              isEditing: true,
              onSave: (title) => BlocProvider.of<TodosBloc>(context).add(
                  TodosUpdated(args.copyWith(
                      title: title,
                      updatedAt: DateTime.now()
                          .toUtc()
                          .toIso8601String()
                          .replaceAll('T', ' ')
                          .replaceAll('Z', '')))),
              todo: args,
            );
          },
        );

      default:
        throw Exception();
    }
  }
}
