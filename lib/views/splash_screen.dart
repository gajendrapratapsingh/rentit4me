import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentit4me/blocs/network_bloc/network_state.dart';
import 'package:rentit4me/network/api.dart';
import 'package:rentit4me/views/dashboard.dart';
import 'package:rentit4me/views/delivery_status_screen.dart';
import 'package:rentit4me/views/login_screen.dart';
import 'package:rentit4me/views/make_payment_screen.dart';
import 'package:http/http.dart' as http;
import 'package:rentit4me/views/order_place_screen.dart';
import 'package:rentit4me/views/personal_detail_screen.dart';
import 'dart:convert';
import 'package:rentit4me/views/select_membership_screen.dart';
import 'package:rentit4me/views/signup_consumer_screen.dart';
import 'package:rentit4me/views/user_location_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  final Color backgroundColor = Colors.white;
  final TextStyle styleTextUnderTheLoader = TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _loggedIn = false;
  final splashDelay = 1;

  int _checkvalue;

  bool internetCheck = false;
  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();

  String _latitutevalue;
  String _longitutevalue;

  @override
  void initState() {
    super.initState();
    //initConnectivity();
    _checklocation();
  }

  _checklocation() async{
     SharedPreferences prefs = await SharedPreferences.getInstance();
     if(prefs.getString('latitude') == null || prefs.getString('latitude') == ""){
       Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => UserlocationScreen()));
     }
     else{
       _checkLoggedIn().then((value) => _getprofileData().then((value) => _loadWidget()));
     }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on Exception catch (e) {
      print(e.toString());
    }
    if (!mounted) {
      return Future.value(null);
    }
    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      case ConnectivityResult.none:
        setState(() {
          _connectionStatus = result.toString();
        });
        if(_connectionStatus.toString() ==
            ConnectivityResult.none.toString()) {
          _scaffoldKey.currentState.showSnackBar(const SnackBar(
              content: Text("Please check your internet connection.",
                  style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.red));
        }
        else if(_connectionStatus.toString() == ConnectivityResult.wifi.toString()){
          _getprofileData();
          _checkLoggedIn().then((value) => _loadWidget());
        }
        else if(_connectionStatus.toString() == ConnectivityResult.mobile.toString()){
          _getprofileData();
          _checkLoggedIn().then((value) => _loadWidget());
        }
        break;
      default:
        setState(() {
          _connectionStatus = 'Failed to get connectivity.';
        });
        break;
    }
  }

  Future _checkLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //_latitutevalue = prefs.getString('latitude');
    //_longitutevalue = prefs.getString('longitude');
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
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => homeOrLog()));
  }

  Widget homeOrLog() {
    if(_loggedIn) {
        if(_checkvalue == 1){
          return Dashboard();
        }
        else if(_checkvalue == 2){
          return MakePaymentScreen();
        }
        else{
          return SelectMemberShipScreen();
        }
      } else {
        return Dashboard();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: Center(
        child: Image.asset(
          'assets/images/logo.png',
          scale: 10,
        ),
    ));
  }

  Future<void> _getprofileData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final body = {
      "id": prefs.getString('userid'),
    };
    var response = await http.post(Uri.parse(BASE_URL + profileUrl),
        body: jsonEncode(body),
        headers: {
          "Accept" : "application/json",
          'Content-Type' : 'application/json'
        }
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body)['Response'];
      if(data != null){
        if(data['User']['package_id'].toString() != null) {
          if(data['User']['payment_status'].toString() == "1"){
            setState((){
              _checkvalue = 1;
            });
          }
          else{
            setState((){
              _checkvalue = 2;
            });
          }
        }
      }
      else{
        setState((){
          _checkvalue = 3;
        });
      }

    } else {
      throw Exception('Failed to get data due to ${response.body}');
    }
  }
}
