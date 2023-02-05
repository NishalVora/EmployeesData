part of 'main_bloc.dart';

@immutable
abstract class MainEvent {}

class CallAPI extends MainEvent {
  CallAPI();
}