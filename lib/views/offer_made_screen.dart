import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:rentit4me/network/api.dart';
import 'package:rentit4me/themes/constant.dart';
import 'package:rentit4me/views/home_screen.dart';
import 'package:rentit4me/views/offer_made_product_detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OfferMadeScreen extends StatefulWidget {
  const OfferMadeScreen({Key key}) : super(key: key);

  @override
  State<OfferMadeScreen> createState() => _OfferMadeScreenState();
}

class _OfferMadeScreenState extends State<OfferMadeScreen> {

  String searchvalue = "Search";
  List<dynamic> offermadelist = [];

  Razorpay _razorpay;

  bool _loading = false;

  //for payment
  String userid;
  String post_id;
  String request_id;
  String amount;

  String startdate = "From Date";
  String enddate = "To Date";

  String productQty;
  String renttypename;
  String negotiable;
  String productamount;
  String useramount;
  String renttypeid;
  String renteramount;
  String securitydeposit;
  List<dynamic> rentpricelist = [];
  List<String> renttypelist = [];

  double totalrent = 0;
  double totalsecurity = 0;
  double finalamount = 0;
  String days;
  String startDate = "Available Date";
  String dialogstartDate;

  String capitalize(str) {
    return "${str[0].toUpperCase()}${str.substring(1).toLowerCase()}";
  }

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
        title: Text("Offer Made", style: TextStyle(color: kPrimaryColor)),
        centerTitle: true,
      ),
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        color: kPrimaryColor,
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
                      SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.only(left: 0.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.deepOrangeAccent)
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.deepOrangeAccent,)
                            ),
                            contentPadding: EdgeInsets.only(left: 5),
                            hintText: searchvalue,
                            border: InputBorder.none,
                          ),
                          onChanged: (value){
                            setState((){
                              searchvalue = value;
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //Text("From Date", style: TextStyle(color: kPrimaryColor, fontSize: 14, fontWeight: FontWeight.w500)),
                              //SizedBox(height: 10),
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
                                        Text(startdate, style: TextStyle(color: Colors.grey)),
                                        IconButton(onPressed: (){
                                          _selectStartDate(context);
                                        }, icon: Icon(Icons.calendar_today_sharp, size: 16, color: kPrimaryColor))
                                      ],
                                    ),
                                  )
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //Text("To Date", style: TextStyle(color: kPrimaryColor, fontSize: 14, fontWeight: FontWeight.w500)),
                              //SizedBox(height: 10),
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
                                        Text(enddate, style: TextStyle(color: Colors.grey)),
                                        IconButton(onPressed: (){
                                          _selectEndtDate(context);
                                        }, icon: Icon(Icons.calendar_today_sharp, size: 16, color: kPrimaryColor))
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
                            if(searchvalue == "Search" || searchvalue.trim().length == 0 || searchvalue.trim().isEmpty){
                              _offermadelistByDate();
                            }
                            else{
                               _offermadelistBySearch();
                            }
                        },
                        child: Card(
                          elevation: 8.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Container(
                            height: 40,
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
                Expanded(
                child: ListView.separated(
                itemCount: offermadelist.length,
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                separatorBuilder: (BuildContext context, int index) => const Divider(), 
                itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                         onTap: (){
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                              title: Text('Detail Information'),
                              content: SingleChildScrollView(child:  Column(children: [
                                  Card(
                                    color: Colors.grey[100],
                                    child: ListTile(
                                       title: Text("Rentee"),
                                       subtitle: Text(offermadelist[index]['name'].toString()),
                                        
                                    ),
                                  ),
                                  Card(
                                    color: Colors.grey[100],
                                    child: ListTile(
                                       title: Text("Product Name"),
                                       subtitle: Text(offermadelist[index]["title"].toString()),
                                        
                                    ),
                                  ),
                                  Card(
                                    color: Colors.grey[100],
                                    child: ListTile(
                                       title: Text("Product Quantity"),
                                       subtitle: Text(offermadelist[index]["quantity"].toString()),
                                        
                                    ),
                                  ),
                                  Card(
                                    color: Colors.grey[100],
                                    child: ListTile(
                                       title: Text("Rent Type"),
                                       subtitle: Text(offermadelist[index]["rent_type_name"].toString()),
                                        
                                    ),
                                  ),
                                  Card(
                                    color: Colors.grey[100],
                                    child: ListTile(
                                       title: Text("Period"),
                                       subtitle: Text(offermadelist[index]["period"].toString()),
                                        
                                    ),
                                  ),
                                  Card(
                                    color: Colors.grey[100],
                                    child: ListTile(
                                       title: Text("Product Price(XCD)"),
                                       subtitle: Text(offermadelist[index]["product_price"].toString()),
                                        
                                    ),
                                  ),
                                  Card(
                                    color: Colors.grey[100],
                                    child: ListTile(
                                       title: Text("Offer Amount(XCD)"),
                                       subtitle: Text(offermadelist[index]["renter_amount"].toString()),
                                        
                                    ),
                                  ),
                                  Card(
                                    color: Colors.grey[100],
                                    child: ListTile(
                                       title: Text("Total Rent(XCD)"),
                                       subtitle: Text(offermadelist[index]["total_rent"].toString()),
                                        
                                    ),
                                  ),
                                  Card(
                                    color: Colors.grey[100],
                                    child: ListTile(
                                       title: Text("Total Security(XCD)"),
                                       subtitle: Text(offermadelist[index]["total_security"].toString()),
                                        
                                    ),
                                  ),
                                  Card(
                                    color: Colors.grey[100],
                                    child: ListTile(
                                       title: Text("Total Rent(XCD)"),
                                       subtitle: Text(offermadelist[index]["total_rent"].toString()),
                                        
                                    ),
                                  ),
                                  Card(
                                    color: Colors.grey[100],
                                    child: ListTile(
                               title: Text("Final Amount(XCD)"),
                                       subtitle: Text(offermadelist[index]["final_amount"].toString()),
                                        
                                    ),
                                  ),
                                
                              ]))));
                         
                         },
                         child: Card(
                         elevation: 4.0,
                         child: Padding(
                           padding: const EdgeInsets.only(top : 8.0, bottom: 8.0),
                           child: ListTile(
                           title: Text("Rentee : "+offermadelist[index]['name'].toString()),
                           subtitle: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                              InkWell(
                                 onTap: (){
                                   Navigator.push(context, MaterialPageRoute(builder: (context) => OfferMadeProductDetailScreen(postadid: offermadelist[index]['post_ad_id'].toString(), offerid: offermadelist[index]['offer_request_id'].toString())));
                                 },
                                 child: Text("Product Name : "+offermadelist[index]['title'].toString()),
                              ),
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Qty: "+offermadelist[index]['quantity'].toString()),
                                  Text("Period: "+offermadelist[index]['period'].toString()),
                                  Text("Rent type: "+offermadelist[index]['rent_type_name'].toString()),
                              ])
                           ]),
                           trailing: offermadelist[index]["offer_status"].toString() == "1" &&  offermadelist[index]["pay_status"].toString() == "0" ? InkWell(onTap: (){
                               setState((){
                                     post_id = offermadelist[index]["post_ad_id"].toString();
                                     userid = offermadelist[index]["user_id"].toString();
                                     request_id = offermadelist[index]["offer_request_id"].toString();
                                     amount = offermadelist[index]["final_amount"].toString().split('.')[0];
                                   });
                                   startPayment(offermadelist[index]["final_amount"].toString());
                           }, child: Container(
                                     width: 50,
                                     height: 30,
                                     alignment: Alignment.center,
                                     padding: EdgeInsets.all(4.0),
                                     decoration: BoxDecoration(
                                     borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                     border: Border.all(color: Colors.blue)
                                  ),  child: Text("Pay", style: TextStyle(color: Colors.blue)))) : _getaction(offermadelist[index]["offer_status"].toString(), offermadelist[index]["pay_status"].toString(), index, offermadelist)
                     ),
                         ),
                   ),
                      );
                 },
                )
                )
            ],
          ),
        ),),
    );
  }



  Widget _getaction(String statusvalue, String paystatus,  int index, List<dynamic> listdata){
    if(statusvalue == "3"){
      return InkWell(
        onTap: () {
             print(listdata[index]["post_ad_id"].toString());
            _getmakeoffer(listdata[index]["post_ad_id"].toString());
        },
        child: Container(
           width: 50,
           height: 30,
           alignment: Alignment.center,
           padding: EdgeInsets.all(4.0),
           decoration: BoxDecoration(
             borderRadius: BorderRadius.all(Radius.circular(4.0)),
             border: Border.all(color: Colors.blue)
             ),
           child: Text("Edit", style: TextStyle(color: Colors.blue)),
        ),
      );
    }
    else if(statusvalue == "1" && paystatus == "0"){
      return Text("Pay", style: TextStyle(color: Colors.grey));
    }
    else{
      return Text("NA", style: TextStyle(color: Colors.grey));
    }
  }

  Future<void> _offermadelist() async{
     SharedPreferences prefs = await SharedPreferences.getInstance();
     setState((){
       _loading = true;
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
     setState((){
        _loading = false;
     });
     if (response.statusCode == 200) {
       if(jsonDecode(response.body)['ErrorCode'].toString() == "0"){
           if(jsonDecode(response.body)['Response'] != null){
             setState((){
               offermadelist.addAll(jsonDecode(response.body)['Response']['data']);
             });
           }
           else{
              showToast("Records not found");
           }
       }
       else {
         setState(() {
           _loading = false;
         });
         showToast(jsonDecode(response.body)['ErrorMessage'].toString());
       }
     }
  }

  Future<void> _offermadelistByDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      offermadelist.clear();
      _loading = true;
    });
    final body = {
      "user_id": prefs.getString('userid'),
      "from_date": startdate,
      "to_date": enddate
    };
    var response = await http.post(Uri.parse(BASE_URL + offermade),
        body: jsonEncode(body),
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json'
    });
    setState((){
      _loading = false;
    });
    if(response.statusCode == 200) {
      if(jsonDecode(response.body)['Response']['data'].length == 0){
        showToast("Data not found");
      }
      else{
        setState((){
          offermadelist.addAll(jsonDecode(response.body)['Response']['data']);
        });
      }
    } else {
      setState(() {
        _loading = false;
      });
      print(response.body);
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  Future<void> _offermadelistBySearch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      offermadelist.clear();
      _loading = true;
    });
    final body = {
      "user_id": prefs.getString('userid'),
      "search": searchvalue,
    };
    var response = await http.post(Uri.parse(BASE_URL + offermade),
        body: jsonEncode(body),
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json'
    });
    setState(() {
      _loading = false;
    });
    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['ErrorCode'].toString() == "0") {
        setState(() {
          offermadelist.addAll(jsonDecode(response.body)['Response']['data']);
        });
      } else {
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

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      //firstDate: DateTime.now().subtract(Duration(days: 0)),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData(
              primaryColor: Colors.indigo,
              accentColor: Colors.indigo,
              primarySwatch: const MaterialColor(
                0xFF3949AB,
                <int, Color>{
                  50: Colors.indigo,
                  100: Colors.indigo,
                  200: Colors.indigo,
                  300: Colors.indigo,
                  400: Colors.indigo,
                  500: Colors.indigo,
                  600: Colors.indigo,
                  700: Colors.indigo,
                  800: Colors.indigo,
                  900: Colors.indigo,
                },
              )),
          child: child,
        );
      },
    );
    if (picked != null)
      setState(() {
        startdate = DateFormat('yyyy-MM-dd').format(picked);
      });
  }

  Future<void> _selectEndtDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      //firstDate: DateTime.now().subtract(Duration(days: 0)),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData(
              primaryColor: Colors.indigo,
              accentColor: Colors.indigo,
              primarySwatch: const MaterialColor(
                0xFF3949AB,
                <int, Color>{
                  50: Colors.indigo,
                  100: Colors.indigo,
                  200: Colors.indigo,
                  300: Colors.indigo,
                  400: Colors.indigo,
                  500: Colors.indigo,
                  600: Colors.indigo,
                  700: Colors.indigo,
                  800: Colors.indigo,
                  900: Colors.indigo,
                },
              )),
          child: child,
        );
      },
    );
    if (picked != null)
      setState(() {
        enddate = DateFormat('yyyy-MM-dd').format(picked);
      });
  }

  Map getOfferData = {};
  Future _getmakeoffer(String postid) async {
    rentpricelist.clear();
    renttypelist.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(jsonEncode({"user_id": prefs.getString('userid'), "post_ad_id": postid}));
    final body = {
      "user_id": prefs.getString('userid'),
      "post_ad_id": postid
    };
    var response = await http.post(Uri.parse(BASE_URL + createoffer),
        body: jsonEncode(body),
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json'
        });
    if (response.statusCode == 200) {
      var data = json.decode(response.body)['Response'];
      setState(() {
        if (data['data'] != "null") {
          getOfferData = data['data'];
        }

        negotiable = data['posted_ad']['negotiate'].toString();
        securitydeposit = data['posted_ad']['security'].toString();
        rentpricelist.addAll(data['posted_ad']['prices']);
        rentpricelist.forEach((element) {
          renttypelist.add(element['rent_type_name'].toString());
        });

        post_id = getOfferData['post_ad_id'].toString();
        renttypeid = getOfferData['rent_type_id'].toString();
        dialogstartDate = getOfferData['start_date'].toString().replaceAll("-", "/");
        renttypename = capitalize(getOfferData['rent_type_name'].toString());
        productQty = getOfferData['quantity'].toString();
        totalrent = double.parse(getOfferData['total_rent'].toString());
        useramount = getOfferData['renter_amount'].toString();
        days = getOfferData['period'].toString();
        totalsecurity = double.parse(getOfferData['total_security'].toString());
        finalamount = double.parse(getOfferData['final_amount'].toString());
        renteramount = "Listed Price: " + getOfferData['product_price'].toString() + "/" + capitalize(getOfferData['rent_type_name'].toString());
      });
      _opendataDialog(post_id);
    } else {
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  Future _setmakeoffer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(jsonEncode({
      "post_ad_id": post_id,
      "period": days,
      "rent_type": renttypeid,
      "quantity": productQty,
      "start_date": dialogstartDate,
      "renter_amount": useramount,
      "user_id": prefs.getString('userid'),
    }));
    final body = {
      "post_ad_id": post_id,
      "period": days,
      "rent_type": renttypeid,
      "quantity": productQty,
      "start_date": dialogstartDate,
      "renter_amount": useramount,
      "user_id": prefs.getString('userid'),
    };
    var response = await http.post(Uri.parse(BASE_URL + makeoffer),
        body: jsonEncode(body),
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json'
        });
    Navigator.of(context, rootNavigator: true).pop();
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      showToast(data['ErrorMessage'].toString());
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => HomeScreen()));
    } else {
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

  Future<void> _opendataDialog(String postid) async{
     SharedPreferences prefs = await SharedPreferences.getInstance();
     showDialog(
         context: context,
         barrierDismissible: false,
         builder:
             (context) =>
             StatefulBuilder(builder:
                 (context, setState) {
               return AlertDialog(
                   title: const Align(
                     alignment: Alignment
                         .topLeft,
                     child: Text(
                         "Make An Offer",
                         style: TextStyle(
                             color: Colors
                                 .deepOrangeAccent)),
                   ),
                   content: Container(
                      child: SingleChildScrollView(
                         child: Column(
                            children: [
                              DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  hint: renttypename == null  || renttypename == "null" ? Text("Select", style: TextStyle(color: Colors.black, fontSize: 18)) : Text(renttypename, style: TextStyle(color: Colors.black, fontSize: 18)),
                                  //value: capitalize(getOfferData['rent_type_name'].toString()),
                                  elevation: 16, isExpanded: true,
                                  style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
                                  onChanged: (String data) {
                                    setState(() {
                                      rentpricelist.forEach((element) {
                                        setState(() {
                                          if(element['rent_type_name'].toString() == data.toString()) {
                                            renttypename = data.toString();
                                            productamount = element['price'].toString();
                                            useramount = element['price'].toString();
                                            renttypeid = element['rent_type_id'].toString();
                                            renteramount = "Listed Price: ${element['price'].toString() + "/" + element['rent_type_name'].toString()}";
                                          }
                                        });
                                      });
                                    });
                                    print(renttypename);
                                  },
                                  items: renttypelist.map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Divider(height: 1, color: Colors.grey, thickness: 1),
                              const SizedBox(height: 20),
                              Align(alignment: Alignment.topLeft,
                                  child: renteramount == "null" || renteramount == null || renteramount == ""
                                      ? const Text("Listed Price: 00", style: TextStyle(color: Colors.black, fontSize: 16))
                                      : Text(renteramount, style: TextStyle(color: Colors.black, fontSize: 16))),
                              const SizedBox(height: 2),
                              const Divider(height: 1, color: Colors.grey, thickness: 1),
                              const SizedBox(height: 20),
                              Align(
                                  alignment: Alignment
                                      .topLeft,
                                  child: securitydeposit == "" || securitydeposit == "null" || securitydeposit == null
                                      ? Text("Security Deposit : 0", style: TextStyle(color: Colors.black, fontSize: 16))
                                      : Text("Security Deposit: $securitydeposit", style: TextStyle(color: Colors.black, fontSize: 16))),
                              const SizedBox(height: 2),
                              const Divider(height: 1, color: Colors.grey, thickness: 1),
                              const SizedBox(height: 10),
                              TextFormField(
                                initialValue: productQty,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  hintText: 'Enter Product Quantity',
                                  border: null,
                                ),
                                onChanged: (value) {
                                  setState(() {
                                        if(negotiable == "0") {
                                          productQty = value.toString();
                                          days == "null" || days == "" || days == null ? totalrent = 0 : totalrent = double.parse(productQty) * double.parse(days) * double.parse(productamount);
                                          totalsecurity = double.parse(productQty) * double.parse(securitydeposit);
                                          days == "null" || days == "" || days == null ? finalamount = totalsecurity + totalrent : finalamount = totalrent + totalsecurity;
                                        } else {
                                          setState(() {
                                            useramount = useramount == null ? null : useramount;
                                            days = days == null ? null : days;
                                          });

                                          double qtyg = double.parse(value.toString());
                                          double useramountg = useramount == null ? 1 : double.parse(useramount.toString());
                                          double daysg = days == null ? 1 : double.parse(days.toString());

                                          double totalrentg = qtyg * useramountg * daysg;
                                          setState(() {
                                            totalrent = 0;
                                            productQty = qtyg.toString();
                                            totalrent = totalrentg;
                                            totalsecurity = int.parse(securitydeposit) * qtyg;
                                            finalamount = totalsecurity + totalrent;
                                          });
                                        }
                                      });
                                },
                              ),
                              negotiable == "1" ? TextFormField(
                                initialValue: useramount,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: _getrenttypeamounthint(getOfferData['rent_type_name'].toString()),
                                  border: null,
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    productQty = productQty == null ? null : productQty;
                                    days = days == null ? null : days;
                                  });
                                  double qtyg = double.parse(productQty.toString());
                                  double useramountg = double.parse(value.toString());
                                  double daysg = days == null ? 1 : double.parse(days.toString());
                                  double totalrentg = qtyg * useramountg * daysg;
                                  setState(() {
                                    totalrent = 0;
                                    totalrent = totalrentg;
                                    useramount = useramountg.toString();
                                    totalsecurity = double.parse(securitydeposit) * qtyg;
                                    finalamount = totalsecurity + totalrent;
                                  });
                                },
                              ) : SizedBox(),
                              TextFormField(
                                initialValue: days,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: _getrenttypehint(capitalize(getOfferData['rent_type_name'].toString())),
                                  border: null,
                                ),
                                onChanged: (value) {
                                  if(negotiable == "0") {
                                    setState(() {
                                      productQty = productQty == null ? null : productQty;
                                      days = value.toString();
                                      days == null ? totalrent = 0 : totalrent = double.parse(productQty) * double.parse(days) * double.parse(productamount);
                                      totalsecurity = double.parse(productQty) * double.parse(securitydeposit);
                                      days == "null" || days == "" || days == null ? finalamount = totalsecurity + totalrent : finalamount = totalrent + totalsecurity;
                                    });
                                  } else {
                                    setState(() {
                                      productQty = productQty == null ? null : productQty;
                                      useramount = useramount == null ? null : useramount;
                                    });
                                    double qtyg = double.parse(productQty.toString());
                                    double useramountg = useramount == null ? 1 : double.parse(useramount.toString());
                                    double
                                    daysg = double.parse(value.toString());
                                    double totalrentg = qtyg * useramountg * daysg;
                                    setState(() {
                                      totalrent = 0;
                                      days = daysg.toString();
                                      totalrent = totalrentg;
                                      totalsecurity = double.parse(securitydeposit) * qtyg;
                                      finalamount = totalsecurity + totalrent;
                                    });
                                  }
                                },
                              ),
                              SizedBox(height: 20),
                              Align(alignment: Alignment.topLeft,
                                  child: totalrent == "" ||
                                      totalrent == "null" ||
                                      totalrent == null
                                      ? Text("Total Rent : 0", style: TextStyle(color: Colors.black, fontSize: 16))
                                      : Text("Total Rent: " + totalrent.toString(), style: TextStyle(color: Colors.black, fontSize: 16))),
                              const SizedBox(height: 2),
                              const Divider(height: 1, color: Colors.grey, thickness: 1),
                              SizedBox(height: 20),
                              Align(alignment: Alignment.topLeft,
                                  child: totalsecurity == "" ||
                                      totalsecurity == "null" ||
                                      totalsecurity == null
                                      ? Text("Total Security : 0", style: TextStyle(color: Colors.black, fontSize: 16))
                                      : Text("Total Security: " + totalsecurity.toString(), style: TextStyle(color: Colors.black, fontSize: 16))),
                              SizedBox(height: 2),
                              Divider(height: 1, color: Colors.grey, thickness: 1),
                              SizedBox(height: 20),
                              Align(alignment: Alignment.topLeft,
                                  child: finalamount == "" ||
                                      finalamount == "null" ||
                                      finalamount == null
                                      ? Text("Final Amount : 0", style: TextStyle(color: Colors.black, fontSize: 16))
                                      : Text("Final Amount: " + finalamount.toString(), style: TextStyle(color: Colors.black, fontSize: 16))),
                              SizedBox(height: 2),
                              Divider(height: 1, color: Colors.grey, thickness: 1),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(dialogstartDate, style: TextStyle(color: Colors.black, fontSize: 16)),
                                  IconButton(onPressed: () {
                                       _selectDialogStartDate(context, setState);},
                                      icon: Icon(Icons.calendar_today, size: 16))
                                ],
                              ),
                              SizedBox(height: 2),
                              Divider(height: 1, color: Colors.grey, thickness: 1),
                              SizedBox(height: 25),
                              InkWell(
                                onTap: () {
                                  if(renttypename == null || renttypename == ""){
                                    showToast("Please select rent type");
                                  }
                                  else if(productQty == null || productQty == ""){
                                    showToast("Please enter product quantity");
                                  }
                                  else if(days == null || days == ""){
                                    showToast("Please enter period");
                                  }
                                  else if(dialogstartDate == null || dialogstartDate == "" || dialogstartDate == "From Date"){
                                    showToast("Please enter start date");
                                  }
                                  else{
                                    _setmakeoffer();
                                  }
                                },
                                child: Container(
                                  height: 45,
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(color: Colors.deepOrangeAccent,borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                  child: Text("Make Offer", style: TextStyle(color: Colors.white)),
                                ),
                              )
                            ],
                         ),
                      ),
                   )
                 );
             }));
  }

  String _getrenttypeamounthint(String renttype) {
    if (renttype == "Hourly" || renttype == "hourly") {
      return "Enter Amount per Hour";
    } else if (renttype == "Weekly" || renttype == "weekly") {
      return "Enter Amount per Week";
    } else if (renttype == "Monthly" || renttype == "monthly") {
      return "Enter Amount per Month";
    } else if (renttype == "Yearly" || renttype == "yearly") {
      return "Enter Amount per Year";
    } else {
      return "Enter Amount per Day";
    }
  }

  String _getrenttypehint(String renttype) {
    if (renttype == "Hourly" || renttype == "hourly") {
      return "Enter Hours";
    } else if (renttype == "Weekly" || renttype == "weekly") {
      return "Enter Weeks";
    } else if (renttype == "Monthly" || renttype == "monthly") {
      return "Enter Months";
    } else if (renttype == "Yearly" || renttype == "yearly") {
      return "Enter Years";
    } else {
      return "Enter Days";
    }
  }

  Future<void> _selectDialogStartDate(BuildContext context, setState) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      //firstDate: DateTime.now().subtract(Duration(days: 0)),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData(
              primaryColor: Colors.indigo,
              accentColor: Colors.indigo,
              primarySwatch: const MaterialColor(
                0xFF3949AB,
                <int, Color>{
                  50: Colors.indigo,
                  100: Colors.indigo,
                  200: Colors.indigo,
                  300: Colors.indigo,
                  400: Colors.indigo,
                  500: Colors.indigo,
                  600: Colors.indigo,
                  700: Colors.indigo,
                  800: Colors.indigo,
                  900: Colors.indigo,
                },
              )),
          child: child,
        );
      },
    );
    if (picked != null)
      setState(() {
        dialogstartDate = DateFormat('yyyy/MM/dd').format(picked);
      });
  }
}
