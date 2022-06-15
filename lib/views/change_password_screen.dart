import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rentit4me/themes/constant.dart';
import 'package:rentit4me/views/forget_password_screen.dart';

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
        title: Text("Change Password", style: TextStyle(color: kPrimaryColor)),
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
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Text("Change Password", style: TextStyle(color: kPrimaryColor, fontSize: 18, fontWeight: FontWeight.w700)),
                        ),
                        const SizedBox(height: 10),
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
                                ),
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
                                ),
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
                               Navigator.push(context, MaterialPageRoute(builder: (context) => ForgetPasswordScreen()));
                             },
                             child: Column(
                               children: [
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
                    //_generateticket();
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
}
