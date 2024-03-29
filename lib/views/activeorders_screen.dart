import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rentit4me/network/api.dart';
import 'package:rentit4me/themes/constant.dart';
import 'package:rentit4me/views/order_detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ActiveOrderScreen extends StatefulWidget {
  const ActiveOrderScreen({Key key}) : super(key: key);

  @override
  State<ActiveOrderScreen> createState() => _ActiveOrderScreenState();
}

class _ActiveOrderScreenState extends State<ActiveOrderScreen> {

  String searchvalue = "Enter order id";
  List<dynamic> myactiveorderslist = [];

  bool _progress = false;

  String startdate = "From Date";
  String enddate = "To Date";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _myactiveorderslist();
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
        title: const Text("Active Orders", style: TextStyle(color: kPrimaryColor)),
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
                        const SizedBox(height: 5),
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
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                                          }, icon: const Icon(Icons.calendar_today_sharp, size: 16, color: kPrimaryColor))
                                        ],
                                      ),
                                    )
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                                          Text(enddate, style: const TextStyle(color: Colors.grey)),
                                          IconButton(onPressed: (){
                                            _selectEndtDate(context);
                                          }, icon: const Icon(Icons.calendar_today_sharp, size: 16, color: kPrimaryColor))
                                        ],
                                      ),
                                    )
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        InkWell(
                          onTap: () {
                            if(searchvalue == "Enter order id" && startdate == "From Date"){
                              showToast("Please enter your search or select date");
                            }
                            else{
                              if(searchvalue == "Enter order id" || searchvalue.length == 0 || searchvalue.isEmpty){
                                _myactiveorderslistByDate();
                              }
                              else{
                                _myactiveorderslistBySearch();
                              }
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
                              child: const Text("Filter", style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 5),
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
                                title: const Text('Detail Information'),
                                content: SingleChildScrollView(child:  Column(children: [
                                    Card(
                                      color: Colors.grey[100],
                                      child: ListTile(
                                         title: const Text("Order Id"),
                                         subtitle: Text(myactiveorderslist[index]['order_id'].toString()),
                                          
                                      ),
                                    ),
                                    Card(
                                      color: Colors.grey[100],
                                      child: ListTile(
                                         title: const Text("Product Name"),
                                         subtitle: Text(myactiveorderslist[index]["title"].toString()),
                                          
                                      ),
                                    ),
                                    Card(
                                      color: Colors.grey[100],
                                      child: ListTile(
                                         title: const Text("Product Quantity"),
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
                                         title: const Text("Period"),
                                         subtitle: Text(myactiveorderslist[index]["period"].toString()),
                                          
                                      ),
                                    ),
                                    Card(
                                      color: Colors.grey[100],
                                      child: ListTile(
                                         title: const Text("Product Price(INR)"),
                                         subtitle: Text(myactiveorderslist[index]["product_price"].toString()),
                                          
                                      ),
                                    ),
                                    Card(
                                      color: Colors.grey[100],
                                      child: ListTile(
                                         title: const Text("Offer Amount(INR)"),
                                         subtitle: Text(myactiveorderslist[index]["renter_amount"].toString()),
                                          
                                      ),
                                    ),
                                    Card(
                                      color: Colors.grey[100],
                                      child: ListTile(
                                         title: const Text("Total Rent(INR)"),
                                         subtitle: Text(myactiveorderslist[index]["total_rent"].toString()),
                                          
                                      ),
                                    ),
                                    Card(
                                      color: Colors.grey[100],
                                      child: ListTile(
                                         title: const Text("Total Security(INR)"),
                                         subtitle: Text(myactiveorderslist[index]["total_security"].toString()),
                                          
                                      ),
                                    ),
                                    Card(
                                      color: Colors.grey[100],
                                      child: ListTile(
                                         title: const Text("Total Rent(INR)"),
                                         subtitle: Text(myactiveorderslist[index]["total_rent"].toString()),
                                          
                                      ),
                                    ),
                                    Card(
                                      color: Colors.grey[100],
                                      child: ListTile(
                                 title: const Text("Final Amount(INR)"), subtitle: Text(myactiveorderslist[index]["final_amount"].toString()),
                                          
                                      ),
                                    ),
                                  
                                ]))));
                         },
                         child: Card(
                           elevation: 4.0,
                           child: Padding(
                             padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Padding(
                                     padding: const EdgeInsets.only(left : 8.0),
                                     child: Text("Order Id : ${myactiveorderslist[index]['order_id']}", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500))),
                                 Row(
                                   mainAxisAlignment: MainAxisAlignment.start,
                                   children: [
                                     TextButton(onPressed: (){
                                       Navigator.push(context, MaterialPageRoute(builder: (context) => OrderDetailScreen(orderid: myactiveorderslist[index]['id'].toString())));
                                     }, child: SizedBox(
                                         width: size.width * 0.60,
                                         child: Text("Product Name : ${myactiveorderslist[index]['title']}")
                                     )),
                                     const SizedBox(width: 4.0),
                                        InkWell(onTap: (){
                                        //_confirmation(context, myorderslist[index]['id'].toString());
                                     }, child: Container(
                                         width: 80,
                                         alignment: Alignment.center,
                                         padding: EdgeInsets.all(4.0),
                                         decoration: BoxDecoration(
                                             borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                             border: Border.all(color: Colors.grey)),  child: const Text("NA", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey))))
                                   ],
                                 ),
                                 const SizedBox(height: 10.0),
                                 Padding(
                                   padding: const EdgeInsets.all(8.0),
                                   child: Row(
                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                     children: [
                                       Text("Quantity: ${myactiveorderslist[index]['quantity']}"),
                                       myactiveorderslist[index]['period'].toString() == "" || myactiveorderslist[index]['period'] == null ? SizedBox() : Text("Period: "+myactiveorderslist[index]['period'].toString()+" "+_getrenttype(myactiveorderslist[index]['period'].toString(), myactiveorderslist[index]['rent_type_name'].toString()), style: TextStyle(color: Colors.black, fontSize: 14)),
                                     ],
                                   ),
                                 ),
                                 const SizedBox(height: 5.0),
                                 Padding(
                                   padding: const EdgeInsets.all(8.0),
                                   child: Row(
                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                     children: [
                                       Text("Rent type: ${myactiveorderslist[index]['rent_type_name']}"),
                                       Text("Status: ${myactiveorderslist[index]['status']}"),
                                     ],
                                   ),
                                 )
                               ],
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
        child: const Text("Edit", style: TextStyle(color: Colors.blue)),
      );
    }
    else if(statusvalue == "13"){
      return const Text("NA", style: TextStyle(color: Colors.grey));
    }
    else{
      return const Text("NA", style: TextStyle(color: Colors.grey));
    }
  }

  Future<void> _myactiveorderslist() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      myactiveorderslist.clear();
      _progress = true;
    });
    final body = {
      "id": prefs.getString('userid'),
    };
    var response = await http.post(Uri.parse(BASE_URL + activeorders),
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

  Future<void> _myactiveorderslistByDate() async{
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
    var response = await http.post(Uri.parse(BASE_URL + activeorders),
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

  Future<void> _myactiveorderslistBySearch() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      myactiveorderslist.clear();
      _progress = true;
    });
    final body = {
      "id": prefs.getString('userid'),
      "search": searchvalue,
    };
    var response = await http.post(Uri.parse(BASE_URL + activeorders),
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
    if(picked != null) {
      setState(() {
        startdate = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
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
    if(picked != null) {
      setState(() {
        enddate = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  String _getrenttype(String period, String renttypevalue){
    if(renttypevalue.toLowerCase() == "hourly" &&  period == "1"){
      return "Hour";
    }
    if(renttypevalue.toLowerCase() == "hourly" &&  period != "1"){
      return "Hours";
    }
    else if(renttypevalue.toLowerCase() == "days" && period == "1"){
      return "Day";
    }
    else if(renttypevalue.toLowerCase() == "days" && period != "1"){
      return "Days";
    }
    else if(renttypevalue.toLowerCase() == "monthly" && period == "1"){
      return "Month";
    }
    else if(renttypevalue.toLowerCase() == "monthly" && period != "1"){
      return "Months";
    }
    else if(renttypevalue == "yearly" && period == "1"){
      return "Year";
    }
    else if(renttypevalue == "yearly" && period != "1"){
      return "Years";
    }
  }

}
