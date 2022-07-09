import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:path/path.dart' as p;
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rentit4me/network/api.dart';
import 'package:rentit4me/themes/constant.dart';
import 'package:rentit4me/views/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddlistingScreen extends StatefulWidget {
  const AddlistingScreen({Key key}) : super(key: key);

  @override
  State<AddlistingScreen> createState() => _AddlistingScreenState();
}

class _AddlistingScreenState extends State<AddlistingScreen> {
  bool _loading = false;

  String mainimage = "Main Image (Minimum Aspect Ration - 648px X 480px)*";

  TextEditingController phoneController = TextEditingController();
  String phoneNumber = "";
  int phonemaxLength = 10;

  List<dynamic> _categorieslist = [];
  List<dynamic> _subcategorieslist = [];

  String initiacatlvalue;
  String initialsubcatvalue;

  String categoryid;
  String subcategoryid;

  bool _termcondition = false;
  bool _sms = false;
  bool _email = false;
  
  String category;
  String subcategory;
  String title;
  String description;
  String securityamount;
  String mobile;
  String email;
  String hourlyprice;
  String daysprice;
  String monthlyprice;
  String yearlyprice;
  String quantity;
  String availabledate = "MM/dd/yyyy";

  String negotiablevalue = "Yes";
  String hidemobilevalue = "Yes";
  List<String> Negotiablelist = ['Yes', 'No'];
  List<String> hidemobilelist = ['Yes', 'No'];

  bool _checkhour = true;
  bool _checkday = true;
  bool _checkmonth = true;
  bool _checkyear = true;

  List<int> communicationprefs = [];

  int mobilehiddenvalue = 1;
  int negotiableValue = 1;


  List additionalimage = [];

  List renttype = [
    {
      "type" : "1",
      "amount" : "",
      "enable" : true,
    },
    {
      "type" : "2",
      "amount" : "",
      "enable" : true,
    },
    {
      "type" : "3",
      "amount" : "",
      "enable" : true,
    },
    {
      "type" : "4",
      "amount" : "",
      "enable" : true,
    },
  ];

  List prices = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCategories();
    _getprofileData();
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
        title: Text("Listings ADS", style: TextStyle(color: kPrimaryColor)),
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
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text("General",
                                style: TextStyle(
                                    color: kPrimaryColor,
                                    fontSize: 21,
                                    fontWeight: FontWeight.bold))),
                        SizedBox(height: 15),
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text("Main Image",
                                style: TextStyle(
                                    color: kPrimaryColor,
                                    fontWeight: FontWeight.bold))),
                        SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                          child: Row(children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                    height: 45,
                                    width: 45,
                                    alignment: Alignment.topLeft,
                                    child:  mainimage == "Main Image (Minimum Aspect Ration - 648px X 480px)*" ? Text(mainimage, style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)) : Image.file(File(mainimage)),
                                  ),
                                  
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                showmainimageCaptureOptions(1);
                              },
                              child: Container(
                                width: 120,
                                height: 50,
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                    color: Colors.deepOrangeAccent,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0))),
                                child: const Text("Choose File",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400)),
                              ),
                            )
                          ]),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Additional Image",
                              style: TextStyle(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            ElevatedButton(
                               style: ElevatedButton.styleFrom(
                                   primary: kPrimaryColor,
                                ),
                                onPressed: () {
                                  if(additionalimage.length > 3){
                                     showToast("Already added maximumn number of additional image");
                                  }
                                  else{
                                    showmainimageCaptureOptions(2);
                                  }
                                  
                                },
                                child: Text("ADD"))
                          ],
                        ),
                        Text("Please add upto 4 images", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500)),
                        SizedBox(height: 10),
                        Container(
                          height: 140,
                          width: double.infinity,
                          decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1.0), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                          child: GridView.count(
                           padding: EdgeInsets.zero, 
                           crossAxisCount: 3,
                           physics: ClampingScrollPhysics(),
                           children: additionalimage
                               .map((e) => InkWell(
                                 onTap: (){
                                    setState(() {
                                       additionalimage.removeAt(additionalimage.indexOf(e));
                                    });
                                 },
                                 child: Padding(
                                   padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
                                   child: Stack(
                                      alignment: Alignment.topRight,
                                      children: [
                                        Image.file(File(e), fit: BoxFit.fill),
                                        Icon(Icons.cancel, color: Colors.red)
                                      ],
                                      
                                   ),
                                 ),
                               ))
                               .toList())
                        ),
                        SizedBox(height: 10),
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Category",
                            style: TextStyle(
                                color: kPrimaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                border:
                                    Border.all(color: Colors.grey, width: 1)),
                            child: DropdownButtonHideUnderline(
                                child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 5.0, right: 5.0),
                              child: DropdownButton(
                                hint: const Text("Select Category",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 14)),
                                value: initiacatlvalue,
                                icon: const Icon(Icons.arrow_drop_down_rounded),
                                items: _categorieslist.map((items) {
                                  return DropdownMenuItem(
                                    value: items['id'].toString(),
                                    child: Text(items['title']),
                                  );
                                }).toList(),
                                onChanged: (data) {
                                  setState(() {
                                    _subcategorieslist.clear();
                                    initialsubcatvalue = null;
                                    initiacatlvalue = data.toString();
                                    categoryid = data.toString();
                                    _getSubCategories(data);
                                  });
                                },
                              ),
                            ))),
                        SizedBox(height: 10),
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Subcategory",
                            style: TextStyle(
                                color: kPrimaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                border:
                                    Border.all(color: Colors.grey, width: 1)),
                            child: DropdownButtonHideUnderline(
                                child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 5.0, right: 5.0),
                              child: DropdownButton(
                                hint: const Text("Select Subcategory",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 14)),
                                value: initialsubcatvalue,
                                icon: const Icon(Icons.arrow_drop_down_rounded),
                                items: _subcategorieslist.map((items) {
                                  return DropdownMenuItem(
                                    value: items['id'].toString(),
                                    child: Text(items['title']),
                                  );
                                }).toList(),
                                onChanged: (data) {
                                  setState(() {
                                    initialsubcatvalue = data.toString();
                                    subcategoryid = data.toString();
                                    //_getSubCategories(data);
                                  });
                                },
                              ),
                            ))),
                        SizedBox(height: 10),
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Title",
                            style: TextStyle(
                                color: kPrimaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0))),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: TextField(
                              decoration: const InputDecoration(
                                //labelText: 'Enter Name',
                                border: InputBorder.none,
                              ),
                              onChanged: (value) {
                                  title = value;
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Discription",
                            style: TextStyle(
                                color: kPrimaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0))),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: TextField(
                              textAlign: TextAlign.start,
                              decoration:
                                  InputDecoration(border: InputBorder.none),
                              onChanged: (value) {
                                  description = value;
                              },
                              maxLines: 4,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Refundable Security Deposit (XCD)",
                            style: TextStyle(
                                color: kPrimaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0))),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: TextField(
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.start,
                              decoration:
                                  InputDecoration(border: InputBorder.none),
                              onChanged: (value) {
                                 securityamount = value.toString();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Card(
                  elevation: 4.0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text("Additional",
                                style: TextStyle(
                                    color: kPrimaryColor,
                                    fontSize: 21,
                                    fontWeight: FontWeight.bold))),
                        SizedBox(height: 15),
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text("Negotiable",
                                style: TextStyle(
                                    color: kPrimaryColor,
                                    fontWeight: FontWeight.bold))),
                        SizedBox(height: 10),
                        Container(
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.grey, width: 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ),
                            child: DropdownButtonHideUnderline(
                                child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 5.0, right: 5.0),
                              child: DropdownButton(
                                value: negotiablevalue,
                                icon: const Icon(Icons.arrow_drop_down_rounded),
                                items: Negotiablelist.map((String items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text(items),
                                  );
                                }).toList(),
                                isExpanded: true,
                                onChanged: (value) {
                                  setState(() {
                                      negotiablevalue = value;
                                      if(negotiablevalue == "Yes"){
                                       negotiableValue = 1;
                                    }
                                    else{
                                       negotiableValue = 0;
                                    }
                                  });
                                },
                              ),
                           
                            ))),
                        SizedBox(height: 10),
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Mobile*",
                            style: TextStyle(
                                color: kPrimaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey, width: 1.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0))),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: TextField(
                                keyboardType: TextInputType.phone,
                                maxLength: 10,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: phoneNumber == null || phoneNumber == "" ? "Mobile" : phoneNumber,
                                  counterText: ""
                                ),
                                onChanged: (value) {
                                  if(value.length <= phonemaxLength){
                                    phoneNumber = value;
                                  }
                                  else{
                                    showToast("Please enter valid mobile number");
                                  }
                                },
                              ),
                            )),
                        SizedBox(height: 10),
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Email*",
                            style: TextStyle(
                                color: kPrimaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                            width: double.infinity,
                            decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1.0), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: TextField(
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  hintText: email == null || email == "" ? "Email" : email,
                                  border: InputBorder.none,
                                ),
                                onChanged: (value) {
                                   email = value;
                                },
                              ),
                            )),
                        SizedBox(height: 10),
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Hide Mobile Number",
                            style: TextStyle(
                                color: kPrimaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                            width: double.infinity,
                            decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1.0), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                            child: DropdownButtonHideUnderline(child: Padding(
                              padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                              child: DropdownButton(
                                value: hidemobilevalue,
                                icon: const Icon(Icons.arrow_drop_down_rounded),
                                items: hidemobilelist.map((String items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text(items),
                                  );
                                }).toList(),
                                isExpanded: true,
                                onChanged: (value) {
                                  setState(() {
                                    hidemobilevalue = value;
                                    if(hidemobilevalue == "Yes"){
                                       mobilehiddenvalue = 1;
                                    }
                                    else{
                                       mobilehiddenvalue = 0;
                                    }
                                  });
                                },
                              ),
                            ))),
                        SizedBox(height: 10),
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Rent Type",
                            style: TextStyle(
                                color: kPrimaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(children: [
                                  Checkbox(
                                      value: _checkhour,
                                      onChanged: (value) {
                                        setState(() {
                                          _checkhour = value;
                                          renttype[0]['enable'] = _checkhour;
                                        });
                                      }),
                                  const Text("Hourly", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold))
                                ]),
                                Row(children: [
                                  Checkbox(
                                      value: _checkday,
                                      onChanged: (value) {
                                        setState(() {
                                          _checkday = value;
                                          renttype[1]['enable'] = _checkday;
                                        });
                                      }),
                                  const Text("Days", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold))
                                ]),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(children: [
                                  Checkbox(
                                      value: _checkmonth,
                                      onChanged: (value) {
                                        setState(() {
                                          _checkmonth = value;
                                           renttype[2]['enable'] = _checkmonth;
                                        });
                                      }),
                                  const Text("Monthly",
                                      style: TextStyle(
                                          color: kPrimaryColor,
                                          fontWeight: FontWeight.bold))
                                ]),
                                Row(children: [
                                  Checkbox(
                                      value: _checkyear,
                                      onChanged: (value) {
                                        setState(() {
                                          _checkyear = value;
                                          renttype[3]['enable'] = _checkyear;
                                        });

                                      }),
                                  const Text("Yearly",
                                      style: TextStyle(
                                          color: kPrimaryColor,
                                          fontWeight: FontWeight.bold))
                                ]),
                              ],
                            )
                          ],
                        ),
                        _checkhour == true ? SizedBox(height: 10) : SizedBox(),
                        _checkhour == true
                            ? const Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Hourly Price(XCD)*",
                                  style: TextStyle(
                                      color: kPrimaryColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            : SizedBox(),
                        _checkhour == true ? SizedBox(height: 10) : SizedBox(),
                        _checkhour == true
                            ? Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey, width: 1),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0))),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    onChanged: (value) {
                                        if(value.toString().trim().length != 0){
                                          setState((){
                                            renttype[0]['amount'] = value.toString();
                                            renttype[0]['enable'] = true;
                                          });
                                        }
                                    },
                                    maxLines: 1,
                                  ),
                                ),
                              )
                            : SizedBox(),
                        _checkday == true ? SizedBox(height: 10) : SizedBox(),
                        _checkday == true
                            ? const Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Days Price(XCD)*",
                                  style: TextStyle(
                                      color: kPrimaryColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            : SizedBox(),
                        _checkday == true ? SizedBox(height: 10) : SizedBox(),
                        _checkday == true
                            ? Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey, width: 1),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0))),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      //labelText: 'Enter your email address',
                                      border: InputBorder.none,
                                    ),
                                    onChanged:(value) {
                                      if(value.toString().trim().length != 0){
                                        setState((){
                                          renttype[1]['amount'] = value.toString();
                                          renttype[1]['enable'] = true;
                                        });
                                      }
                                    },
                                    maxLines: 1,
                                  ),
                                ),
                              )
                            : SizedBox(),
                        _checkmonth == true ? SizedBox(height: 10) : SizedBox(),
                        _checkmonth == true
                            ? const Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Monthly Price(XCD)*",
                                  style: TextStyle(
                                      color: kPrimaryColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            : SizedBox(),
                        _checkmonth == true ? SizedBox(height: 10) : SizedBox(),
                        _checkmonth == true
                            ? Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey, width: 1),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0))),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      //labelText: 'Enter your email address',
                                      border: InputBorder.none,
                                    ),
                                    onChanged:(value) {
                                      if(value.toString().trim().length != 0){
                                        setState((){
                                          renttype[2]['amount'] = value.toString();
                                          renttype[2]['enable'] = true;
                                        });
                                      }
                                    },
                                    maxLines: 1,
                                  ),
                                ),
                              )
                            : SizedBox(),
                        _checkyear == true ? SizedBox(height: 10) : SizedBox(),
                        _checkyear == true
                            ? const Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Yearly Price(XCD)*",
                                  style: TextStyle(
                                      color: kPrimaryColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            : SizedBox(),
                        _checkyear == true ? SizedBox(height: 10) : SizedBox(),
                        _checkyear == true
                            ? Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey, width: 1),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0))),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      //labelText: 'Enter your email address',
                                      border: InputBorder.none,
                                    ),
                                    onChanged:(value){
                                      if(value.toString().trim().length != 0){
                                        setState((){
                                          renttype[3]['amount'] = value.toString();
                                          renttype[3]['enable'] = true;
                                        });
                                      }
                                    },
                                    maxLines: 1,
                                  ),
                                ),
                              )
                            : SizedBox(),
                        SizedBox(height: 10),
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Quantity*",
                            style: TextStyle(
                                color: kPrimaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0))),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: TextField(
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                //labelText: 'Enter your email address',
                                border: InputBorder.none,
                              ),
                              onChanged:(value){
                                 quantity = value.toString();
                              },
                              maxLines: 1,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Communication Preferences*",
                            style: TextStyle(
                                color: kPrimaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: size.width * 0.60,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Checkbox(
                                    value: _email,
                                    onChanged: (value) {
                                      if(value) {
                                        setState(() {
                                          _email = value;
                                          communicationprefs.add(1);
                                        });
                                      }
                                      else{
                                        setState(() {
                                          _email = value;
                                          communicationprefs.removeWhere((element) => element.toString() == "1");
                                        });
                                      }

                                    }),
                                const Text("Email",
                                    style: TextStyle(
                                        color: kPrimaryColor,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(width: 8.0),
                                Checkbox(
                                    value: _sms, 
                                    onChanged:(value) {
                                        if(value){
                                          setState(() {
                                            _sms = value;
                                            communicationprefs.add(2);
                                          });
                                        }
                                        else{
                                          setState(() {
                                            _sms = value;
                                            communicationprefs.removeWhere((element) => element.toString() == "2");
                                          });
                                        }
                                    }),
                                const Text("Sms", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold)),
                              ]),
                        ),
                        SizedBox(height: 10),
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Available From*",
                            style: TextStyle(
                                color: kPrimaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.grey, width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0))),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: Text(availabledate,
                                      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
                                ),
                                IconButton(
                                    onPressed: () {
                                      _selectStartDate(context);
                                    },
                                    icon: const Icon(Icons.calendar_today, color: Colors.black))
                              ]),
                        ),
                        SizedBox(height: 10),
                        Align(
                            alignment: Alignment.topLeft,
                            child: Row(
                              children: [
                                const Text("Term and Condition*", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold)),
                                SizedBox(width: 4.0),
                                Checkbox(
                                    value: _termcondition,
                                    onChanged: (value) {
                                      setState(() {
                                         _termcondition = value;
                                      });
                                    })
                              ],
                            )),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 5),
                InkWell(
                  onTap: (){
                    if(mainimage == "Main Image (Minimum Aspect Ration - 648px X 480px)*"){
                      showToast("Please choose main image");
                      return;
                    }
                    else if(additionalimage.length == 0){
                       showToast("Please choose additional image");
                       return;
                    }
                    else if(categoryid == null || categoryid == ""){
                      showToast("Please select category");
                      return;
                    }
                    else if(title == null || title == ""){
                      showToast("Please enter your title");
                      return;
                    }
                    else if(description == null || description == ""){
                      showToast("Please enter your description");
                      return;
                    }
                    else if(securityamount == null || securityamount == ""){
                      showToast("Please enter security amount");
                      return;
                    }
                    else if(phoneNumber == null || phoneNumber == ""){
                      showToast("Please enter mobile number");
                      return;
                    }
                    else if(email == null || email == ""){
                      showToast("Please enter email address");
                      return;
                    }
                    else if(quantity == null || quantity == ""){
                      showToast("Please enter quantity");
                      return;
                    }
                    else if(communicationprefs.length == 0 || communicationprefs.isEmpty){
                      showToast("Please select almost one communication preferences");
                      return;
                    }
                    else if(availabledate == null || availabledate == "" || availabledate == "MM/dd/yyyy"){
                      showToast("Please select available date");
                      return;
                    }
                    else if(_termcondition == false){
                      showToast("Please check term & condition");
                      return;
                    }
                    else{
                      submitpostaddData(additionalimage);
                    }

                  },
                  child: Card(
                    elevation: 8.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Container(
                      height: 45,
                      width: size.width * 0.90,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                          color: Colors.deepOrangeAccent,
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      child: const Text("Post", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _getCategories() async {
    setState(() {
      _loading = true;
    });
    var response = await http.get(Uri.parse(BASE_URL + categoryUrl), headers: {
      "Accept": "application/json",
      'Content-Type': 'application/json'
    });
    setState(() {
      _loading = false;
    });
    if (jsonDecode(response.body)['ErrorCode'] == 0) {
      setState(() {
        _categorieslist.addAll(jsonDecode(response.body)['Response']);
      });
    } else {
      showToast(jsonDecode(response.body)['ErrorMessage'].toString());
    }
  }

  Future<void> _getSubCategories(String id) async {
    setState(() {
      _loading = true;
    });
    var response = await http.post(Uri.parse(BASE_URL + subcategoryUrl),
        body: jsonEncode({"category_id": id}),
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json'
        });
    setState(() {
      _loading = false;
    });
    if (jsonDecode(response.body)['ErrorCode'] == 0) {
      if (jsonDecode(response.body)['Response']['subcategories'].length > 0) {
        setState(() {
          _subcategorieslist.addAll(jsonDecode(response.body)['Response']['subcategories']);
        });
      } else {
        showToast("No Subcategory available");
      }
    }
  }

  Future<Map> submitpostaddData(List files) async {
    print(categoryid);
    print(subcategoryid);
    print(description);
    print(title);
    print(phoneNumber);
    print(email);
    print(negotiableValue.toString());
    print(quantity);
    print(securityamount);
    print(availabledate);
    print(mobilehiddenvalue.toString());
    print(communicationprefs);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List temp = [];
    renttype.forEach((element) {
      if(element['enable']){
        temp.add(element);
      }
    });
    if(temp.length == 0){
      showToast("Please select atleast one rent type");
    }
    else {
      setState(() {
        _loading = true;
      });
      var requestMulti = http.MultipartRequest(
          'POST', Uri.parse(BASE_URL + postadstore));


      requestMulti.fields["id"] = prefs.getString('userid');
      requestMulti.fields["category"] = categoryid;
      requestMulti.fields["sub_category"] = subcategoryid == null ? "" : subcategoryid;
      requestMulti.fields["title"] = title;
      requestMulti.fields["description"] = description;
      requestMulti.fields["negotiate"] = negotiableValue.toString();
      requestMulti.fields["mobile"] = phoneNumber;
      requestMulti.fields["email"] = email;
      requestMulti.fields["mobile_hidden"] = mobilehiddenvalue.toString();
      requestMulti.fields["quantity"] = quantity;
      requestMulti.fields["start_date"] = availabledate;
      requestMulti.fields["com_prefs"] = communicationprefs.join(",");
      requestMulti.fields["security"] = securityamount;
      requestMulti.fields["price[1]"] = renttype[0]['amount'].toString();
      requestMulti.fields["rent_type[1]"] = renttype[0]['type'].toString();
      requestMulti.fields["price[2]"] = renttype[1]['amount'].toString();
      requestMulti.fields["rent_type[2]"] = renttype[1]['type'].toString();
      requestMulti.fields["price[3]"] = renttype[2]['amount'].toString();
      requestMulti.fields["rent_type[3]"] = renttype[2]['type'].toString();
      requestMulti.fields["price[4]"] = renttype[3]['amount'].toString();
      requestMulti.fields["rent_type[4]"] = renttype[3]['type'].toString();


      requestMulti.files.add(http.MultipartFile(
          "main_image", File(mainimage).openRead(),
          File(mainimage).lengthSync(),
          filename: "image" + p.extension(mainimage.toString())));

      List<http.MultipartFile> newList = [];

      if (files.length > 0) {
        for (var i = 0; i < files.length; i++) {
          File imageFile = File(files[i].toString());
          var stream = http.ByteStream(imageFile.openRead());
          var length = await imageFile.length();
          var multipartFile = http.MultipartFile("images[]", stream, length,
              filename: "image" + p.extension(files[i].toString()));
          newList.add(multipartFile);
        }
      } else {
        requestMulti.fields['images[]'] = "";
      }

      requestMulti.files.addAll(newList);

      var response = await requestMulti.send();
      var respStr = await response.stream.bytesToString();
      setState(() {
        _loading = false;
      });
      print("add list response");
      print(respStr.toString());
      if(jsonDecode(respStr)['ErrorCode'] == 0) {
         showToast(jsonDecode(respStr)['ErrorMessage'].toString());
         Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
      }else{
        showToast(jsonDecode(respStr)['ErrorMessage'].toString());
      } 
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
        availabledate = DateFormat('MM/dd/yyyy').format(picked);
      });
  }

  
  Future<void> showmainimageCaptureOptions(int datafor) async {
    final ImagePicker _picker = ImagePicker();
    await showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
        backgroundColor: Colors.white,
        context: context,
        isScrollControlled: true,
        builder: (context) => Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(12, 0, 7, 0),
                    child: Text(
                      'Select',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                          onPressed: () async {
                            final XFile result = await _picker.pickImage(
                              source: ImageSource.camera,
                              imageQuality: 80,
                              maxHeight: 480,
                              maxWidth: 640,
                            );
                            if (result != null) {
                              switch (datafor) {
                                case 1:
                                  setState(() {
                                    mainimage = result.path.toString();
                                  });
                                  break;

                                case 2:
                                  setState(() {
                                    additionalimage.add(result.path.toString());
                                  });
                                  break;
                              }
                            }
                            Navigator.of(context).pop();
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.white),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.grey)))),
                          icon: const Icon(Icons.camera, color: Colors.black),
                          label: const Text("Camera",
                              style: TextStyle(color: Colors.black))),
                      const SizedBox(width: 30),
                      ElevatedButton.icon(
                          onPressed: () async {
                            final XFile result = await _picker.pickImage(
                              source: ImageSource.gallery,
                              imageQuality: 80,
                              maxHeight: 480,
                              maxWidth: 640,
                            );
                            if (result != null) {
                              switch (datafor) {
                                case 1:
                                  setState(() {
                                    mainimage = result.path.toString();
                                  });
                                  break;

                                case 2:
                                  setState(() {
                                    additionalimage.add(result.path.toString());
                                  });
                                  break;
                              }
                            }
                            Navigator.of(context).pop();
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.white),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.grey)))),
                          icon: const Icon(Icons.photo, color: Colors.black),
                          label: const Text("Gallery",
                              style: TextStyle(color: Colors.black))),
                    ],
                  )
                ])));
  }

  Future _getprofileData() async{
    setState((){
      _loading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final body = {
      "id": prefs.getString('userid'),
    };
    var response = await http.post(Uri.parse(BASE_URL + profileUrl),
        body: jsonEncode(body),
        headers: {
          "Accept" : "application/json",
          'Content-Type' : 'application/json'
        }
    );
    setState((){
      _loading = false;
    });
    if(response.statusCode == 200) {
      var data = json.decode(response.body)['Response'];
      setState(() {
        phoneNumber = data['User']['mobile'].toString();
        email = data['User']['email'].toString();
      });

    } else {
      setState((){
        _loading = false;
      });
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

}
