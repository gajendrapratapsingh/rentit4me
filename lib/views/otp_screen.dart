import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:http/http.dart' as http;
import 'package:rentit4me/network/api.dart';
import 'package:rentit4me/themes/constant.dart';
import 'package:rentit4me/views/profile_screen.dart';
import 'package:rentit4me/views/select_membership_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
class OtpScreen extends StatefulWidget {
  String phone;
  String otp;
  OtpScreen({this.phone, this.otp});

  @override
  State<OtpScreen> createState() => _OtpScreenState(phone, otp);
}

class _OtpScreenState extends State<OtpScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String userotp;
  bool _loading = false;

  String phone;
  String otp;
  _OtpScreenState(this.phone, this.otp);

  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initConnectivity();
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
        if (_connectionStatus.toString() ==
            ConnectivityResult.none.toString()) {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text("Please check your internet connection.",
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
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
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
        title: Text("OTP", style: TextStyle(color: kPrimaryColor)),
        centerTitle: true,
      ),
      body: ModalProgressHUD(
        color: Colors.indigo,
        inAsyncCall: _loading,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const Padding(
                padding: const EdgeInsets.only(left: 15.0, top: 10.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text("Verification",
                      style: TextStyle(
                          color: Colors.black,
                          fontStyle: FontStyle.normal,
                          fontSize: 16)),
                ),
              ),
              const Padding(
                padding: const EdgeInsets.only(left: 15.0,  top: 5.0, right: 25.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text("We sent you an SMS code",
                      style: TextStyle(
                          color: Colors.black,
                          fontStyle: FontStyle.normal,
                          fontSize: 25,
                          fontWeight: FontWeight.bold)),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 15.0,  top: 5.0, right: 25.0),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Row(
                        children: [
                          Text("On number:", style: TextStyle(color: Colors.black, fontSize: 12)),
                          SizedBox(width: 5.0),
                          Text("+91 $phone", style: TextStyle(color: kPrimaryColor, fontSize: 12))
                        ],
                      )
                  )
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 80.0, right: 10.0, bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _textFieldOTP(first: true, last: false),
                    _textFieldOTP(first: false, last: false),
                    _textFieldOTP(first: false, last: false),
                    _textFieldOTP(first: false, last: false),
                    _textFieldOTP(first: false, last: false),
                    _textFieldOTP(first: false, last: true),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 60.0, top: 20.0, right: 60.0, bottom: 10.0),
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  width: size.width * 0.9,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(29),
                    child: newElevatedButton(),
                  ),
                ),
              ),
              InkWell(
                onTap: (){
                  setState((){
                     userotp = null;
                  });
                   _resendotp(phone);
                },
                child: const Padding(
                    padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
                    child: Text("Code not received?", textAlign: TextAlign.center, style: TextStyle(color: kPrimaryColor, fontSize: 12))
                ),
              )

            ],
          ),
        ),
      ),
    );
  }

  Widget _textFieldOTP({bool first, last}) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.08,
      width: MediaQuery.of(context).size.width * 0.14,
      alignment: Alignment.center,
      child: Card(
        elevation: 4.0,
        child: AspectRatio(
          aspectRatio: 1.0,
          child: TextField(
            autofocus: true,
            onChanged:(value) {
              print(value);
              if (value.length == 1 && last == false) {
                FocusScope.of(context).nextFocus();
              }
              if(value.length == 0 && first == false) {
                FocusScope.of(context).previousFocus();
              }
              if(userotp == null || userotp == ""){
                setState((){
                   userotp = value.toString().trim();
                });
              }
              else{
                setState(() {
                    userotp = userotp+value.toString().trim();
                });
              }
            },
            showCursor: true,
            readOnly: false,
            cursorColor: kPrimaryColor,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            keyboardType: TextInputType.number,
            maxLength: 1,
            decoration: const InputDecoration(
                contentPadding: EdgeInsets.only(bottom: 2.0),
                counter: Offstage(),
                hintText: "0",
                border: InputBorder.none
            ),
          ),
        ),
      ),
    );
  }

  Widget newElevatedButton() {
    return ElevatedButton(
      child: const Text(
        "Submit",
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        if (_connectionStatus.toString() ==
            ConnectivityResult.none.toString()) {
          _scaffoldKey.currentState.showSnackBar(const SnackBar(
              content: Text("Please check your internet connection.",
                  style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.red));
        } else {
          print("calling");
          print(otp);
          print(userotp);
          if(userotp.toString().trim() != otp.toString().trim()){
             showToast("Please enter valid otp");
             return;
          }
          else{
            _verifyotp(phone, otp);
          }
        }
      },
      style: ElevatedButton.styleFrom(
          primary: Colors.indigo,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          textStyle: const TextStyle(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
    );
  }

  Future _resendotp(String mobile) async{
    final body = {
      "mobile": mobile,
    };
    var response = await http.post(Uri.parse(BASE_URL + sendotp),
        body: jsonEncode(body),
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json'
        }
    );
    print(response.body);
    if(jsonDecode(response.body)['ErrorCode'].toString() == "0"){
      showToast(jsonDecode(response.body)['Response']['otp'].toString());
      setState(() {
        otp = "";
        otp = jsonDecode(response.body)['Response']['otp'].toString();
      });
    }

  }

  Future _verifyotp(String mobile, String otp) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final body = {
      "mobile": mobile,
      "otp" : otp
    };
    var response = await http.post(Uri.parse(BASE_URL + verifyotp),
        body: jsonEncode(body),
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json'
        }
    );
    print(response.body);
    if(jsonDecode(response.body)['ErrorCode'].toString() == "0"){
      showToast(jsonDecode(response.body)['ErrorMessage'].toString());
      prefs.setString('userid', jsonDecode(response.body)['Response']['id'].toString());
      prefs.setBool('logged_in', true);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) =>  SelectMemberShipScreen()));
    }
    else{
      showToast(jsonDecode(response.body)['ErrorMessage'].toString());
    }

  }
}
