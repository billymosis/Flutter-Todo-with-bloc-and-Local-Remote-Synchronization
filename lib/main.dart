import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:project_5_sqflite/Data/data_provider_sqlite.dart';
import 'package:project_5_sqflite/bloc/internetcubit_cubit.dart';

import 'package:project_5_sqflite/bloc/todos_bloc.dart';
import 'package:project_5_sqflite/counter_observer.dart';
import 'package:project_5_sqflite/Presentation/router.dart';

void main() {
  Bloc.observer = CounterObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final InternetConnectionChecker connectivity = InternetConnectionChecker();
  final _router = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<InternetCubit>(
            create: (context) => InternetCubit(connectivity: connectivity)
              ..emit(InternetLoading())),
        BlocProvider<TodosBloc>(
            create: (context) => TodosBloc(DataProviderOfflineSQLITE())
              ..add(TodosLoaded(todos: [])))
      ],
      child: MaterialApp(
        title: 'SQFLite TODO LIST',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        onGenerateRoute: _router.onGenerateRoute,
      ),
    );
  }
}
