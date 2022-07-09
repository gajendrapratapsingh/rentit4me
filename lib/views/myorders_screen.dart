import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rentit4me/network/api.dart';
import 'package:rentit4me/themes/constant.dart';
import 'package:rentit4me/views/order_detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({Key key}) : super(key: key);

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  String searchvalue = "Search";
  List<dynamic> myorderslist = [];

  bool _progress = false;

  String startdate = "From Date";
  String enddate = "To Date";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _myorderslist();

    /*Future<ProfileResponse> temp = _getprofile();
    print(temp);
    temp.then((value) {
      setState(() {
        //profileimage = value.avatarBaseUrl.toString()+value.avatarPath.toString();
        name = value.username.toString();
        mobile = value.mobile.toString();
        email = value.email.toString();
        address = value.address.toString();
        print(profileimage);
      });
    });*/
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
        title: Text("My Orders", style: TextStyle(color: kPrimaryColor)),
        centerTitle: true,
      ),
      body: ModalProgressHUD(
        inAsyncCall: _progress,
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
                            if(searchvalue == "Search" || searchvalue.length == 0 || searchvalue.isEmpty){
                               _myorderslistByDate();
                            }
                            else {
                              _myorderslistBySearch();
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0))),
                              child: Text("Filter",
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Container(
                  height: size.height * 0.50,
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: myorderslist.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(),
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                  title: Text('Detail Information'),
                                  content: SingleChildScrollView(
                                      child: Column(children: [
                                    Card(
                                      color: Colors.grey[100],
                                      child: ListTile(
                                        title: Text("Rentee"),
                                        subtitle: Text(myorderslist[index]
                                                ['name']
                                            .toString()),
                                      ),
                                    ),
                                    Card(
                                      color: Colors.grey[100],
                                      child: ListTile(
                                        title: Text("Product Name"),
                                        subtitle: Text(myorderslist[index]
                                                ["title"]
                                            .toString()),
                                      ),
                                    ),
                                    Card(
                                      color: Colors.grey[100],
                                      child: ListTile(
                                        title: Text("Product Quantity"),
                                        subtitle: Text(myorderslist[index]
                                                ["quantity"]
                                            .toString()),
                                      ),
                                    ),
                                    Card(
                                      color: Colors.grey[100],
                                      child: ListTile(
                                        title: Text("Rent Type"),
                                        subtitle: Text(myorderslist[index]
                                                ["rent_type_name"]
                                            .toString()),
                                      ),
                                    ),
                                    Card(
                                      color: Colors.grey[100],
                                      child: ListTile(
                                        title: Text("Period"),
                                        subtitle: Text(myorderslist[index]
                                                ["period"]
                                            .toString()),
                                      ),
                                    ),
                                    Card(
                                      color: Colors.grey[100],
                                      child: ListTile(
                                        title: Text("Product Price(XCD)"),
                                        subtitle: Text(myorderslist[index]
                                                ["product_price"]
                                            .toString()),
                                      ),
                                    ),
                                    Card(
                                      color: Colors.grey[100],
                                      child: ListTile(
                                        title: Text("Offer Amount(XCD)"),
                                        subtitle: Text(myorderslist[index]
                                                ["renter_amount"]
                                            .toString()),
                                      ),
                                    ),
                                    Card(
                                      color: Colors.grey[100],
                                      child: ListTile(
                                        title: Text("Total Rent(XCD)"),
                                        subtitle: Text(myorderslist[index]
                                                ["total_rent"]
                                            .toString()),
                                      ),
                                    ),
                                    Card(
                                      color: Colors.grey[100],
                                      child: ListTile(
                                        title: Text("Total Security(XCD)"),
                                        subtitle: Text(myorderslist[index]
                                                ["total_security"]
                                            .toString()),
                                      ),
                                    ),
                                    Card(
                                      color: Colors.grey[100],
                                      child: ListTile(
                                        title: Text("Total Rent(XCD)"),
                                        subtitle: Text(myorderslist[index]
                                                ["total_rent"]
                                            .toString()),
                                      ),
                                    ),
                                    Card(
                                      color: Colors.grey[100],
                                      child: ListTile(
                                        title: Text("Final Amount(XCD)"),
                                        subtitle: Text(myorderslist[index]
                                                ["final_amount"]
                                            .toString()),
                                      ),
                                    ),
                                  ]))));
                        },
                        child: Card(
                          elevation: 4.0,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 5.0, bottom: 5.0),
                            child: ListTile(
                              title: InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => OrderDetailScreen(orderid: myorderslist[index]['id'].toString())));
                                },
                                child: Text("Order Id : " + myorderslist[index]['order_id'].toString()),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Product : " + myorderslist[index]['title'].toString()),
                                  SizedBox(height: 5),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        myorderslist[index]['quantity'] == null ? SizedBox() : Text("Qty: " + myorderslist[index]['quantity'].toString()),
                                        Text("Period: " + myorderslist[index]['period'].toString()),
                                        Text("Rent type: " + myorderslist[index]['rent_type_name'].toString()),
                                      ])
                                ],
                              ),
                              trailing: myorderslist[index]["offer_status"].toString() == "1"
                                  ? InkWell(
                                      onTap: () {},
                                      child: Container(
                                        padding: EdgeInsets.all(4.0),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(4.0)),
                                            border:
                                                Border.all(color: Colors.blue)),
                                        child: Text("Action",
                                            style:
                                                TextStyle(color: Colors.blue)),
                                      ),
                                    )
                                  : _getaction(myorderslist[index]
                                          ["offer_status"]
                                      .toString()),
                            ),
                          ),
                        ),
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

  DataCell _getPeriod(String period, String type) {
    if (type == "hourly") {
      if (period == "1") {
        return DataCell(Text(period + " " + "Hour"));
      } else {
        return DataCell(Text(period + " " + "Hours"));
      }
    } else if (type == "yearly") {
      if (period == "1") {
        return DataCell(Text(period + " " + "Year"));
      } else {
        return DataCell(Text(period + " " + "Years"));
      }
    } else if (type == "monthly") {
      if (period == "1") {
        return DataCell(Text(period + " " + "Month"));
      } else {
        return DataCell(Text(period + " " + "Months"));
      }
    } else {
      if (period == "1") {
        return DataCell(Text(period + " " + "Day"));
      } else {
        return DataCell(Text(period + " " + "Days"));
      }
    }
  }

  DataCell _getstatus(String statusvalue) {
    if (statusvalue == "3") {
      return DataCell(Text("Pending"));
    } else if (statusvalue == "13") {
      return DataCell(Text("Completed"));
    } else if (statusvalue == "2") {
      return DataCell(Text("Rejected"));
    } else {
      return DataCell(Text("Accepted"));
    }
  }

  Future<void> _myorderslist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
        _progress = true;
        myorderslist.clear();
      });
      print(jsonEncode({
        "id": prefs.getString('userid'),
        "search": searchvalue,
        "from_date": startdate,
        "to_date": enddate
      }));
      final body = {
        "id": prefs.getString('userid'),
        //"search": searchvalue,
        //"from_date": startdate,
        //"to_date": enddate
      };
      var response = await http.post(Uri.parse(BASE_URL + myorders),
          body: jsonEncode(body),
          headers: {
            "Accept": "application/json",
            'Content-Type': 'application/json'
          });
      print(response.body);
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['ErrorCode'].toString() == "0") {
          setState(() {
            myorderslist.addAll(jsonDecode(response.body)['Response']['Orders']);
            _progress = false;
          });
        } else {
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

  Future<void> _myorderslistByDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _progress = true;
      myorderslist.clear();
    });
    print(jsonEncode({
      "id": prefs.getString('userid'),
      "from_date": startdate,
      "to_date": enddate
    }));
    final body = {
      "id": prefs.getString('userid'),
      "from_date": startdate,
      "to_date": enddate
    };
    var response = await http.post(Uri.parse(BASE_URL + myorders),
        body: jsonEncode(body),
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json'
        });
    print(response.body);
    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['ErrorCode'].toString() == "0") {
        setState(() {
          myorderslist.addAll(jsonDecode(response.body)['Response']['Orders']);
          _progress = false;
        });
      } else {
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

  Future<void> _myorderslistBySearch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _progress = true;
      myorderslist.clear();
    });
    print(jsonEncode({
      "id": prefs.getString('userid'),
      "search": searchvalue,
    }));
    final body = {
      "id": prefs.getString('userid'),
       "search": searchvalue,
    };
    var response = await http.post(Uri.parse(BASE_URL + myorders),
        body: jsonEncode(body),
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json'
        });
    print(response.body);
    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['ErrorCode'].toString() == "0") {
        setState(() {
          myorderslist.addAll(jsonDecode(response.body)['Response']['Orders']);
          _progress = false;
        });
      } else {
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


  Widget _getaction(String statusvalue) {
    if (statusvalue == "3") {
      return Container(
        padding: EdgeInsets.all(4.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
            border: Border.all(color: Colors.blue)),
        child: Text("Edit", style: TextStyle(color: Colors.blue)),
      );
    } else if (statusvalue == "13") {
      return Text("NA", style: TextStyle(color: Colors.grey));
    } else {
      return Text("NA", style: TextStyle(color: Colors.grey));
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
