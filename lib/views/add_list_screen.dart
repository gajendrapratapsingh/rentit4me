import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rentit4me/themes/constant.dart';

class AddlistingScreen extends StatefulWidget {
  const AddlistingScreen({Key key}) : super(key: key);

  @override
  State<AddlistingScreen> createState() => _AddlistingScreenState();
}

class _AddlistingScreenState extends State<AddlistingScreen> {

  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2.0,
        leading: Padding(
          padding: EdgeInsets.only(left: 10),
          child: Image.asset('assets/images/logo.png'),
        ),
        title: Text("Listing ADS", style: TextStyle(color: kPrimaryColor)),
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
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Card(
                  elevation: 4.0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Country*", style: TextStyle(color: kPrimaryColor, fontSize: 16, fontWeight: FontWeight.w500)),
                        SizedBox(height: 10),
                        Text("State*", style: TextStyle(color: kPrimaryColor, fontSize: 16, fontWeight: FontWeight.w500)),
                        SizedBox(height: 8.0),
                        Text("City*", style: TextStyle(color: kPrimaryColor, fontSize: 16, fontWeight: FontWeight.w500)),
                        SizedBox(height: 8.0),
                        Text("Address*", style: TextStyle(color: kPrimaryColor, fontSize: 16, fontWeight: FontWeight.w500)),
                        SizedBox(height: 8.0),
                        SizedBox(height: 10),
                        Text("Communication Preferences*", style: TextStyle(color: kPrimaryColor, fontSize: 16, fontWeight: FontWeight.w500)),
                        SizedBox(height: 10.0),
                        Text("Kyc*", style: TextStyle(color: kPrimaryColor, fontSize: 16, fontWeight: FontWeight.w500)),
                        SizedBox(height: 8.0),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
