import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:rentit4me/network/api.dart';
import 'package:rentit4me/themes/constant.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rentit4me/themes/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BoostPaymentScreen extends StatefulWidget {

  String postid;

  BoostPaymentScreen({this.postid});

  @override
  State<BoostPaymentScreen> createState() => _BoostPaymentScreenState(postid);
}

class _BoostPaymentScreenState extends State<BoostPaymentScreen> {

  String postid;
  _BoostPaymentScreenState(this.postid);

  bool _loading = false;

  List<dynamic> boostplanlist = [];

  String packageid;
  String amount;

  Razorpay _razorpay;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(postid);
     _getboostpplan();

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
    print(response.paymentId.toString());
  
    print(amount);
    _payforboost(packageid, postid, amount, response.paymentId.toString());
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("You have cancelled the payment process.", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.red,
        )
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
  }

  @override
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
        'amount': (int.parse(amount) * 100),
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
      return Scaffold(
      backgroundColor: Colors.white,
       appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2.0,
        leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              Icons.arrow_back,
              color: kPrimaryColor,
            )),
        title: Text("Boost Payment", style: TextStyle(color: kPrimaryColor)),
        centerTitle: true,
      ),
     
       body: ModalProgressHUD(
         inAsyncCall: _loading,
         child: Padding(
           padding: EdgeInsets.all(7.0),
           child: boostplanlist.isEmpty || boostplanlist.length == 0 ? const Center(
             child: CircularProgressIndicator(),
           ) : ListView.separated(
             itemCount: boostplanlist.length,
             shrinkWrap: true,
             scrollDirection: Axis.vertical,
             separatorBuilder: (BuildContext context, int index) => const Divider(height: 10, thickness: 0, color: Colors.white),
             itemBuilder: (BuildContext context, int index) {
               return Card(
                   elevation: 8.0,
                   shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(16.0),
                   ),
                   child: Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Column(
                       children: [
                         Text(boostplanlist[index]['name'].toString(), style: TextStyle(color: kPrimaryColor, fontSize: 21, fontWeight: FontWeight.w500)),
                         const SizedBox(height: 10),
                         Container(
                           height: 80,
                           width: double.infinity,
                           decoration: const BoxDecoration(
                               color: Colors.deepOrangeAccent
                           ),
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                               Text(boostplanlist[index]['amount'].toString(), style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w700)),
                               const Text("/", style: TextStyle(color: Colors.white, fontSize: 16)),
                               const Text("month", style: TextStyle(color: Colors.white, fontSize: 16))
                             ],
                           ),
                         ),
                         const SizedBox(height: 10.0),
                         const Text("Duration", style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 16, fontWeight: FontWeight.w600)),
                         const SizedBox(height: 5.0),
                         Text(boostplanlist[index]['duration'].toString(), style: TextStyle(color: Colors.black, fontSize: 16)),
                         const SizedBox(height: 5.0),
                         const Text("Position", style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 16, fontWeight: FontWeight.w600)),
                         Text(boostplanlist[index]['position'].toString(), style: TextStyle(color: Colors.black, fontSize: 14)),
                         const SizedBox(height: 10.0),
                         InkWell(
                           onTap: (){
                                setState(() {
                                    packageid = boostplanlist[index]['id'].toString();
                                    amount = boostplanlist[index]['amount'].toString();
                                });
                                startPayment(amount);
                           },
                           child: Container(
                             width: size.width * 0.25,
                             height: 35,
                             alignment: AlignmentDirectional.center,
                             decoration: const BoxDecoration(
                                 color: kPrimaryColor,
                                 borderRadius: BorderRadius.all(Radius.circular(8.0))
                             ),
                             child: Text("Get", style: TextStyle(color: Colors.white, fontSize: 14)),
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
    );
 
  }


  Future<void> _getboostpplan() async {
    setState(() {
      _loading = true;
    });
    var response = await http.get(Uri.parse(BASE_URL+postboost),
        //body: jsonEncode(body),
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json'
    });
    print(response.body);
    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['ErrorCode'].toString() == "0") {
        setState(() {
           boostplanlist.addAll(jsonDecode(response.body)['Response']);
          _loading = false;
        });
       
      } else {
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
    }
  }


  Future<void> _payforboost(String packageid, String postid, String amount, String razorpayid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _loading = true;
    });
    print(jsonEncode({
       "package_id" : packageid,
       "postid" : postid,
       "user_id" : prefs.getString('userid'),
       "razorpay_payment_id" : razorpayid,
       "amount" : amount
    }));
    final body = {
       "package_id" : packageid,
       "postid" : postid,
       "user_id" : prefs.getString('userid'),
       "razorpay_payment_id" : razorpayid,
       "amount" : amount
    };
    var response = await http.post(Uri.parse(BASE_URL+"pay-for-boostAd"),
        body: jsonEncode(body),
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json'
    });
    print(response.body);
    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['ErrorCode'].toString() == "0") {
        setState(() {
          _loading = false;
        });
        showToast(jsonDecode(response.body)['ErrorMessage'].toString());
        Navigator.of(context).pop();
      } else {
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
    }
  }

}