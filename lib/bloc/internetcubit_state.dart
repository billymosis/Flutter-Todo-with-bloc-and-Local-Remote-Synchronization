part of 'internetcubit_cubit.dart';

@immutable
abstract class InternetState {}

class InternetLoading extends InternetState {}

class InternetSuccess extends InternetState {}

class InternetFailure extends InternetState {}
