import 'package:flutter/material.dart';
import 'view_home.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const MyHomePage(title: "My Flutter"),
    );
  }
}
