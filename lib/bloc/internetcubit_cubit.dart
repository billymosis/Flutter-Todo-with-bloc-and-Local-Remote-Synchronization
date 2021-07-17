import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'package:meta/meta.dart';

part 'internetcubit_state.dart';

class InternetCubit extends Cubit<InternetState> {
  final InternetConnectionChecker connectivity;
  late StreamSubscription connectivityStreamSubscription;

  InternetCubit({required this.connectivity}) : super(InternetLoading()) {
    monitorInternetConnection();
  }

  StreamSubscription<InternetConnectionStatus> monitorInternetConnection() {
    return connectivityStreamSubscription =
        connectivity.onStatusChange.listen((status) {
      switch (status) {
        case InternetConnectionStatus.connected:
          emit(InternetLoading());
          emit(InternetSuccess());
          break;
        case InternetConnectionStatus.disconnected:
          emit(InternetLoading());
          emit(InternetFailure());
          break;
      }
    });
  }

  @override
  Future<void> close() {
    connectivityStreamSubscription.cancel();
    return super.close();
  }
}
