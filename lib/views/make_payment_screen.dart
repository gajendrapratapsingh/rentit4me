import 'dart:convert';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:rentit4me/network/api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rentit4me/themes/constant.dart';
import 'package:rentit4me/views/dashboard.dart';
import 'package:rentit4me/views/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MakePaymentScreen extends StatefulWidget {
  const MakePaymentScreen({Key key}) : super(key: key);

  @override
  State<MakePaymentScreen> createState() => _MakePaymentScreenState();
}

class _MakePaymentScreenState extends State<MakePaymentScreen> {

  bool _loading = false;

  String package_id;
  String package_name;
  String plan_id;
  String ad_limit;
  String ad_duration;
  String type;
  String amount;
  String active;

  Razorpay _razorpay;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getmakepayment();
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
    return Scaffold(
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
        title: const Text("Make Payment", style: TextStyle(color: kPrimaryColor)),
        centerTitle: true,
      ),
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        child: _loading == true ? Center(child: CircularProgressIndicator(color: kPrimaryColor)) : Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
               Container(
                  width: double.infinity,
                  child: Card(
                      elevation: 4.0,
                      child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              const Align(
                                  alignment: Alignment.topLeft,
                                  child: Text("Make Payment", style: TextStyle(color: kPrimaryColor, fontSize: 18, fontWeight: FontWeight.w500))
                              ),
                              SizedBox(height: 15),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Plan", style: TextStyle(color: kPrimaryColor, fontSize: 18, fontWeight: FontWeight.w400)),
                                  package_name == null ? const SizedBox() : Text(package_name, style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w300))
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Ad Duration", style: TextStyle(color: kPrimaryColor, fontSize: 18, fontWeight: FontWeight.w400)),
                                  ad_duration == null ? SizedBox() : Text(ad_duration, style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w300))
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Ad Limit", style: TextStyle(color: kPrimaryColor, fontSize: 18, fontWeight: FontWeight.w400)),
                                  ad_limit == null ? SizedBox() : Text(ad_limit, style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w300))
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Membership Amount", style: TextStyle(color: kPrimaryColor, fontSize: 18, fontWeight: FontWeight.w400)),
                                  amount == null ? SizedBox() : Container(
                                      height: 25,
                                      width: 60,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8.0),
                                          color: Colors.green
                                      ),
                                      child: Text(amount, style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500))
                                  )
                                ],
                              ),
                              SizedBox(height: 15),
                              InkWell(
                                onTap:(){
                                  startPayment(amount);
                                },
                                child: Container(
                                  height: 40,
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      color: kPrimaryColor
                                  ),
                                  child: Text("Pay", style: TextStyle(color: Colors.white, fontSize: 16)),
                                ),
                              )
                            ],
                          )))
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _getmakepayment() async{
     SharedPreferences prefs = await SharedPreferences.getInstance();
     setState(() {
       _loading = true;
     });
     final body = {
       "id": prefs.getString('userid'),
     };
     var response = await http.post(Uri.parse(BASE_URL + makepayment),
         body: jsonEncode(body),
         headers: {
           "Accept": "application/json",
           'Content-Type': 'application/json'
         }
     );
     setState(() {
       _loading = false;
     });
     if(response.statusCode == 200) {
       if(jsonDecode(response.body)['ErrorCode'].toString() == "0"){
         if(jsonDecode(response.body)['Response']['Membership']['name'].toString() == "Free"){
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
         }
         else{
           setState((){
             package_id = jsonDecode(response.body)['Response']['Membership']['id'].toString();
             package_name = jsonDecode(response.body)['Response']['Membership']['name'].toString();
             ad_duration = jsonDecode(response.body)['Response']['Membership']['ad_duration'].toString();
             ad_limit = jsonDecode(response.body)['Response']['Membership']['ad_limit'].toString();
             amount = jsonDecode(response.body)['Response']['Membership']['amount'].toString();
           });
         }

       }
       else {
         showToast(jsonDecode(response.body)['ErrorMessage'].toString());
       }
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
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Dashboard()));
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
