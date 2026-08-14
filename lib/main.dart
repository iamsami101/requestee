import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue, brightness: Brightness.dark),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('RequesT'),
        ),
        body: Center(
          child: Text("Hello World"),
        ),
      ),
    );
  }
}
