import 'package:flutter/material.dart';
import 'package:flutter_machine_learning/clock_view.dart';
import 'package:flutter_machine_learning/faceDetectorApp.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ClockView(),
    );
  }
}
