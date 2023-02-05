import 'package:flutter/material.dart';
import 'package:moor_demo/callAPI.dart';
import 'package:moor_demo/utils/shared_pref_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefHelper.createInstance();
  runApp(MyApp());
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
      home: callAPI(),
      debugShowCheckedModeBanner: false,
    );
  }
}
