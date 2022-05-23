import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rentit4me/network/api.dart';
import 'package:rentit4me/themes/constant.dart';
import 'package:http/http.dart' as http;
import 'package:rentit4me/views/home_screen.dart';
import 'package:rentit4me/views/signup_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool _loading = false;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
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
          /*actions: [
          IconButton(onPressed:(){}, icon: Icon(Icons.edit, color: kPrimaryColor)),
          IconButton(onPressed:(){}, icon: Icon(Icons.account_circle, color: kPrimaryColor)),
          IconButton(onPressed:(){}, icon: Icon(Icons.menu, color: kPrimaryColor))
        ],*/
        ),
        body: ModalProgressHUD(
          inAsyncCall: _loading,
          color: kPrimaryColor,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Container(
                    height: size.height * 0.45,
                    width: double.infinity,
                    child: Card(
                      elevation: 4.0,
                      color: Colors.deepOrangeAccent.shade100,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          Text("Sign In", style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 16)),
                          Padding(
                              padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                              child: Container(
                                height: 40,
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(5.0))
                                ),
                                child: Card(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: TextFormField(
                                      decoration: const InputDecoration(
                                        hintText: "Email",
                                        hintStyle: TextStyle(
                                            color: kPrimaryColor,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14
                                        ),
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
                              padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                              child: Container(
                                height: 40,
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(5.0))
                                ),
                                child: Card(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ), child: Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                      hintText: "Password",
                                      hintStyle: TextStyle(
                                          color: kPrimaryColor,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14
                                      ),
                                      border: InputBorder.none,
                                    ),
                                    onChanged: (String value) {
                                      passwordController.text = value.toString();
                                    },
                                  ),
                                )
                                ),
                              )),
                          Padding(
                            padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                            child: InkWell(
                              onTap: (){
                                 if(emailController.text.toString().trim().length == 0 || emailController.text.toString().trim().isEmpty){
                                   showToast("Please enter valid email address");
                                   return;
                                 }
                                 else if(passwordController.text.isEmpty || passwordController.text.toString().trim().length == 0){
                                   showToast("Please enter valid password");
                                   return;
                                 }
                                 else{
                                   _login(emailController.text.toString().trim(), passwordController.text.toString().trim());
                                 }

                              },
                              child: Container(
                                height: 45,
                                width: 160,
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                    color: kPrimaryColor,
                                    borderRadius: BorderRadius.all(Radius.circular(21))
                                ),
                                child: Text("Login", style: TextStyle(color: Colors.white, fontSize: 16)),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                            child: Container(
                              height: 40,
                              width: size.width * 0.75,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                  color: kPrimaryColor,
                                  borderRadius: BorderRadius.all(Radius.circular(21))
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 15),
                                    child: Image.asset('assets/images/facebook.png', scale: 20,),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(left: 5.0),
                                    child: Text("Login with Facebook",style: TextStyle(fontSize: 14, color: Colors.white)),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                            child: Container(
                              height: 40,
                              width: size.width * 0.75,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.all(Radius.circular(21))
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 15),
                                    child: Image.asset('assets/images/google.png', scale: 20, color: Colors.white),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(left: 5.0),
                                    child: Text("Login with Google",style: TextStyle(fontSize: 14, color: Colors.white)),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                  child: Text("Are you a Business?", style: TextStyle(color: kPrimaryColor, fontSize: 16, fontWeight: FontWeight.w400)),
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: InkWell(
                      onTap: (){
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) =>  SignupScreen()));
                      },
                      child: Container(
                        height: 45,
                        width: size.width * 0.80,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20.0)),
                            gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [
                                Colors.blue,
                                Colors.red,
                              ],
                            )
                        ),
                        child: Center(
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
                    child: Divider(color: Colors.black, height: 1)
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                  child: Text("Are you a Consumer?", style: TextStyle(color: kPrimaryColor, fontSize: 16, fontWeight: FontWeight.w400)),
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: InkWell(
                      onTap: (){
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) =>  SignupScreen()));
                      },
                      child: Container(
                        height: 45,
                        width: size.width * 0.80,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20.0)),
                            gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [
                                Colors.blue,
                                Colors.red,
                              ],
                            )
                        ),
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
        )
    );
  }

  Future _login(String email, String password) async {
    setState(() {
      _loading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(jsonEncode({
      "email": email,
      "password" : password
    }));
    final body = {
      "email": email,
      "password" : password,
    };
    var response = await http.post(Uri.parse(BASE_URL + login),
        body: jsonEncode(body),
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json'
        }
    );
    print(response.body);
    if (response.statusCode == 200) {
      setState(() {
        _loading = false;
      });
      if(jsonDecode(response.body)['message'].toString() == "Success"){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) =>  HomeScreen()));
      }
      else {

      }
    } else {
      setState(() {
        _loading = false;
      });
      print(response.body);
      throw Exception('Failed to get data due to ${response.body}');
    }
  }
}
