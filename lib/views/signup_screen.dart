import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rentit4me/network/api.dart';
import 'package:rentit4me/themes/constant.dart';
import 'package:rentit4me/views/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  bool _loading = false;

  final nameController = TextEditingController();
  final businessController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final countrynameController = TextEditingController();
  final alternamemobileContoller = TextEditingController();
  final pwdController = TextEditingController();
  final confirmpwdController = TextEditingController();
  int _value = 0;

  int usertypevalue = 0;

  String countrycode;
  var code = [
    '+91',
    '+92',
    '+132',
    '+63',
    '+62',
    '+64'
  ];

  @override
  void dispose() {
    nameController.dispose();
    businessController.dispose();
    emailController.dispose();
    mobileController.dispose();
    alternamemobileContoller.dispose();
    countrynameController.dispose();
    pwdController.dispose();
    confirmpwdController.dispose();
    super.dispose();
  }

  @override

  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Colors.white,
       appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2.0,
        leading: Padding(
          padding: EdgeInsets.only(left: 10),
          child: Image.asset('assets/images/logo.png'),
        ),
        title: Text("Sign up", style: TextStyle(color: kPrimaryColor)),
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
               Row(
                 children: [
                   Row(
                     children: [
                       Radio(
                           value: 1,
                           groupValue: _value,
                           activeColor: kPrimaryColor,
                           onChanged: (value) {
                             setState(() {
                               _value = value;
                               usertypevalue = 4;
                             });
                           }),
                       const Text('Are you a business?',
                           style: TextStyle(fontSize: 12))
                     ],
                   ),
                   Row(
                     children: [
                       Radio(
                           value: 2,
                           activeColor: kPrimaryColor,
                           groupValue: _value,
                           onChanged: (value) {
                             setState(() {
                               _value = value;
                               usertypevalue = 3;
                             });
                           }),
                       const Text('Are you a consumer?', style: TextStyle(fontSize: 12))
                     ],
                   ),
                 ],
               ),
               Padding(
                   padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                   child: _fullnameTextbox("Full Name"),
               ),
               Padding(
                 padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                 child: _businessnameTextbox("Business Name"),
               ),
               Padding(
                 padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                 child: _emailTextbox("Email Address"),
               ),
               Padding(
                 padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                 child: DropdownButton(
                   value: countrycode,
                   hint: Text("Country Code", style: TextStyle(color: Colors.grey.shade700, fontSize: 15)),
                   isExpanded: true,
                   underline: Container(
                     height: 1,
                     color: Colors.black,
                   ),
                   icon: Visibility (visible:true, child: Icon(Icons.arrow_drop_down_sharp, size: 20, color: kPrimaryColor)),
                   items: code.map((String items) {
                     return DropdownMenuItem(
                       value: items,
                       child: Text(items, style: TextStyle(color: kPrimaryColor, fontSize: 12)),
                     );
                   }).toList(),
                   // After selecting the desired option,it will
                   // change button value to selected value
                   onChanged: (String newValue) {
                     setState(() {
                       countrycode = newValue;
                     });
                   },
                 ),
               ),
               Padding(
                 padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                 child: _CountrynameTextbox("Country Name"),
               ),
               Padding(
                 padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                 child: _mobileTextbox("Mobile"),
               ),
               Padding(
                 padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                 child: _alternamemobileTextbox("Alternate Mobile"),
               ),
               Padding(
                 padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                 child: _passwordTextbox("Password"),
               ),
               Padding(
                 padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                 child: _confirmpwdTextbox("Confirm Password"),
               ),
               Padding(
                 padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                 child: InkWell(
                   onTap: (){
                     if(usertypevalue == 0){
                       showToast("Please select user type");
                       return;
                     }
                     else if(nameController.text.toString().trim().isEmpty){
                       showToast("Please enter your name");
                       return;
                     }
                     else if(businessController.text.toString().trim().isEmpty){
                       showToast("Please enter your business name");
                       return;
                     }
                     else if(emailController.text.toString().trim().isEmpty){
                       showToast("Please enter email address");
                       return;
                     }
                     else if(mobileController.text.toString().trim().isEmpty){
                       showToast("Please enter mobile number");
                       return;
                     }
                     else if(pwdController.text.toString().trim().isEmpty){
                       showToast("Please enter password");
                       return;
                     }
                     else {
                       _register(
                           nameController.text.toString(),
                           businessController.text.toString(), 
                           emailController.text.toString(),
                           "91",
                           countrynameController.text.toString(),
                           mobileController.text.toString(), 
                           pwdController.text.toString(),
                           confirmpwdController.text.toString()
                       );
                     }
                   },
                   child: Container(
                     height: 45,
                     width: double.infinity,
                     alignment: Alignment.center,
                     decoration: const BoxDecoration(
                       color: Colors.deepOrangeAccent,
                       borderRadius: BorderRadius.all(Radius.circular(24.0))
                     ),
                     child: Text("Register", style: TextStyle(color: Colors.white, fontSize: 18)),
                   ),
                 ),
               )
             ],
           ),
         ),
       )
    );
  }

  Widget _fullnameTextbox(_initialValue) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: TextFormField(
        textCapitalization: TextCapitalization.sentences,
        validator: (value) {
          return null;
        },
        onSaved: (String value) {
          nameController.text = value;
        },
        onChanged: (value){
          nameController.text = value;
        },
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
            hintText: _initialValue.toString(),
            labelText: 'Full Name*'),
      ),
    );
  }
  Widget _businessnameTextbox(_initialValue) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: TextFormField(
        textCapitalization: TextCapitalization.sentences,
        validator: (value) {
          return null;
        },
        onSaved: (String value) {
          businessController.text = value;
        },
        onChanged: (value){
          businessController.text = value;
        },
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
            hintText: _initialValue.toString(),
            labelText: 'Business Name*'),
      ),
    );
  }
  Widget _emailTextbox(_initialValue) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: TextFormField(
        textCapitalization: TextCapitalization.sentences,
        validator: (value) {
          return null;
        },
        onSaved: (String value) {
          emailController.text = value;
        },
        onChanged: (value){
          emailController.text = value;
        },
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
            hintText: _initialValue.toString(),
            labelText: 'Email Address*'),
      ),
    );
  }


  Widget _CountrynameTextbox(_initialValue) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: TextFormField(
        textCapitalization: TextCapitalization.sentences,
        validator: (value) {
          return null;
        },
        onSaved: (String value) {
          countrynameController.text = value;
        },
        onChanged: (value){
          countrynameController.text = value;
        },
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
            hintText: _initialValue.toString(),
            labelText: 'Country Name*'),
      ),
    );
  }

  Widget _mobileTextbox(_initialValue) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: TextFormField(
        //textCapitalization: TextCapitalization.sentences,
        keyboardType: TextInputType.number,
        validator: (value) {
          return null;
        },
        onSaved: (String value) {
          mobileController.text = value;
        },
        onChanged: (value){
          mobileController.text = value;
        },
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
            hintText: _initialValue.toString(),
            labelText: 'Mobile*'),
      ),
    );
  }
  Widget _alternamemobileTextbox(_initialValue) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: TextFormField(
        //textCapitalization: TextCapitalization.sentences,
        keyboardType: TextInputType.number,
        validator: (value) {
          return null;
        },
        onSaved: (String value) {
          alternamemobileContoller.text = value;
        },
        onChanged: (value){
          alternamemobileContoller.text = value;
        },
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
            hintText: _initialValue.toString(),
            labelText: 'Alternate Mobile(optional)'),
      ),
    );
  }
  Widget _passwordTextbox(_initialValue) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: TextFormField(
        textCapitalization: TextCapitalization.sentences,
        validator: (value) {
          return null;
        },
        onSaved: (String value) {
          pwdController.text = value;
        },
        onChanged: (value){
          pwdController.text = value;
        },
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
            hintText: _initialValue.toString(),
            labelText: 'Password*'),
      ),
    );
  }
  Widget _confirmpwdTextbox(_initialValue) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: TextFormField(
        textCapitalization: TextCapitalization.sentences,
        validator: (value) {
          return null;
        },
        onSaved: (String value) {
          confirmpwdController.text = value;
        },
        onChanged: (value){
          confirmpwdController.text = value;
        },
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
            hintText: _initialValue.toString(),
            labelText: 'Confirm Password*'),
      ),
    );
  }

  Future _register(String name, String business, String email, String countrycode, String country, String mobile, String password, String confirmpwd) async {
    setState(() {
      _loading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(jsonEncode({
      "name": name,
      "business_name": business,
      "email": email,
      "countrycode": countrycode,
      "country" : country,
      "mobile" : mobile,
      "user_type" : usertypevalue,
      "password" : password
    }));
    final body = {
      "name": name,
      "business_name": business,
      "email": email,
      "countrycode": countrycode,
      "country" : country,
      "mobile" : mobile,
      "user_type" : usertypevalue,
      "password" : password,
      "password_confirmation" : confirmpwd
    };
    var response = await http.post(Uri.parse(BASE_URL + register),
        body: jsonEncode(body),
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json'
        }
    );
    print(BASE_URL + register);
    if (response.statusCode == 200) {
      setState(() {
        _loading = false;
      });
      print(response.body);
    } else {
      setState(() {
        _loading = false;
      });
      print(response.body);
      throw Exception('Failed to get data due to ${response.body}');
    }
  }
}
