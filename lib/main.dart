import 'package:flutter/material.dart';
import 'package:taskly/pages/homepage.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter("hive_boxes"); //hive intialization must
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taskly',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: Homepage(),
    );
  }
}

