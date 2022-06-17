import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rentit4me/views/OfferRecievedScreen.dart';
import 'package:rentit4me/views/business_detail_screen.dart';
import 'package:rentit4me/views/dashboard.dart';
import 'package:rentit4me/views/generate_ticket_screen.dart';
import 'package:rentit4me/views/home_screen.dart';
import 'package:rentit4me/views/login_screen.dart';
import 'package:rentit4me/views/myorders_screen.dart';
import 'package:rentit4me/views/myticket_screen.dart';
import 'package:rentit4me/views/offer_made_screen.dart';
import 'package:rentit4me/views/otp_screen.dart';
import 'package:rentit4me/views/personal_detail_screen.dart';
import 'package:rentit4me/views/product_detail_screen.dart';
import 'package:rentit4me/views/signup_business_screen.dart';
import 'package:rentit4me/views/user_detail_screen.dart';
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
        _loggedIn = _isLoggedIn;
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
      //return OfferRecievedScreen();
      //return OfferMadeScreen();
      //return MyOrdersScreen();
      //return MyticketScreen();
      //return GenerateTicketScreen();
      //return ProductDetailScreen();
      //return BankAndBusinessDetailScreen();
      //return PersonalDetailScreen();
      return Dashboard();
    } else {
      //return OfferRecievedScreen();
      //return OfferMadeScreen();
      //return MyOrdersScreen();
      //return MyticketScreen();
      //return GenerateTicketScreen();
      //return HomeScreen();
      //return ProductDetailScreen();
      //return BankAndBusinessDetailScreen();
      //return PersonalDetailScreen();
      return LoginScreen();
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
    ));
  }
}
