import 'dart:convert';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rentit4me/network/api.dart';
import 'package:rentit4me/themes/constant.dart';
import 'package:http/http.dart' as http;
import 'package:rentit4me/views/dashboard.dart';
import 'package:rentit4me/views/home_screen.dart';
import 'package:rentit4me/views/make_payment_screen.dart';
import 'package:rentit4me/views/select_membership_screen.dart';
import 'package:rentit4me/views/signup_business_screen.dart';
import 'package:rentit4me/views/signup_consumer_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _loading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();

  String fcmToken;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initConnectivity();

    FirebaseMessaging.instance.getToken().then((value) {
      setState(() {
        fcmToken = value.toString();
        print(fcmToken);
      });
    });

    //print(Navigator.of(context).)
  }

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
        if (_connectionStatus.toString() ==
            ConnectivityResult.none.toString()) {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: const Text("Please check your internet connection.",
                  style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.red));
        }
        break;
      default:
        setState(() {
          _connectionStatus = 'Failed to get connectivity.';
        });
        break;
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<bool> onWillPop() {
    exit(0);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 2.0,
          leading: Padding(
            padding: EdgeInsets.only(left: 10),
            child: Image.asset('assets/images/logo.png'),
          ),
          title: Text("Sign in", style: TextStyle(color: kPrimaryColor)),
          centerTitle: true,
          actions: [
            IconButton(onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen()));
            }, icon: Icon(Icons.home, color: kPrimaryColor))
          ],
        ),
        body: ModalProgressHUD(
          inAsyncCall: _loading,
          color: kPrimaryColor,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Card(
                      elevation: 4.0,
                      color: Colors.deepOrangeAccent.shade100,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child:  Column(
                          children: [
                            SizedBox(height: 10),
                            const Text("Sign In",
                                style: TextStyle(
                                    color: Colors.deepOrangeAccent,
                                    fontSize: 16)),
                            Padding(
                                padding:
                                EdgeInsets.only(left: 15, top: 10, right: 15),
                                child: Container(
                                  height: 50,
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(5.0))),
                                  child: Card(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    child: Padding(
                                      padding:
                                      EdgeInsets.only(left: 10, bottom: 7.0),
                                      child: TextField(
                                        decoration: const InputDecoration(
                                          hintText: "Email",
                                          hintStyle: TextStyle(
                                              color: kPrimaryColor,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14),
                                          border: InputBorder.none,
                                        ),
                                        onChanged: (String value) {
                                          emailController.text = value.toString();
                                        },
                                      ),
                                    ),
                                  ),
                                )),
                            Padding(
                                padding: EdgeInsets.only(left: 15, top: 10, right: 15),
                                child: Container(
                                  height: 50,
                                  width: double.infinity,
                                  decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                                  child: Card(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 10, bottom: 7.0),
                                        child: TextFormField(
                                          decoration: const InputDecoration(
                                            hintText: "Password",
                                            hintStyle: TextStyle(
                                                color: kPrimaryColor,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14),
                                            border: InputBorder.none,
                                          ),
                                          onChanged: (String value) {
                                            passwordController.text =
                                                value.toString();
                                          },
                                        ),
                                      )),
                                )),
                            Padding(
                              padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                              child: InkWell(
                                onTap:() {
                                  if (emailController.text.toString().trim().length == 0 || emailController.text.toString().trim().isEmpty) {
                                    showToast("Please enter valid email address");
                                    return;
                                  } else if (passwordController.text.isEmpty || passwordController.text.toString().trim().length == 0) {
                                    showToast("Please enter valid password");
                                    return;
                                  } else {
                                    _login(emailController.text.toString().trim(), passwordController.text.toString().trim());
                                  }
                                },
                                child: Container(
                                  height: 45,
                                  width: 160,
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(
                                      color: kPrimaryColor,
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(21))),
                                  child: const Text("Login", style: TextStyle(color: Colors.white, fontSize: 16)),
                                ),
                              ),
                            ),
                            SizedBox(height: 5.0),
                            Row(
                              children: [
                                SizedBox(
                                  width: size.width * 0.39,
                                  child: Divider(thickness: 1, color: kPrimaryColor),
                                ),
                                Text("OR", style: TextStyle(color: kPrimaryColor)),
                                SizedBox(
                                  width: size.width * 0.39,
                                  child: Divider(thickness: 1, color: kPrimaryColor),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                              child: Container(
                                height: 45,
                                width: size.width * 0.75,
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                    color: kPrimaryColor,
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(21))),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 15),
                                      child: Image.asset(
                                        'assets/images/facebook.png',
                                        scale: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(left: 5.0),
                                      child: Text("Login with Facebook",
                                          style: TextStyle(
                                              fontSize: 14, color: Colors.white)),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                              child: Container(
                                height: 45,
                                width: size.width * 0.75,
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                    color: Colors.red,
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(21))),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 15),
                                      child: Image.asset(
                                          'assets/images/google.png',
                                          scale: 20,
                                          color: Colors.white),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(left: 5.0),
                                      child: Text("Login with Google",
                                          style: TextStyle(
                                              fontSize: 14, color: Colors.white)),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                      )
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                  child: Text("Are you a Business?",
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w400)),
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    SignupScreen()));
                      },
                      child: Container(
                        height: 45,
                        width: size.width * 0.80,
                        decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.all(Radius.circular(20.0)),
                            gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [
                                Colors.deepOrange.shade400,
                                Colors.red,
                              ],
                            )),
                        child: const Center(
                          child: Text(
                            'Click Here To Signup',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )),
                const Padding(
                    padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
                    child: Divider(color: Colors.black, height: 1)),
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                  child: Text("Are you a Consumer?",
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w400)),
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    SignupConsumerScreen()));
                      },
                      child: Container(
                        height: 45,
                        width: size.width * 0.80,
                        decoration: const BoxDecoration(
                            borderRadius:
                            BorderRadius.all(Radius.circular(20.0)),
                            color: Colors.purple),
                        child: const Center(
                          child: Text(
                            'Click Here To Signup',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ));
  }

  Future _login(String email, String password) async {
    setState(() {
      _loading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final body = {
      "email": email,
      "password": password,
    };
    var response = await http.post(Uri.parse(BASE_URL + login),
        body: jsonEncode(body),
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json'
        });
        print(response.body);
      if(response.statusCode == 200) {
      setState(() {
        _loading = false;
      });
      if (jsonDecode(response.body)['ErrorCode'].toString() == "0") {
        prefs.setBool('logged_in', true);
        prefs.setString('userid', jsonDecode(response.body)['Response']['id'].toString());
        prefs.setString('usertype', jsonDecode(response.body)['Response']['user_type'].toString());
        _getprofileData();
        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => HomeScreen()));

      } else {
        showToast(jsonDecode(response.body)['ErrorMessage'].toString());
      }
    } else {
      setState(() {
        _loading = false;
      });
      print(response.body);
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  Future _getprofileData() async{
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
    print(response.body);
    if (response.statusCode == 200) {
      var data = json.decode(response.body)['Response'];
      if(data['User']['package_id'] != null) {
        if(data['User']['payment_status'].toString() == "1"){
          prefs.setString('userquickid', data['User']['quickblox_id'].toString());
          prefs.setString('quicklogin', data['User']['quickblox_email'].toString());
          prefs.setString('quickpassword', data['User']['quickblox_password'].toString());
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) =>  HomeScreen()));
        }
        else{
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) =>  MakePaymentScreen()));
        }
      }
      else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) =>  SelectMemberShipScreen()));
      }
    } else {
      throw Exception('Failed to get data due to ${response.body}');
    }
  }
}
