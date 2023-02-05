import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moor_demo/callAPI.dart';
import 'package:moor_demo/utils/shared_pref_helper.dart';

import 'bloc/main_bloc.dart';
import 'navigation/navigation_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefHelper.createInstance();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<MainBloc>(
        create: (BuildContext context) => MainBloc(),
      ),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.lightGreen,
        backgroundColor: Colors.white,
      ),
      home: NavigationPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
