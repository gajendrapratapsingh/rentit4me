import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rentit4me/themes/constant.dart';


class PendingStatusScreen extends StatefulWidget {
  const PendingStatusScreen({Key key}) : super(key: key);

  @override
  State<PendingStatusScreen> createState() => _PendingStatusScreenState();
}

class _PendingStatusScreenState extends State<PendingStatusScreen> {

  bool _loading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();

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
        leading: Padding(
          padding: EdgeInsets.only(left: 10),
          child: Image.asset('assets/images/logo.png'),
        ),
        title: Text("Rentit4me", style: TextStyle(color: kPrimaryColor)),
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
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        Text("Under Process", style: TextStyle(color: Colors.black, fontSize: 21, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 15),
                        Text("Your Application is under process, Approval pending from Admin For Trusted Badge.", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 18, fontWeight: FontWeight.w500)),
                        SizedBox(height: 15),
                        InkWell(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  color: Colors.deepOrangeAccent,
                                  border: Border.all(
                                      width: 1,
                                      color: Colors.deepOrangeAccent
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(12))
                              ),
                              child: Text("Back to Home", style: TextStyle(color: Colors.white, fontSize: 16))
                          ),
                        ),
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
