import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rentit4me/views/category_screen.dart';
import 'package:rentit4me/views/home_screen.dart';
import 'package:rentit4me/views/login_screen.dart';
import 'package:rentit4me/views/signup_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  final Color backgroundColor = Colors.white;
  final TextStyle styleTextUnderTheLoader = TextStyle(
      fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _loggedIn = false;
  final splashDelay = 3;

  @override
  void initState() {
    super.initState();
    _checkLoggedIn();
     _loadWidget();
  }

  _checkLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var _isLoggedIn = prefs.getBool('logged_in');
    if (_isLoggedIn == true) {
      setState(() {
        //_loggedIn = _isLoggedIn;
      });
    } else {
      setState(() {
        _loggedIn = false;
      });
    }
  }

  _loadWidget() async {
    var _duration = Duration(seconds: splashDelay);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => homeOrLog()));
  }

  Widget homeOrLog() {
    if (this._loggedIn) {
      var obj = 0;
      return HomeScreen();
    } else {
      //return HomeScreen();
      return LoginScreen();
      //return CategoryScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Image.asset(
            'assets/images/logo.png',
            scale: 10,
          ),
        )
    );
  }
}
