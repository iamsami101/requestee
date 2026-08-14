import 'package:flutter/material.dart';

import 'data/app_store.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(RequestTApp(store: AppStore()));
}

class RequestTApp extends StatelessWidget {
  const RequestTApp({super.key, required this.store});

  final AppStore store;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'requesT',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: HomeScreen(store: store),
    );
  }
}
