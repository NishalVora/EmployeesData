import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
part 'main_event.dart';

enum MainStates {
  CallAPI
}

class MainBloc extends Bloc<MainEvent, MainStates> {
  MainBloc() : super(MainStates.CallAPI);

  @override
  Stream<MainStates> mapEventToState(MainEvent event) async*{
    // TODO: implement mapEventToState
    if (event is CallAPI) {
      yield MainStates.CallAPI;
    }
  }
}