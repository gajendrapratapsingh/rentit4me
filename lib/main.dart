import 'package:flutter/material.dart';
import 'package:rentit4me/views/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rentit4me',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: SplashScreen()
    );
  }
}
