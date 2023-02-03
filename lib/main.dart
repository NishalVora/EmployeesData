import 'package:flutter/material.dart';
import 'package:moor_demo/callAPI.dart';

void main() {
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
    );
  }
}
