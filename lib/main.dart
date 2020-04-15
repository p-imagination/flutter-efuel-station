import 'package:flutter/material.dart';

import 'Main_Screen.dart';
import 'Splash_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Efuel Station',
      debugShowCheckedModeBanner: false,
      home: Splash_Screen(),
     // home: Main_Screen(),
    );
  }
}

