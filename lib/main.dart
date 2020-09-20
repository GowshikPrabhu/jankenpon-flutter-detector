import 'package:flutter/material.dart';
import 'package:jankenpon/splashscreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jan Ken Pon',
      home: MySplashScreen(),
    );
  }
}
