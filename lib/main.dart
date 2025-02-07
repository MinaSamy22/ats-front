import 'package:flutter/material.dart';
import 'HomeScreen.dart';
import 'ats.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        ATSScreen.routeName: (context) => ATSScreen(),
      },
    );
  }
}
