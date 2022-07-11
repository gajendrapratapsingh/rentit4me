import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rentit4me/network/api.dart';
import 'package:rentit4me/themes/constant.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rentit4me/views/home_screen.dart';
import 'package:rentit4me/views/offer_made_product_detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OfferRecievedScreen extends StatefulWidget {
  const OfferRecievedScreen({Key key}) : super(key: key);

  @override
  State<OfferRecievedScreen> createState() => _OfferRecievedScreenState();
}

class _OfferRecievedScreenState extends State<OfferRecievedScreen> {

  String searchvalue = "Search for product";
  List<dynamic> offerrecievedlist = [];

  List<String> responselist = ['Accept', 'Reject'];
  String responsevalue;
  String response;

  bool _loading = false;

  String startdate = "From Date";
  String enddate = "To Date";


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _offerrecievedlist();
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
        title: Text("Offer Recieved", style: TextStyle(color: kPrimaryColor)),
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
                        if(searchvalue == "Search for product" || searchvalue.trim().length == 0 || searchvalue.trim().isEmpty){
                           _offerrecievedlistByDate();
                        }
                        else{
                          _offerrecievedlistBySearch();
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
                itemCount: offerrecievedlist.length,
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
                                       subtitle: Text(offerrecievedlist[index]['name'].toString()),
                                        
                                    ),
                                  ),
                                  Card(
                                    color: Colors.grey[100],
                                    child: ListTile(
                                       title: Text("Product Name"),
                                       subtitle: Text(offerrecievedlist[index]["title"].toString()),
                                        
                                    ),
                                  ),
                                  Card(
                                    color: Colors.grey[100],
                                    child: ListTile(
                                       title: Text("Product Quantity"),
                                       subtitle: Text(offerrecievedlist[index]["quantity"].toString()),
                                        
                                    ),
                                  ),
                                  Card(
                                    color: Colors.grey[100],
                                    child: ListTile(
                                       title: Text("Rent Type"),
                                       subtitle: Text(offerrecievedlist[index]["rent_type_name"].toString()),
                                        
                                    ),
                                  ),
                                  Card(
                                    color: Colors.grey[100],
                                    child: ListTile(
                                       title: Text("Period"),
                                       subtitle: Text(offerrecievedlist[index]["period"].toString()),
                                        
                                    ),
                                  ),
                                  Card(
                                    color: Colors.grey[100],
                                    child: ListTile(
                                       title: Text("Product Price(XCD)"),
                                       subtitle: Text(offerrecievedlist[index]["product_price"].toString()),
                                        
                                    ),
                                  ),
                                  Card(
                                    color: Colors.grey[100],
                                    child: ListTile(
                                       title: Text("Offer Amount(XCD)"),
                                       subtitle: Text(offerrecievedlist[index]["renter_amount"].toString()),
                                        
                                    ),
                                  ),
                                  Card(
                                    color: Colors.grey[100],
                                    child: ListTile(
                                       title: Text("Total Rent(XCD)"),
                                       subtitle: Text(offerrecievedlist[index]["total_rent"].toString()),
                                        
                                    ),
                                  ),
                                  Card(
                                    color: Colors.grey[100],
                                    child: ListTile(
                                       title: Text("Total Security(XCD)"),
                                       subtitle: Text(offerrecievedlist[index]["total_security"].toString()),
                                        
                                    ),
                                  ),
                                  Card(
                                    color: Colors.grey[100],
                                    child: ListTile(
                                       title: Text("Total Rent(XCD)"),
                                       subtitle: Text(offerrecievedlist[index]["total_rent"].toString()),
                                        
                                    ),
                                  ),
                                  Card(
                                    color: Colors.grey[100],
                                    child: ListTile(
                               title: Text("Final Amount(XCD)"),
                                       subtitle: Text(offerrecievedlist[index]["final_amount"].toString()),
                                        
                                    ),
                                  ),
                                
                              ]))));
                         
                         },
                         child: Card(
                         elevation: 4.0,
                         child: Padding(
                           padding: const EdgeInsets.only(top : 8.0, bottom: 8.0),
                           child: ListTile(
                           title: Text("Rentee : "+offerrecievedlist[index]['name'].toString()),
                           subtitle: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               InkWell(
                                 onTap: (){
                                   Navigator.push(context, MaterialPageRoute(builder: (context) => OfferMadeProductDetailScreen(postadid: offerrecievedlist[index]['post_ad_id'].toString(), offerid: offerrecievedlist[index]['offer_request_id'].toString())));
                                 },
                                 child: Text("Product Name : "+offerrecievedlist[index]['title'].toString()),
                               ),
                              SizedBox(height: 5),
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Qty: "+offerrecievedlist[index]['quantity'].toString()),
                                      Text("Period: "+offerrecievedlist[index]['period'].toString()),
                                      Text("Rent type: "+offerrecievedlist[index]['rent_type_name'].toString()),
                                  ]),
                                ],
                              )
                           ]),
                           trailing: offerrecievedlist[index]["offer_status"].toString() == "3" ? InkWell(onTap: (){
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
                                                        if(data.toString() == "Reject"){
                                                          responsevalue = "2";
                                                          response = data.toString();
                                                        }
                                                        else{
                                                          responsevalue = "1";
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
                                                SizedBox(height: 2),
                                                Divider(height: 1, color: Colors.grey, thickness: 1),
                                                SizedBox(height: 25),
                                                InkWell(onTap:() {
                                                    if(responsevalue == null || responsevalue == "" || responsevalue == "null"){
                                                       showToast("Please select your response");
                                                    }
                                                    else{
                                                      print(offerrecievedlist[index]['user_id'].toString());
                                                      print(offerrecievedlist[index]['post_ad_id'].toString());
                                                      print(responsevalue);
                                                      _offeraction(offerrecievedlist[index]['post_ad_id'].toString(), responsevalue, offerrecievedlist[index]['user_id'].toString());
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
                                                   ],)
                                                 ),
                                             ),

                                          );
                                       }
                                    )
                               );
                             
                          }, child: Container( padding: EdgeInsets.all(4.0),
                                     decoration: BoxDecoration(
                                     borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                     border: Border.all(color: Colors.grey)
                                  ),  child: Text("Respond", style: TextStyle(color: Colors.grey)))) : _getstatus(offerrecievedlist[index]["offer_status"].toString())
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

  Widget _getstatus(String statusvalue){
    if(statusvalue == "3"){
      return Text("Pending");
    }
    else if(statusvalue == "13"){
      return Text("Completed");
    }
    else if(statusvalue == "2"){
      return Text("Rejected");
    }
    else{
      return Text("Accepted");
    }
  }

  Future<void> _offerrecievedlist() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _loading = true;
    });
    final body = {
      "user_id": prefs.getString('userid'),
    };
    var response = await http.post(Uri.parse(BASE_URL + offerrecieve),
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
         if(jsonDecode(response.body)['Response'] == null){
           showToast(jsonDecode(response.body)['ErrorMessage'].toString());
         }
         else{
           setState((){
             offerrecievedlist.addAll(jsonDecode(response.body)['Response']['data']);
           });
         }
      }
      else {
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

  Future<void> _offerrecievedlistByDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      offerrecievedlist.clear();
      _loading = true;
    });
    final body = {
      "user_id": prefs.getString('userid'),
      "from_date": startdate,
      "to_date": enddate
    };
    var response = await http.post(Uri.parse(BASE_URL + offerrecieve),
        body: jsonEncode(body),
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json'
        });
    print(response.body);
    if(response.statusCode == 200) {
      if(jsonDecode(response.body)['Response']['data'].length == 0){
        setState((){
          _loading = false;
        });
        showToast("Data not found");
      }
      else{
        setState((){
          _loading = false;
          offerrecievedlist.addAll(jsonDecode(response.body)['Response']['data']);
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

  Future<void> _offerrecievedlistBySearch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      offerrecievedlist.clear();
      _loading = true;
    });
    final body = {
      "user_id": prefs.getString('userid'),
      "search": searchvalue,
    };
    var response = await http.post(Uri.parse(BASE_URL + offerrecieve),
        body: jsonEncode(body),
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json'
        });
    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['ErrorCode'].toString() == "0") {
        setState(() {
          offerrecievedlist.addAll(jsonDecode(response.body)['Response']['data']);
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

  Future<void> _offeraction(String postid, String offerstatus, String userid) async{
     print(jsonEncode({
       "post_ad_id" : postid,
       "user_id" : userid,
       "offer_status" : offerstatus
     }));
     final body = {
       "post_ad_id" : postid,
       "user_id" : userid,
       "offer_status" : offerstatus
     };
     var response = await http.post(Uri.parse(BASE_URL + offeraction),
         body: jsonEncode(body),
         headers: {
           "Accept": "application/json",
           'Content-Type': 'application/json'
         }
     );
     print(response.body);
     if(response.statusCode == 200) {
       if(jsonDecode(response.body)['ErrorCode'].toString() == "0"){
         showToast(jsonDecode(response.body)['Response'].toString());
         Navigator.of(context, rootNavigator: true).pop('dialog');
         Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => HomeScreen()));
         //_offerrecievedlist();
       }
       else {
         showToast(jsonDecode(response.body)['ErrorMessage'].toString());
       }
     } else {
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
