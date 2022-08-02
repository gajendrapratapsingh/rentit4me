import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:rentit4me/network/api.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rentit4me/themes/constant.dart';
import 'package:rentit4me/views/boost_payment_screen.dart';
import 'package:rentit4me/views/offers_screen.dart';
import 'package:rentit4me/views/preview_product_screen.dart';
import 'package:rentit4me/views/product_edit_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InactivelsitingScreen extends StatefulWidget {
  const InactivelsitingScreen({Key key}) : super(key: key);

  @override
  State<InactivelsitingScreen> createState() => _InactivelsitingScreenState();
}

class _InactivelsitingScreenState extends State<InactivelsitingScreen> {

  String searchvalue = "Enter Title";
  List<dynamic> alllist = [];

  bool _loading = false;

  String initialvalue;
  List<String> allaction = ['Boost', 'Edit', 'Preview'];
  List<String> actionlist = ['Preview', 'Edit'];

  String startdate = "From Date";
  String enddate = "To Date";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _inactivealllist();
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
        title: const Text("Inactive Listings", style: TextStyle(color: kPrimaryColor)),
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
                                        Text(enddate, style: TextStyle(color: Colors.grey)),
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
                          if(searchvalue == "Enter Title" && startdate == "From Date"){
                            showToast('Please enter your search or select date');
                          }
                          else{
                            if(searchvalue == "Enter Title" || searchvalue.length == 0 || searchvalue.isEmpty){
                              _inactivealllistByDate();
                            }
                            else{
                              _inactivealllistBySearch();
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0))),
                            child: const Text("Filter", style: TextStyle(color: Colors.white)),
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
                      temp.add("INR ${element['price']} (${element['rent_type_name']})");
                    }
                  });
                  return InkWell(
                      onTap: () {},
                      child: Card(
                        elevation: 4.0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical : 8.0, horizontal: 12.0),
                          child: Column(children: [
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 55,
                                    width: 55,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.all(Radius.circular(28)),
                                      child: Image.network(sliderpath + alllist[index]['upload_base_path'].toString() + alllist[index]['file_name'].toString(),
                                          fit: BoxFit.fill),
                                    ),
                                  ),
                                  
                                  SizedBox(
                                     width: size.width * 0.65,
                                     child: Text(alllist[index]['title'].toString(),
                                      style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600)),
                                  )
                                ]),
                            const SizedBox(height: 10.0),
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
                                        const Text("Price", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                                        const SizedBox(height: 4.0),
                                        SizedBox(
                                          width: size.width * 0.40,
                                          child: Text(temp.join("/").toString(), style: const TextStyle(color: Colors.black, fontSize: 16)),
                                        )
                                      ]),
                                  Column(
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                    const Text("Negotiable", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 4.0),
                                    alllist[index]['negotiate'].toString() == "1"
                                        ? const Text("Yes", style: TextStyle(color: Colors.black))
                                        : const Text("No", style: TextStyle(color: Colors.black))
                                  ]),
                                  InkWell(
                                    onTap: (){
                                      if(alllist[index]['offers'].length > 0){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => OffersScreen(productid: alllist[index]['id'].toString())));
                                      }
                                      else{
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text("Sorry, no offer for this product"),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    },
                                    child:  Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          const Text("Offer", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                                          const SizedBox(height: 4.0),
                                          alllist[index]['offers'].length == 0
                                              ? Text(alllist[index]['offers'].length.toString(), style: TextStyle(color: Colors.black))
                                              : Text(alllist[index]['offers'].length.toString(), style: TextStyle(color: Colors.black))
                                        ]),
                                  ),
                                ]),
                            const SizedBox(height: 5.0),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                            borderRadius: const BorderRadius.all(Radius.circular(8.0))
                                          ),
                                           child: const Text("Boosted", style: TextStyle(color: Colors.white)),
                                         ) : InkWell(
                                           onTap: (){
                                             _postboost(alllist[index]['id'].toString());
                                           },
                                           child: Container(
                                              height: 25,
                                              width: 65,
                                              decoration: BoxDecoration(
                                              color: Colors.red[400],
                                              borderRadius: BorderRadius.all(Radius.circular(8.0))
                                            ),
                                              alignment: Alignment.center,
                                              child: const Text("Boost", style: TextStyle(color: Colors.white)),
                                           ),
                                         )
                                  ]),
                                  Column(children: [
                                      const Text("Created At", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                                      Text(alllist[index]['created_at'].toString().split("T")[0].toString())
                                  ]),
                                    alllist[index]['deletion'] == true ? Container(
                                    height: 35,
                                    width: 90,
                                    decoration: BoxDecoration(
                                        borderRadius : const BorderRadius.all(Radius.circular(8.0)),
                                        border: Border.all(color: Colors.grey, width: 1)
                                    ),
                                    child: DropdownButtonHideUnderline(child: Padding(
                                      padding: const EdgeInsets.only(left : 4.0),
                                      child: DropdownButton(
                                        hint: const Text("Action", style: TextStyle(color: Colors.black)),
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
                                          if(value == "Edit"){
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => ProductEditScreen(productid: alllist[index]['id'].toString())));
                                          }
                                          else if(value == "Delete"){
                                            showDeleteDialog(context, alllist[index]['id'].toString());
                                          }
                                          else{
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => PreviewProductScreen(productid: alllist[index]['id'].toString())));
                                          }
                                        },
                                      ),
                                    ),
                                    ),
                                  ) : Container(
                                    height: 35,
                                    width: 90,
                                    decoration: BoxDecoration(
                                        borderRadius : const BorderRadius.all(Radius.circular(8.0)),
                                        border: Border.all(color: Colors.grey, width: 1)
                                    ),
                                    child: DropdownButtonHideUnderline(child: Padding(
                                      padding: const EdgeInsets.only(left : 4.0),
                                      child: DropdownButton(
                                        hint: const Text("Action", style: TextStyle(color: Colors.black)),
                                        value: initialvalue,
                                        icon: const Icon(Icons.arrow_drop_down_rounded),
                                        items: actionlist.map((String items) {
                                          return DropdownMenuItem(
                                            value: items,
                                            child: Text(items),
                                          );
                                        }).toList(),
                                        isExpanded: true,
                                        onChanged: (value) {
                                          if(value == "Edit"){
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

  Future<void> _inactivealllist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      alllist.clear();
      _loading = true;
    });
    final body = {
      "id": prefs.getString('userid'),
    };
    var response = await http.post(Uri.parse(BASE_URL + "listings/inactive"),
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

  Future<void> _inactivealllistByDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _loading = true;
    });
    final body = {
      "id": prefs.getString('userid'),
      "from_date": startdate,
      "to_date": enddate
    };
    var response = await http.post(Uri.parse(BASE_URL + "listings/inactive"),
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

  Future<void> _inactivealllistBySearch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      alllist.clear();
      _loading = true;
    });
    final body = {
      "id": prefs.getString('userid'),
      "search": searchvalue,
    };
    var response = await http.post(Uri.parse(BASE_URL + "listings/inactive"),
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

  showDeleteDialog(BuildContext context, String id) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.white,
          title: const Text("Confirmation!!", style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500)),
          content: const Text("Are you sure to delete this product?", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w300)),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("No", style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w300))),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  deleteProduct(id);
                },
                child: const Text("Yes", style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w300)))
          ],
        ));
  }

  Future<void> deleteProduct(String id) async{
    print(id);
    setState((){
      _loading = true;
    });
    final body = {
      "post_id": id,
    };
    var response = await http.post(Uri.parse(BASE_URL + deleteproductUrl),
        body: jsonEncode(body),
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json'
        });
    print(response.body);
    if(response.statusCode == 200){
      if(jsonDecode(response.body)['ErrorCode'] == 0){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.green, content: Text(jsonDecode(response.body)['ErrorMessage'].toString(), style: TextStyle(color: Colors.white))));
        _inactivealllist();
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.red, content: Text(jsonDecode(response.body)['ErrorMessage'].toString(), style: TextStyle(color: Colors.white))));
        setState((){
          _loading = false;
        });
      }
    }
  }

}