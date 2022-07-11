import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:rentit4me/network/api.dart';
import 'package:rentit4me/themes/constant.dart';
import 'package:rentit4me/views/boost_payment_screen.dart';
import 'package:rentit4me/views/preview_product_screen.dart';
import 'package:rentit4me/views/product_edit_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PromotedlistScreen extends StatefulWidget {
  const PromotedlistScreen({Key key}) : super(key: key);

  @override
  State<PromotedlistScreen> createState() => _PromotedlistScreenState();
}

class _PromotedlistScreenState extends State<PromotedlistScreen> {

  String searchvalue = "Enter Title";
  List<dynamic> alllist = [];

  bool _loading = false;

  String initialvalue;
  List<String> allaction = ['Boost', 'Edit', 'Preview'];

  String startdate = "From Date";
  String enddate = "To Date";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _promotedalllist();
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
        title: Text("Promoted Listings", style: TextStyle(color: kPrimaryColor)),
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
                           if(searchvalue == "Enter Title" || searchvalue.trim().length == 0 || searchvalue.isEmpty){
                               _promotedalllistByDate();
                           }
                           else{
                               _promotedalllistBySearch();
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
                itemCount: alllist.length,
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
                itemBuilder: (BuildContext context, int index) {
                  List temp=[];
                  List a=alllist[index]['prices'];
                  a.forEach((element) {
                    if(element['price'] != null){
                      temp.add("XCD "+element['price'].toString()+" ("+element['rent_type_name'].toString()+")");
                    }
                  });
                  return InkWell(
                      onTap: () {},
                      child: Card(
                        elevation: 4.0,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical : 8.0, horizontal: 12.0),
                          child: Column(children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 55,
                                    width: 55,
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(28)),
                                      child: Image.network(
                                          "https://dev.techstreet.in/rentit4me/public/" +
                                              alllist[index]['upload_base_path']
                                                  .toString() +
                                              alllist[index]['file_name']
                                                  .toString(),
                                          fit: BoxFit.fill),
                                    ),
                                  ),
                                  
                                  SizedBox(
                                     width: size.width * 0.65,
                                     child: Text(alllist[index]['title'].toString(),
                                      style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600)),
                                  )
                                ]),
                            SizedBox(height: 10.0),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text("Price", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                                        SizedBox(height: 4.0),
                                        SizedBox(
                                          width: size.width * 0.40,
                                          child: Text(temp.join("/").toString(), style: TextStyle(color: Colors.black, fontSize: 16)),
                                        )
                                      ]),
                                  Column(
                                     crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                    children: [
                                    const Text("Negotiable", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 4.0),
                                    alllist[index]['negotiate'].toString() == "1"
                                        ? const Text("Yes", style: TextStyle(color: Colors.black))
                                        : const Text("No", style: TextStyle(color: Colors.black))
                                  ]),
                                  Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Text("Offer", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 4.0),
                                      alllist[index]['offers'].length == 0  ? const Text("Not yet", style: TextStyle(color: Colors.black))
                                        : Text(alllist[index]['offers'].length.toString(), style: TextStyle(color: Colors.black))
                                  ]),
                                ]),
                            const SizedBox(height: 5.0),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(children: [
                                       const Text("Boost Status", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                                       const SizedBox(height: 4.0),
                                       alllist[index]['boost_package_status'].toString() == "1" ? Container(
                                           height: 25,
                                           width: 65,
                                           alignment: Alignment.center,
                                           decoration: BoxDecoration(
                                            color: Colors.green[400],
                                            borderRadius: BorderRadius.all(Radius.circular(8.0))
                                          ),
                                           child: const Text("Boosted", style: TextStyle(color: Colors.white)),
                                         ) : Container(
                                            height: 25,
                                            width: 65,
                                            decoration: BoxDecoration(
                                            color: Colors.red[400],
                                            borderRadius: BorderRadius.all(Radius.circular(8.0))
                                          ),
                                            alignment: Alignment.center,
                                            child: const Text("Not yet", style: TextStyle(color: Colors.white)),
                                         )
                                  ]),
                                  Column(children: [
                                      const Text("Created At", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                                      Text(alllist[index]['created_at'].toString().split("T")[0].toString())
                                  ]),
                                  Container(
                                    height: 35,
                                    width: 90,
                                    decoration: BoxDecoration(
                                        borderRadius : BorderRadius.all(Radius.circular(8.0)),
                                        border: Border.all(color: Colors.grey, width: 1)
                                    ),
                                    child: DropdownButtonHideUnderline(child: Padding(
                                      padding: const EdgeInsets.only(left : 4.0),
                                      child: DropdownButton(
                                        hint: Text("Action", style: TextStyle(color: Colors.black)),
                                        value: initialvalue,
                                        icon: const Icon(Icons.arrow_drop_down_rounded),
                                        items: allaction.map((String items) {
                                          return DropdownMenuItem(
                                            value: items,
                                            child: Text(items),
                                          );
                                        }).toList(),
                                        isExpanded: true,
                                        onChanged: (value) {
                                          if(value == "Boost"){
                                            _postboost(alllist[index]['id'].toString());
                                          }
                                          else if(value == "Edit"){
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => ProductEditScreen(productid: alllist[index]['id'].toString())));
                                          }
                                          else{
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => PreviewProductScreen(productid: alllist[index]['id'].toString())));
                                          }
                                        },
                                      ),
                                    ),
                                    ),
                                  )
                                ]),
                          ]),
                        ),
                      ));
                },
              ))
            ],
          ),
        ),
      ),
    );
 
  }

  Future<void> _promotedalllist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _loading = true;
    });
    final body = {
      "id": prefs.getString('userid'),
    };
    var response = await http.post(Uri.parse(BASE_URL + "listings/promoted"),
        body: jsonEncode(body),
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json'
        });
    if(response.statusCode == 200) {
      if(jsonDecode(response.body)['Response']['Listings'].length == 0){
        setState((){
          _loading = false;
        });
        showToast("Data not found");
      }
      else{
        setState((){
          _loading = false;
          alllist.addAll(jsonDecode(response.body)['Response']['Listings']);
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

  Future<void> _promotedalllistByDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      alllist.clear();
      _loading = true;
    });
    final body = {
      "id": prefs.getString('userid'),
      "from_date": startdate,
      "to_date": enddate
    };
    var response = await http.post(Uri.parse(BASE_URL + "listings/promoted"),
        body: jsonEncode(body),
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json'
        });
    if(response.statusCode == 200) {
      if(jsonDecode(response.body)['Response']['Listings'].length == 0){
        setState((){
          _loading = false;
        });
        showToast("Data not found");
      }
      else{
        setState((){
          _loading = false;
          alllist.addAll(jsonDecode(response.body)['Response']['Listings']);
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

  Future<void> _promotedalllistBySearch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      alllist.clear();
      _loading = true;
    });
    final body = {
      "id": prefs.getString('userid'),
      "search": searchvalue,
    };
    var response = await http.post(Uri.parse(BASE_URL + "listings/promoted"),
        body: jsonEncode(body),
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json'
        });
    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['ErrorCode'].toString() == "0") {
        setState(() {
          alllist.addAll(jsonDecode(response.body)['Response']['Listings']);
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

  Future<void> _postboost(String id) async {
    print("calling");
    print(id);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _loading = true;
    });
    var response = await http.get(Uri.parse(BASE_URL+postboost),
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
        //showToast(jsonDecode(response.body)['ErrorMessage'].toString());
        Navigator.push(context, MaterialPageRoute(builder: (context) => BoostPaymentScreen(postid: id)));
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