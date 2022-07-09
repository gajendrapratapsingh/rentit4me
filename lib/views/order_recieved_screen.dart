import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rentit4me/network/api.dart';
import 'package:rentit4me/themes/constant.dart';
import 'package:rentit4me/views/order_detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderRecievedScreen extends StatefulWidget {
  const OrderRecievedScreen({Key key}) : super(key: key);

  @override
  State<OrderRecievedScreen> createState() => _OrderRecievedScreenState();
}

class _OrderRecievedScreenState extends State<OrderRecievedScreen> {

  String searchvalue = "Search";
  List<dynamic> myactiveorderslist = [];

  bool _progress = false;

  String startdate = "From Date";
  String enddate = "To Date";

  String pickup;

  List<String> responselist = ['Schedular Pickup', 'Self Delivered', 'Cancel'];
  String responsevalue;
  String response;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _myrecievedorderslist();

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
            child: const Icon(Icons.arrow_back, color: kPrimaryColor)),
        title: Text("Recieve Orders", style: TextStyle(color: kPrimaryColor)),
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
                              searchvalue = value;
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
                                _myrecievedorderslistByDate();
                             }
                             else{
                                _myrecievedorderslistBySearch();
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
                SizedBox(height: 5),
                Container(
                   height: size.height * 0.50,
                   child: ListView.separated(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: myactiveorderslist.length,
                    separatorBuilder: (BuildContext context, int index) => const Divider(),
                    itemBuilder: (BuildContext context, int index){
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
                                         title: Text("Order Id"),
                                         subtitle: Text(myactiveorderslist[index]['order_id'].toString()),
                                          
                                      ),
                                    ),
                                    Card(
                                      color: Colors.grey[100],
                                      child: ListTile(
                                         title: Text("Product Name"),
                                         subtitle: Text(myactiveorderslist[index]["title"].toString()),
                                          
                                      ),
                                    ),
                                    Card(
                                      color: Colors.grey[100],
                                      child: ListTile(
                                         title: Text("Product Quantity"),
                                         subtitle: Text(myactiveorderslist[index]["quantity"].toString()),
                                          
                                      ),
                                    ),
                                    Card(
                                      color: Colors.grey[100],
                                      child: ListTile(
                                         title: Text("Rent Type"),
                                         subtitle: Text(myactiveorderslist[index]["rent_type_name"].toString()),
                                          
                                      ),
                                    ),
                                    Card(
                                      color: Colors.grey[100],
                                      child: ListTile(
                                         title: Text("Period"),
                                         subtitle: Text(myactiveorderslist[index]["period"].toString()),
                                          
                                      ),
                                    ),
                                    Card(
                                      color: Colors.grey[100],
                                      child: ListTile(
                                         title: Text("Product Price(INR)"),
                                         subtitle: Text(myactiveorderslist[index]["product_price"].toString()),
                                          
                                      ),
                                    ),
                                    Card(
                                      color: Colors.grey[100],
                                      child: ListTile(
                                         title: Text("Offer Amount(INR)"),
                                         subtitle: Text(myactiveorderslist[index]["renter_amount"].toString()),
                                          
                                      ),
                                    ),
                                    Card(
                                      color: Colors.grey[100],
                                      child: ListTile(
                                         title: Text("Total Rent(INR)"),
                                         subtitle: Text(myactiveorderslist[index]["total_rent"].toString()),
                                          
                                      ),
                                    ),
                                    Card(
                                      color: Colors.grey[100],
                                      child: ListTile(
                                         title: Text("Total Security(INR)"),
                                         subtitle: Text(myactiveorderslist[index]["total_security"].toString()),
                                          
                                      ),
                                    ),
                                    Card(
                                      color: Colors.grey[100],
                                      child: ListTile(
                                         title: Text("Total Rent(INR)"),
                                         subtitle: Text(myactiveorderslist[index]["total_rent"].toString()),
                                          
                                      ),
                                    ),
                                    Card(
                                      color: Colors.grey[100],
                                      child: ListTile(
                                 title: Text("Final Amount(INR)"),
                                         subtitle: Text(myactiveorderslist[index]["final_amount"].toString()),
                                          
                                      ),
                                    ),
                                  
                                ]))));
                         },
                         child: Card(
                            elevation: 4.0,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                              child: ListTile(
                                 title: InkWell(
                                   onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => OrderDetailScreen(orderid: myactiveorderslist[index]['id'].toString())));
                                   },
                                   child:  Text("Order Id : " + myactiveorderslist[index]['order_id'].toString()),
                                 ),
                                 subtitle: Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                      Text("Product : "+myactiveorderslist[index]['title'].toString()),
                                      SizedBox(height: 5),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Qty: "+myactiveorderslist[index]['quantity'].toString()),
                                          Text("Period: "+myactiveorderslist[index]['period'].toString()),
                                          Text("Rent type: "+myactiveorderslist[index]['rent_type_name'].toString()),
                                      ]),
                                      SizedBox(height: 10.0),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                           Container(
                                             height: 40,
                                             width: 80,
                                             alignment: Alignment.center,
                                             decoration: BoxDecoration(
                                                color: Colors.deepOrangeAccent,
                                                borderRadius: BorderRadius.circular(8.0)
                                             ),
                                             child: myactiveorderslist[index]["scheduler_pickup"].toString() == "0" ? Text("Self Driver", textAlign: TextAlign.center, style: TextStyle(color: Colors.white)) : Text("Schedular Pickup", textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
                                           ),
                                           Container(
                                            height: 40,
                                            width: 90,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                color: Colors.deepPurpleAccent,
                                                borderRadius: BorderRadius.circular(8.0)
                                            ),
                                            child: Text(_getStatus(myactiveorderslist[index]["status"].toString()), textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
                                            ),
                                              _getStatus(myactiveorderslist[index]["status"].toString()) == "Respond" ? InkWell(
                                               onTap:(){
                                                 showDialog(
                                                    context: context,
                                                    barrierDismissible: false,
                                                    builder: (context)=> StatefulBuilder(
                                                        builder: (context, setState){
                                                          return AlertDialog(
                                                            title: Text("Response", style: TextStyle(color: Colors.deepOrangeAccent)),
                                                            content: Container(
                                                              child: SingleChildScrollView(
                                                                  child: Column(children: [
                                                                    DropdownButtonHideUnderline(
                                                                      child: DropdownButton<String>(
                                                                        hint: Text("Select", style: TextStyle(color: Colors.black, fontSize: 18)),
                                                                        value: response,
                                                                        elevation: 16,
                                                                        isExpanded: true,
                                                                        style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
                                                                        onChanged: (String data) {
                                                                          setState(() {
                                                                            if(data.toString() == "Cancel"){
                                                                              responsevalue = "cancelled";
                                                                              response = data.toString();
                                                                            }
                                                                            else if(data.toString() == "Self Delivered"){
                                                                              responsevalue = "delivered";
                                                                              response = data.toString();
                                                                            }
                                                                            else{
                                                                              responsevalue = "scheduler pickup";
                                                                              response = data.toString();
                                                                            }
                                                                          });
                                                                        },
                                                                        items: responselist.map<DropdownMenuItem<String>>((String value) {
                                                                          return DropdownMenuItem<String>(
                                                                            value: value,
                                                                            child: Text(value),
                                                                          );
                                                                        }).toList(),
                                                                      ),
                                                                    ),
                                                                    const SizedBox(height: 2),
                                                                    const Divider(height: 1, color: Colors.grey, thickness: 1),
                                                                    const SizedBox(height: 25),
                                                                    InkWell(onTap:() {
                                                                      if(responsevalue == null || responsevalue == "" || responsevalue == "null"){
                                                                        showToast("Please select your response");
                                                                      }
                                                                      else{
                                                                         _submitrespond(myactiveorderslist[index]["id"].toString(), responsevalue);
                                                                      }
                                                                    },
                                                                      child: Container(
                                                                        height: 45,
                                                                        width: double.infinity,
                                                                        alignment: Alignment.center,
                                                                        decoration: const BoxDecoration(
                                                                            color: Colors.deepOrangeAccent,
                                                                            borderRadius: BorderRadius.all(Radius.circular(8.0))
                                                                        ),
                                                                        child: Text("Submit", style: TextStyle(color: Colors.white)),
                                                                      ),
                                                                    )
                                                                  ])
                                                              ),
                                                            ),
                                                          );
                                                        }
                                                    )
                                                );
                                             },
                                            child: Container(
                                              height: 40,
                                              width: 80,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  color: kPrimaryColor,
                                                  borderRadius: BorderRadius.circular(8.0)
                                              ),
                                              child: Text(_getStatus(myactiveorderslist[index]["status"].toString()), style: TextStyle(color: Colors.white)),
                                            ),
                                          ) : InkWell(
                                            onTap:(){
                                               if(_getStatus(myactiveorderslist[index]["status"].toString()) == "Recieved"){
                                                   _confirmation(context, myactiveorderslist[index]["id"].toString());
                                               }
                                            },
                                            child: Container(
                                                height: 40,
                                                width: 80,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    color: Colors.lightGreen,
                                                    borderRadius: BorderRadius.circular(8.0)
                                                ),
                                                child: Text(_getStatus(myactiveorderslist[index]["status"].toString()), style: TextStyle(color: Colors.white)),
                                              ),
                                          )
                                       ],
                                     )
                                   ],
                                 ),
                                 trailing: myactiveorderslist[index]["offer_status"].toString() == "1" ? InkWell(
                                      onTap: (){
                                          
                                      }, 
                                      child: Container(
                                         padding: EdgeInsets.all(4.0),
                                         decoration: BoxDecoration(
                                           borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                           border: Border.all(color: Colors.blue)
                                        ),
                                        child: Text("Action", style: TextStyle(color: Colors.blue)),
                                      ), 
                                 ) : _getaction(myactiveorderslist[index]["offer_status"].toString()),
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

  Widget _getaction(String statusvalue){
    if(statusvalue == "3"){
      return Container(
        padding: EdgeInsets.all(4.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
            border: Border.all(color: Colors.blue)
        ),
        child: Text("Edit", style: TextStyle(color: Colors.blue)),
      );
    }
    else if(statusvalue == "13"){
      return Text("NA", style: TextStyle(color: Colors.grey));
    }
    else{
      return Text("NA", style: TextStyle(color: Colors.grey));
    }
  }

  Future<void> _myrecievedorderslist() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      myactiveorderslist.clear();
      _progress = true;
    });
    final body = {
      "user_id": prefs.getString('userid'),
    };
    var response = await http.post(Uri.parse(BASE_URL + orderreceived),
        body: jsonEncode(body),
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json'
        }
    );
    setState((){
      _progress = false;
    });
    if (response.statusCode == 200) {
      if(jsonDecode(response.body)['ErrorCode'].toString() == "0"){
        setState((){
           myactiveorderslist.addAll(jsonDecode(response.body)['Response']['Orders']);
        });
      }
      else {
        showToast(jsonDecode(response.body)['ErrorMessage'].toString());
      }
    } else {
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  Future<void> _myrecievedorderslistByDate() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      myactiveorderslist.clear();
      _progress = true;
    });
    final body = {
      "id": prefs.getString('userid'),
      "from_date": startdate,
      "to_date": enddate
    };
    var response = await http.post(Uri.parse(BASE_URL + orderreceived),
        body: jsonEncode(body),
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json'
        }
    );
    setState((){
      _progress = false;
    });
    if (response.statusCode == 200) {
      if(jsonDecode(response.body)['ErrorCode'].toString() == "0"){
        setState((){
          myactiveorderslist.addAll(jsonDecode(response.body)['Response']['Orders']);
        });
      }
      else {
        showToast(jsonDecode(response.body)['ErrorMessage'].toString());
      }
    } else {
      setState((){
        _progress = false;
      });
      print(response.body);
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  Future<void> _myrecievedorderslistBySearch() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      myactiveorderslist.clear();
      _progress = true;
    });
    final body = {
      "id": prefs.getString('userid'),
      "search": searchvalue,
    };
    var response = await http.post(Uri.parse(BASE_URL + orderreceived),
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
          myactiveorderslist.addAll(jsonDecode(response.body)['Response']['Orders']);
          _progress = false;
        });
      }
      else {
        setState((){
          _progress = false;
        });
        showToast(jsonDecode(response.body)['ErrorMessage'].toString());
      }
    } else {
      setState((){
        _progress = false;
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

  _getStatus(String status){
     if(status == "delivered"){
        return "Delivered";
     }
     else if(status == "pending"){
        return "Respond";
     }
     else if(status == "completed"){
       return "Completed";
     }
     else if(status == "returned"){
       return "Recieved";
     }
     else if(status == "cancelled"){
       return "Cancelled";
     }
     else if(status == "active"){
       return "Active";
     }
     else{
        return "Renew";
     }
  }

  Future<void> _submitrespond(String orderid, String respond) async{
    setState((){
      _progress = true;
    });
    final body = {
      "order_id": orderid,
      "status": respond,
    };
    var response = await http.post(Uri.parse(BASE_URL + orderrespond),
        body: jsonEncode(body),
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json'
        }
    );
    setState((){
      _progress = false;
    });
    if(response.statusCode == 200) {
      if(jsonDecode(response.body)['ErrorCode'].toString() == "0"){
        Navigator.of(context, rootNavigator: true).pop('dialog');
        showToast(jsonDecode(response.body)['ErrorMessage'].toString());
      }
      else {
        Navigator.of(context, rootNavigator: true).pop('dialog');
        showToast(jsonDecode(response.body)['ErrorMessage'].toString());
      }
    } else {
      setState((){
        _progress = false;
      });
      print(response.body);
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  Future<void> _confirmation(BuildContext context, String orderid) {
    return showDialog(
      builder: (context) => AlertDialog(
        actionsPadding: EdgeInsets.all(0),
        insetPadding: EdgeInsets.all(0),
        title: const Text('Confirmation'),
        content: const Text("Are you recieved your product?", style: TextStyle(color: Colors.black54),
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('CANCEL', style: TextStyle(color: kPrimaryColor)),
          ),
          FlatButton(
            onPressed: () {
               Navigator.pop(context);
               _submitrespond(orderid, "complete");
              //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => SignUp()), (route) => false);
            },
            child: const Text('Yes', style: TextStyle(color: kPrimaryColor),
            ),
          ),
        ],
      ),
      context: context,
    );
  }

}
