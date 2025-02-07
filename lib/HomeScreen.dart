import 'package:flutter/material.dart';
import 'ats.dart';

class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, ATSScreen.routeName);
          },
          child: Text('Go to ATS Screen'),
        ),
      ),
    );
  }
}