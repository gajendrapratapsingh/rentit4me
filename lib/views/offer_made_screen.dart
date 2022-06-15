import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:rentit4me/network/api.dart';
import 'package:rentit4me/themes/constant.dart';
import 'package:rentit4me/views/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OfferMadeScreen extends StatefulWidget {
  const OfferMadeScreen({Key key}) : super(key: key);

  @override
  State<OfferMadeScreen> createState() => _OfferMadeScreenState();
}

class _OfferMadeScreenState extends State<OfferMadeScreen> {

  String searchvalue = " Search";
  List<dynamic> offermadelist = [];

  Razorpay _razorpay;

  bool _progress = false;
  bool _loading = false;

  //for payment
  String userid;
  String post_id;
  String request_id;
  String amount;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _offermadelist();

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
    print(request_id);
    print(post_id);
    print(userid);
    print(amount);
    _payfororder(userid, request_id, post_id, response.paymentId.toString(), amount);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("Failed");
    print(response);
    setState((){
      post_id = null;
      userid = null;
      request_id = null;
      amount = null;
    });
    print(request_id);
    print(post_id);
    print(userid);
    print(amount);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
  }

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
        'amount': ((int.parse(amount.split('.')[0])) * 100),
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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2.0,
        leading: Padding(
          padding: EdgeInsets.only(left: 10),
          child: Image.asset('assets/images/logo.png'),
        ),
        title: Text("Offer Made", style: TextStyle(color: kPrimaryColor)),
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
                          child: Text("Filter", style: TextStyle(color: kPrimaryColor, fontSize: 18, fontWeight: FontWeight.w700)),
                        ),
                        const SizedBox(height: 10),
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text("Search", style: TextStyle(color: kPrimaryColor, fontSize: 14, fontWeight: FontWeight.w500))),
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
                                  hintText: searchvalue,
                                  border: InputBorder.none,
                                ),
                                onChanged: (value){
                                  setState((){
                                    searchvalue = value;
                                  });
                                },
                              ),
                            )
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("From Date", style: TextStyle(color: kPrimaryColor, fontSize: 14, fontWeight: FontWeight.w500)),
                                SizedBox(height: 10),
                                Container(
                                    width: size.width * 0.42,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1,
                                            color: Colors.deepOrangeAccent
                                        ),
                                        borderRadius: BorderRadius.all(Radius.circular(12))
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("From Date", style: TextStyle(color: Colors.grey)),
                                          IconButton(onPressed: (){}, icon: Icon(Icons.calendar_today_sharp, size: 16, color: kPrimaryColor))
                                        ],
                                      ),
                                    )
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("To Date", style: TextStyle(color: kPrimaryColor, fontSize: 14, fontWeight: FontWeight.w500)),
                                SizedBox(height: 10),
                                Container(
                                    width: size.width * 0.42,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1,
                                            color: Colors.deepOrangeAccent
                                        ),
                                        borderRadius: BorderRadius.all(Radius.circular(12))
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("To Date", style: TextStyle(color: Colors.grey)),
                                          IconButton(onPressed: (){}, icon: Icon(Icons.calendar_today_sharp, size: 16, color: kPrimaryColor))
                                        ],
                                      ),
                                    )
                                ),
                              ],
                            )
                          ],
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
                              child: Text("Filter", style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Card(
                  elevation: 4.0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Offer Made", style: TextStyle(color: kPrimaryColor, fontSize: 18, fontWeight: FontWeight.w700)),
                            Visibility(visible: _progress, child: Container(height: 24, width: 24, child: CircularProgressIndicator(color: kPrimaryColor , strokeWidth: 2)))
                          ],
                        ),
                        const SizedBox(height: 10),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: const[
                              DataColumn(label: Text('Rentee', textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Product', textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Quantity', textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Period', textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Rent Type', textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Product Price(XCD)', textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Offer Amount(XCD)', textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Total Rent(XCD)', textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Total Security(XCD)', textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Final Amount(XCD)', textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Renew Date', textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Start Date', textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('End Date', textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Created At', textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Status', textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Action', textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))),
                            ],
                            rows: offermadelist.map(
                              ((element) => DataRow(
                                cells: <DataCell>[
                                  DataCell(Text(element["name"].toString())),
                                  DataCell(Text(element["title"].toString())),
                                  DataCell(Text(element["quantity"].toString())),
                                  _getPeriod(element["period"].toString(), element["rent_type_name"].toString()),
                                  DataCell(Text(element["rent_type_name"].toString())),
                                  DataCell(Text(element["product_price"].toString())),
                                  DataCell(Text(element["renter_amount"].toString())),
                                  DataCell(Text(element["total_rent"].toString())),
                                  DataCell(Text(element["total_security"].toString())),
                                  DataCell(Text(element["final_amount"].toString())),
                                  DataCell(Text(element["renew_date"].toString())),
                                  DataCell(Text(element["start_date"].toString())),
                                  DataCell(Text(element["end_date"].toString())),
                                  DataCell(Text(element["created_at"].toString())),
                                  _getstatus(element["offer_status"].toString()),
                                  element["offer_status"].toString() == "1" ? DataCell(TextButton(onPressed: (){
                                    setState((){
                                      post_id = element["post_ad_id"].toString();
                                      userid = element["user_id"].toString();
                                      request_id = element["offer_request_id"].toString();
                                      amount = element["final_amount"].toString().split('.')[0];
                                    });
                                    startPayment(element["final_amount"].toString());
                                  }, child: Text("Pay"))) : _getaction(element["offer_status"].toString())
                                ],
                              )),
                            ).toList(),
                          ),
                        )
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

  DataCell _getstatus(String statusvalue){
     if(statusvalue == "3"){
        return DataCell(Text("Pending"));
     }
     else if(statusvalue == "13"){
       return DataCell(Text("Completed"));
     }
     else if(statusvalue == "2"){
       return DataCell(Text("Rejected"));
     }
     else{
       return DataCell(Text("Accepted"));
     }
  }

  DataCell _getPeriod(String period, String type) {
    if(type == "hourly"){
      if(period == "1"){
        return DataCell(Text(period+" "+"Hour"));
      }
      else{
        return DataCell(Text(period+" "+"Hours"));
      }
    }
    else if(type == "yearly"){
      if(period == "1"){
        return DataCell(Text(period+" "+"Year"));
      }
      else{
        return DataCell(Text(period+" "+"Years"));
      }
    }
    else if(type == "monthly"){
      if(period == "1"){
        return DataCell(Text(period+" "+"Month"));
      }
      else{
        return DataCell(Text(period+" "+"Months"));
      }
    }
    else{
      if(period == "1"){
        return DataCell(Text(period+" "+"Day"));
      }
      else{
        return DataCell(Text(period+" "+"Days"));
      }
    }
  }

  DataCell _getaction(String statusvalue){
    if(statusvalue == "3"){
      return DataCell(TextButton(onPressed: (){}, child: Text("Edit")));
    }
    else if(statusvalue == "13"){
      return DataCell(Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: Text("NA"),
      ));
    }
    else{
      return DataCell(Padding(
        padding: EdgeInsets.only(left: 20.0),
        child: Text("NA"),
      ));
    }
  }

  Future<void> _offermadelist() async{
     SharedPreferences prefs = await SharedPreferences.getInstance();
     setState((){
       _progress = true;
     });
     final body = {
       "user_id": prefs.getString('userid'),
     };
     var response = await http.post(Uri.parse(BASE_URL + offermade),
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
              offermadelist = jsonDecode(response.body)['Response']['data'];
              _progress = false;
          });
       }
       else {
         setState(() {
           _progress = false;
         });
         showToast(jsonDecode(response.body)['ErrorMessage'].toString());
       }
     } else {
       setState(() {
         _progress = false;
       });
       print(response.body);
       throw Exception('Failed to get data due to ${response.body}');
     }
  }

  Future _payfororder(String userid, String request_id, String post_id, String paymentid, String amount) async{
     setState((){
        _loading = true;
     });
     final body = {
       "user_id" : userid,
       "postad_id" : post_id,
       "offer_request_id" : request_id,
       "razorpay_payment_id" : paymentid,
       "amount" : amount
     };
     var response = await http.post(Uri.parse(BASE_URL + offermadepay),
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
