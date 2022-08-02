import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:rentit4me/network/api.dart';
import 'package:rentit4me/themes/constant.dart';
import 'package:rentit4me/views/home_screen.dart';
import 'package:rentit4me/views/personal_detail_screen.dart';
import 'package:rentit4me/views/user_detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectMemberShipScreen extends StatefulWidget {

  String pageswitch;
  SelectMemberShipScreen({this.pageswitch});

  @override
  _SelectMemberShipScreenState createState() => _SelectMemberShipScreenState(pageswitch);
}

class _SelectMemberShipScreenState extends State<SelectMemberShipScreen> {

  String pageswitch;
  _SelectMemberShipScreenState(this.pageswitch);

  List<dynamic> membershipplanlist = [];
  bool _loading = false;

  Razorpay _razorpay;
  String package_id;

  String selectedPack_id;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getprofileData();
    _getmembershipplan();
    initializeRazorpay();
  }

  void initializeRazorpay(){
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print("success");
    //print(response.orderId.toString());
    print(response.paymentId.toString());
    _payformembership(package_id, response.paymentId.toString());
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("You have cancelled the payment process.", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.red,
        )
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {}

  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void startPayment(String amount) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      var options = {
        'key': 'rzp_test_MhKrOdDQM8C8PL',
        'name': 'Rentit4me',
        'amount': int.parse(amount) * 100,
        'description': '',
        'timeout': 600, // in seconds
        'prefill': {
          'contact': prefs.getString('mobile'),
          'email': prefs.getString('email')
        }
      };
      _razorpay.open(options);
    } catch (e) {
      print("test2-----" + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop: _willPopCallback,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 2.0,
            leading: InkWell(
                onTap:() {
                  if(pageswitch == "Home"){
                     Navigator.of(context).pop();
                  }
                  else{
                     SystemNavigator.pop();
                  }
                },
                child: const Icon(Icons.arrow_back, color: kPrimaryColor)),
            title: const Text("Membership", style: TextStyle(color: kPrimaryColor)),
            centerTitle: true,
          ),
          body: ModalProgressHUD(
            inAsyncCall: _loading,
            child: Padding(
              padding: const EdgeInsets.all(7.0),
              child: membershipplanlist.isEmpty || membershipplanlist.length == 0 ? const Center(
                child: CircularProgressIndicator(),
              ) : ListView.separated(
                itemCount: membershipplanlist.length,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                separatorBuilder: (BuildContext context, int index) => const Divider(height: 10, thickness: 0, color: Colors.white),
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: size.height * 0.40,
                    width: double.infinity,
                    child: Card(
                      elevation: 8.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 10.0),
                          Text(membershipplanlist[index]['name'].toString(), style: const TextStyle(color: kPrimaryColor, fontSize: 21, fontWeight: FontWeight.w500)),
                          const SizedBox(height: 10.0),
                          Container(
                            height: size.height * 0.14,
                            width: double.infinity,
                            decoration: const BoxDecoration(
                                color: Colors.deepOrangeAccent
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(membershipplanlist[index]['amount'].toString(), style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w700)),
                                const Text("/", style: TextStyle(color: Colors.white, fontSize: 16)),
                                const Text("month", style: TextStyle(color: Colors.white, fontSize: 16))
                              ],
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          const Text("Ad Duration", style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 14)),
                          const SizedBox(height: 5.0),
                          Text(membershipplanlist[index]['ad_duration'].toString(), style: TextStyle(color: Colors.black, fontSize: 14)),
                          const SizedBox(height: 5.0),
                          const Text("Ad Limit", style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 14)),
                          Text(membershipplanlist[index]['ad_limit'].toString(), style: TextStyle(color: Colors.black, fontSize: 14)),
                          const SizedBox(height: 5.0),
                            membershipplanlist[index]['name'].toString() == "Free" && selectedPack_id != "null" ? Container(
                            width: size.width * 0.25,
                            height: 35,
                            alignment: AlignmentDirectional.center,
                            decoration: BoxDecoration(
                                color: Colors.grey.shade400,
                                borderRadius: BorderRadius.all(Radius.circular(8.0))
                            ),
                            child: const Text("Get Plan", style: TextStyle(color: Colors.black, fontSize: 14)),
                          ) : InkWell(
                            onTap: () {
                              if(pageswitch == "Home") {
                                if(membershipplanlist[index]['id'].toString() == "1"){
                                  _selectmembership(membershipplanlist[index]['id'].toString(), membershipplanlist[index]['amount'].toString());
                                }
                                else{
                                  print(membershipplanlist[index]['id'].toString());
                                  setState((){
                                    package_id = membershipplanlist[index]['id'].toString();
                                  });
                                  startPayment(membershipplanlist[index]['amount'].toString());
                                }
                              }
                              else{
                                _selectmembership(membershipplanlist[index]['id'].toString(), membershipplanlist[index]['amount'].toString());
                              }
                            },
                            child: Container(
                              width: size.width * 0.25,
                              height: 35,
                              alignment: AlignmentDirectional.center,
                              decoration: const BoxDecoration(
                                  color: kPrimaryColor,
                                  borderRadius: BorderRadius.all(Radius.circular(8.0))
                              ),
                              child: const Text("Get Plan", style: TextStyle(color: Colors.white, fontSize: 14)),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ));
 
  }

  Future<bool> _willPopCallback() async {
     if(pageswitch == "Home"){
       Navigator.of(context).pop();
     }
     else{
        SystemNavigator.pop();
      }
      return Future.value(true);
  }

  Future _getprofileData() async{
    setState((){
      _loading = true;
    });
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
    setState(() {
      _loading = false;
    });
    if(response.statusCode == 200) {
      var data = json.decode(response.body)['Response'];
      setState((){
         selectedPack_id = data['User']['package_id'].toString();
      });
    } else {
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  Future _getmembershipplan() async {
    var response = await http.get(Uri.parse(BASE_URL+getmembership));
    print(response.body);
    if(response.statusCode == 200) {
       setState(() {
           membershipplanlist.addAll(json.decode(response.body)['Response']);
       });
    } else {
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  Future _selectmembership(String membershipid, String amount) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _loading = true;
    });
    final body = {
      "id": prefs.getString('userid'),
      "package_id" : membershipid
    };
    var response = await http.post(Uri.parse(BASE_URL + selectmembership),
        body: jsonEncode(body),
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json'
        }
    );
    if (response.statusCode == 200) {
      setState(() {
        _loading = false;
      });
      if(jsonDecode(response.body)['ErrorCode'].toString() == "0"){
        if(pageswitch == "Home"){
           Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
        }
        else{
           Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => PersonalDetailScreen()));
        }
      }
      else {
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

  Future _payformembership(String package_id, String paymentid) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      _loading = true;
    });
    final body = {
      "user_id" : prefs.getString('userid'),
      "package_id" : package_id,
      "razorpay_payment_id" : paymentid,
    };
    var response = await http.post(Uri.parse(BASE_URL + payformembership),
        body: jsonEncode(body),
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json'
        }
    );
    print(response.body);
    setState((){
      _loading = false;
    });
    if (response.statusCode == 200) {
      if(jsonDecode(response.body)['ErrorCode'].toString() == "0"){
        setState((){
          _loading = false;
        });
        showToast(jsonDecode(response.body)['ErrorMessage'].toString());
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
      }
      else {
        setState(() {
          _loading = false;
        });
        showToast(jsonDecode(response.body)['ErrorMessage'].toString());
      }
    } else {
      setState(() {
        _loading = false;
      });
      print(response.body);
      throw Exception('Failed to get data due to ${response.body}');

    }}
}
