import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rentit4me/network/api.dart';
import 'package:rentit4me/themes/constant.dart';
import 'package:rentit4me/views/forget_password_screen.dart';
import 'package:rentit4me/views/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {

  bool _loading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String currentpassword = "Enter your password";
  String newpassword = "Enter New Password";
  String confirmpassword = "Enter Confirm Password";

  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();

  bool _currentobsecure = true;
  bool _newobsecure = true;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initConnectivity();
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
        if(_connectionStatus.toString() == ConnectivityResult.none.toString()){
          _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Please check your internet connection.", style: TextStyle(color: Colors.white)),backgroundColor: Colors.red));
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
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2.0,
        leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Icon(
              Icons.arrow_back,
              color: kPrimaryColor,
            )),
        title: Text("Change Password", style: TextStyle(color: kPrimaryColor)),
        centerTitle: true,
      ),
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        color: kPrimaryColor,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Card(
                  elevation: 4.0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 5),
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text("Current Password", style: TextStyle(color: kPrimaryColor, fontSize: 14, fontWeight: FontWeight.w500))),
                        SizedBox(height: 10),
                        Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1,
                                    color: Colors.deepOrangeAccent
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(12))
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: currentpassword,
                                  border: InputBorder.none,
                                  suffixIcon: IconButton(
                                    onPressed: (){
                                      setState((){
                                        _currentobsecure = !_currentobsecure;
                                      });
                                    },
                                    icon: _currentobsecure == false ? Icon(Icons.visibility_off, color: kPrimaryColor) : Icon(Icons.visibility, color: kPrimaryColor),
                                  )
                                ),
                                obscureText: _currentobsecure,
                                onChanged: (value){
                                  setState((){
                                     currentpassword = value;
                                  });
                                },
                              ),
                            )
                        ),
                        SizedBox(height: 10),
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text("New Password", style: TextStyle(color: kPrimaryColor, fontSize: 14, fontWeight: FontWeight.w500))),
                        SizedBox(height: 10),
                        Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1,
                                    color: Colors.deepOrangeAccent
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(12))
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: newpassword,
                                  border: InputBorder.none,
                                  suffixIcon: IconButton(
                                    onPressed: (){
                                       setState((){
                                         _newobsecure = !_newobsecure;
                                       });
                                    },
                                    icon: _newobsecure == false ? Icon(Icons.visibility_off, color: kPrimaryColor) : Icon(Icons.visibility, color: kPrimaryColor),
                                  )
                                ),
                                obscureText: _newobsecure,
                                onChanged: (value){
                                  setState((){
                                      newpassword = value;
                                  });
                                },
                              ),
                            )
                        ),
                        SizedBox(height: 10),
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text("Confirm Password", style: TextStyle(color: kPrimaryColor, fontSize: 14, fontWeight: FontWeight.w500))),
                        SizedBox(height: 10),
                        Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1,
                                    color: Colors.deepOrangeAccent
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(12))
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: confirmpassword,
                                  border: InputBorder.none,
                                ),
                                onChanged: (value){
                                  setState((){
                                    confirmpassword = value;
                                  });
                                },
                              ),
                            )
                        ),
                        SizedBox(height: 15),
                        Padding(
                           padding: EdgeInsets.only(left: size.width * 0.50),
                           child: TextButton(
                             onPressed: (){
                               //_resetpassword();
                               Navigator.push(context, MaterialPageRoute(builder: (context) => ForgetPasswordScreen()));
                             },
                             child: Column(
                               children: const[
                                 Text("Forget Password", style: TextStyle(color: kPrimaryColor, fontSize: 16, fontWeight: FontWeight.w500)),
                                 Divider(color: kPrimaryColor, height: 2, thickness: 1),
                               ],
                             ),
                           ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                InkWell(
                  onTap: () {
                      if(currentpassword == "" || currentpassword == null || currentpassword == "Enter your password"){
                         showToast("Please enter current password");
                         return;
                      }
                      else if(newpassword == "" || newpassword == null || newpassword == "Enter New Password"){
                         showToast("Please enter new password");
                         return;
                      }
                      else if(confirmpassword == "" || confirmpassword == null || confirmpassword == "Enter Confirm Password"){
                        showToast("Please enter confirm password");
                         return;
                      }
                      else{
                         _changepassword();
                      }
                  },
                  child: Card(
                    elevation: 8.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Container(
                      height: 45,
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                          color: Colors.deepOrangeAccent,
                          borderRadius: BorderRadius.all(Radius.circular(8.0))
                      ),
                      child: Text("Create", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _changepassword() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      _loading = true;
    });
    final body = {
      "id": prefs.getString('userid'),
      "current_password" : currentpassword,
      "new_password" : newpassword,
      "new_confirm_password" : confirmpassword
    };
    var response = await http.post(Uri.parse(BASE_URL + "change-password"),
        body: jsonEncode(body),
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json'
        }
    );
    print(response.body);
    if (response.statusCode == 200) {
      if(jsonDecode(response.body)['ErrorCode'].toString() == "0"){
        setState((){
          _loading = false;
        });
        showToast(jsonDecode(response.body)['ErrorMessage'].toString());
        prefs.clear();
        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
      }
      else {
        setState((){
          _loading = false;
        });
        showToast(jsonDecode(response.body)['ErrorMessage'].toString());
      }
    } else {
      setState((){
        _loading = false;
      });
      print(response.body);
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  Future<void> _resetpassword() async{
    const url = "https://dev.techstreet.in/rentit4me/public/password/reset";
    if (await canLaunch(url))
      await launch(url);
    else
      // can't launch url, there is some error
      throw "Could not launch $url";
  }
}
