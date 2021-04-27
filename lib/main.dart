import 'package:babydiary_seulahpark/screens/calendar_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Baby Diary',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: CalendarScreen(),
      routes: {
        '/calendar': (context) => CalendarScreen(),
      },
    );
  }
}
