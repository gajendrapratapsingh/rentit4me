import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rentit4me/network/api.dart';
import 'package:rentit4me/themes/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {

  String searchvalue = "Search";
  List<dynamic> paymentlist = [];

  bool _loading = false;

  String startdate = "From Date";
  String enddate = "To Date";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _paymentlist();

  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
        title: Text("Payment", style: TextStyle(color: kPrimaryColor)),
        centerTitle: true,
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
                        SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.only(left: 0.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              enabled: true,
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
                             if(searchvalue == "Search" || searchvalue.trim().isEmpty || searchvalue.trim().length == 0){
                                _paymentlistByDate();
                             }
                             else{
                                _paymentlistBySearch();
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
                Container(
                  height: size.height * 0.50,
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: paymentlist.length,
                    separatorBuilder: (BuildContext context, int index) => const Divider(),
                    itemBuilder: (BuildContext context, int index){
                      return Card(
                          elevation: 4.0,
                          child : Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("TXN_ID", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
                                          SizedBox(height: 4.0),
                                          Text(paymentlist[index]['txn_id'].toString())
                                        ]),
                                    Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Amount(XCD)", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
                                          SizedBox(height: 4.0),
                                          Text(paymentlist[index]['txn_amount'].toString())
                                        ]),
                                    Column(
                                      children: [
                                        Text("Created At", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
                                        SizedBox(height: 4.0),
                                        Text(paymentlist[index]['created_at'].toString().split("T")[0].toString())
                                      ],
                                    )
                                  ]),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Pay For", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
                                          SizedBox(height: 4.0),
                                          SizedBox(
                                              width: size.width * 0.65,
                                              child: Text(paymentlist[index]['payment_for'].toString())
                                          )
                                        ]),
                                    Column(children: [
                                      paymentlist[index]['status'].toString() == "success" ? Container(
                                            height: 35,
                                            width: 65,
                                            decoration: const BoxDecoration(
                                               color: Colors.green,
                                               borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                            ),
                                            alignment: Alignment.center,
                                            child: Text("Success", style: TextStyle(color: Colors.white)),
                                         ) : Container(
                                        height: 35,
                                        width: 65,
                                        decoration: const BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text("Fail", style: TextStyle(color: Colors.white)),
                                      )
                                    ]),
                                  ])
                            ]),
                          )
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _paymentlist() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _loading = true;
    });
    final body = {
      "id": prefs.getString('userid'),
    };
    var response = await http.post(Uri.parse(BASE_URL + transactions),
        body: jsonEncode(body),
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json'
        }
    );
    print(response.body);
    if(response.statusCode == 200) {
      if(jsonDecode(response.body)['Response']['Transactions'].length == 0){
        setState((){
          _loading = false;
        });
        showToast("Data not found");
      }
      else{
        setState((){
          _loading = false;
          paymentlist.addAll(jsonDecode(response.body)['Response']['Transactions']);
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

  Future<void> _paymentlistByDate() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      paymentlist.clear();
      _loading = true;
    });
    final body = {
      "id": prefs.getString('userid'),
      "from_date": startdate,
      "to_date": enddate
    };
    var response = await http.post(Uri.parse(BASE_URL + transactions),
        body: jsonEncode(body),
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json'
        }
    );
    print(response.body);
    if(response.statusCode == 200) {
      if(jsonDecode(response.body)['Response']['Transactions'].length == 0){
        setState((){
          _loading = false;
        });
        showToast("Data not found");
      }
      else{
        setState((){
          _loading = false;
          paymentlist.addAll(jsonDecode(response.body)['Response']['Transactions']);
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

  Future<void> _paymentlistBySearch() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      paymentlist.clear();
      _loading = true;
    });
    final body = {
      "id": prefs.getString('userid'),
      "search": searchvalue,
    };
    var response = await http.post(Uri.parse(BASE_URL + transactions),
        body: jsonEncode(body),
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json'
        }
    );
    print(response.body);
    if(response.statusCode == 200) {
      if(jsonDecode(response.body)['Response']['Transactions'].length == 0){
        setState((){
          _loading = false;
        });
        showToast("Data not found");
      }
      else{
        setState((){
          _loading = false;
          paymentlist.addAll(jsonDecode(response.body)['Response']['Transactions']);
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
}
