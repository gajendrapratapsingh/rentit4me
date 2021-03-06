import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rentit4me/network/api.dart';
import 'package:rentit4me/themes/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompletedOrderScreen extends StatefulWidget {
  const CompletedOrderScreen({Key key}) : super(key: key);

  @override
  State<CompletedOrderScreen> createState() => _CompletedOrderScreenState();
}

class _CompletedOrderScreenState extends State<CompletedOrderScreen> {

  String searchvalue = "Enter order id";
  List<dynamic> completedorderslist = [];

  bool _loading = false;

  String startdate = "From Date";
  String enddate = "To Date";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _completedorderslist();

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
            child: Icon(
              Icons.arrow_back,
              color: kPrimaryColor,
            )),
        title: Text("Completed Orders", style: TextStyle(color: kPrimaryColor)),
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
                             if(searchvalue == "Enter order id" || searchvalue.length == 0 || searchvalue.isEmpty){
                                _completedorderslistByDate();
                             }
                             else{
                               _completedorderslistBySearch();
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
                    itemCount: completedorderslist.length,
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
                                         subtitle: Text(completedorderslist[index]['order_id'].toString()),
                                          
                                      ),
                                    ),
                                    Card(
                                      color: Colors.grey[100],
                                      child: ListTile(
                                         title: Text("Product Name"),
                                         subtitle: Text(completedorderslist[index]["title"].toString()),
                                          
                                      ),
                                    ),
                                    Card(
                                      color: Colors.grey[100],
                                      child: ListTile(
                                         title: Text("Product Quantity"),
                                         subtitle: Text(completedorderslist[index]["quantity"].toString()),
                                          
                                      ),
                                    ),
                                    Card(
                                      color: Colors.grey[100],
                                      child: ListTile(
                                         title: Text("Rent Type"),
                                         subtitle: Text(completedorderslist[index]["rent_type_name"].toString()),
                                          
                                      ),
                                    ),
                                    Card(
                                      color: Colors.grey[100],
                                      child: ListTile(
                                         title: Text("Period"),
                                         subtitle: Text(completedorderslist[index]["period"].toString()),
                                          
                                      ),
                                    ),
                                    Card(
                                      color: Colors.grey[100],
                                      child: ListTile(
                                         title: Text("Product Price(INR)"),
                                         subtitle: Text(completedorderslist[index]["product_price"].toString()),
                                          
                                      ),
                                    ),
                                    Card(
                                      color: Colors.grey[100],
                                      child: ListTile(
                                         title: Text("Offer Amount(INR)"),
                                         subtitle: Text(completedorderslist[index]["renter_amount"].toString()),
                                          
                                      ),
                                    ),
                                    Card(
                                      color: Colors.grey[100],
                                      child: ListTile(
                                         title: Text("Total Rent(INR)"),
                                         subtitle: Text(completedorderslist[index]["total_rent"].toString()),
                                          
                                      ),
                                    ),
                                    Card(
                                      color: Colors.grey[100],
                                      child: ListTile(
                                         title: Text("Total Security(INR)"),
                                         subtitle: Text(completedorderslist[index]["total_security"].toString()),
                                          
                                      ),
                                    ),
                                    Card(
                                      color: Colors.grey[100],
                                      child: ListTile(
                                         title: Text("Total Rent(INR)"),
                                         subtitle: Text(completedorderslist[index]["total_rent"].toString()),
                                          
                                      ),
                                    ),
                                    Card(
                                      color: Colors.grey[100],
                                      child: ListTile(
                                 title: Text("Final Amount(INR)"),
                                         subtitle: Text(completedorderslist[index]["final_amount"].toString()),
                                          
                                      ),
                                    ),
                                  
                                ]))));
                         },
                         child: Card(
                            elevation: 4.0,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                              child: ListTile(
                                 title: Text("Order Id : "+completedorderslist[index]['order_id'].toString()),
                                 subtitle: Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                      Text("Product : "+completedorderslist[index]['title'].toString()),
                                      SizedBox(height: 5),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Qty: "+completedorderslist[index]['quantity'].toString()),
                                          Text("Period: "+completedorderslist[index]['period'].toString()),
                                          Text("Rent type: "+completedorderslist[index]['rent_type_name'].toString()),
                                      ])
                                   ],
                                 ),
                                 trailing: completedorderslist[index]["offer_status"].toString() == "1" ? InkWell(
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
                                 ) : _getaction(completedorderslist[index]["offer_status"].toString()),
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

  Future<void> _completedorderslist() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
       completedorderslist.clear();
       _loading = true;
    });
    final body = {
      "id": prefs.getString('userid'),
    };
    var response = await http.post(Uri.parse(BASE_URL + completedorders),
        body: jsonEncode(body),
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json'
        }
    );
    if (response.statusCode == 200) {
      if(jsonDecode(response.body)['ErrorCode'].toString() == "0"){
        setState((){
            completedorderslist.addAll(jsonDecode(response.body)['Response']['Orders']);
            _loading = false;
        });
      }
      else {
        setState((){
          _loading = false;
        });
        showToast(jsonDecode(response.body)['ErrorMessage'].toString());
      }
    } else {
      setState((){
        _loading = false;
      });
      print(response.body);
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  Future<void> _completedorderslistByDate() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      completedorderslist.clear();
      _loading = true;
    });
    final body = {
      "id": prefs.getString('userid'),
      "from_date": startdate,
      "to_date": enddate
    };
    var response = await http.post(Uri.parse(BASE_URL + completedorders),
        body: jsonEncode(body),
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json'
        }
    );
    if (response.statusCode == 200) {
      if(jsonDecode(response.body)['ErrorCode'].toString() == "0"){
        setState((){
          completedorderslist.addAll(jsonDecode(response.body)['Response']['Orders']);
          _loading = false;
        });
      }
      else {
        setState((){
          _loading = false;
        });
        showToast(jsonDecode(response.body)['ErrorMessage'].toString());
      }
    } else {
      setState((){
        _loading = false;
      });
      print(response.body);
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  Future<void> _completedorderslistBySearch() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      completedorderslist.clear();
      _loading = true;
    });
    final body = {
      "id": prefs.getString('userid'),
      "search": searchvalue,
    };
    var response = await http.post(Uri.parse(BASE_URL + completedorders),
        body: jsonEncode(body),
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json'
        }
    );
    if (response.statusCode == 200) {
      if(jsonDecode(response.body)['ErrorCode'].toString() == "0"){
        setState((){
          completedorderslist.addAll(jsonDecode(response.body)['Response']['Orders']);
          _loading = false;
        });
      }
      else {
        setState((){
          _loading = false;
        });
        showToast(jsonDecode(response.body)['ErrorMessage'].toString());
      }
    } else {
      setState((){
        _loading = false;
      });
      print(response.body);
      throw Exception('Failed to get data due to ${response.body}');
    }
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
