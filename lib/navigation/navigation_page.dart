import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moor_demo/bloc/main_bloc.dart';
import 'package:moor_demo/callAPI.dart';

class NavigationPage extends StatefulWidget {
  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  MainBloc bloc;

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<MainBloc>(context);
    bloc.add(CallAPI());
    return Scaffold(
      body: BlocBuilder<MainBloc, MainStates>(builder: (context, state) {
        if (state == MainStates.CallAPI) {
          return callAPIScreen();
        }
      }),
    );
  }
}
