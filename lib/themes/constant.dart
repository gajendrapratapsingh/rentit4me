import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

const kPrimaryColor = Color(0xFF041c60);
const ksecondaryColor = Color(0xFFec7c2c);
const kCardColor = Color(0xFFfebd1b);
const kContainerColor = Color(0xFFF7D5CD);
const kOfferCardColor = Color(0xFFE7D4F9);

const kAnimationDuration = Duration(milliseconds: 200);

const defaultDuration = Duration(milliseconds: 250);

// Form Error
final RegExp emailValidatorRegExp =
RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Please Enter your email";
const String kInvalidEmailError = "Please Enter Valid Email";
const String kPassNullError = "Please Enter your password";
const String kShortPassError = "Password is too short";
const String kMatchPassError = "Passwords don't match";
const String kNamelNullError = "Please Enter your name";
const String kPhoneNumberNullError = "Please Enter your phone number";
const String kAddressNullError = "Please Enter your address";


String token(){
   return "wrtaw46veltitizqhbs";
}

 showToast(String msg){
   Fluttertoast.showToast(msg: msg, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
 }


final List monthlist = [
  {'tile': 'JAN', 'title': 'JANUARY'},
  {'tile': 'FEB', 'title': 'FEBRUARY'},
  {'tile': 'MAR', 'title': 'MARCH'},
  {'tile': 'APR', 'title': 'APRIL'},
  {'tile': 'MAY', 'title': 'MAY'},
  {'tile': 'JUN', 'title': 'JUNE'},
  {'tile': 'JUL', 'title': 'JULY'},
  {'tile': 'AUG', 'title': 'AUGUST'},
  {'tile': 'SEP', 'title': 'SEPTEMBER'},
  {'tile': 'OCT', 'title': 'OCTOBER'},
  {'tile': 'NOV', 'title': 'NOVEMBER'},
  {'tile': 'DEC', 'title': 'DECEMBER'},
];