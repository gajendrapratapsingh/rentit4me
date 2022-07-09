import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:html/parser.dart';
import 'package:path/path.dart' as p;
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rentit4me/themes/constant.dart';
import 'package:rentit4me/network/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductEditScreen extends StatefulWidget {
  String productid;
  ProductEditScreen({this.productid});

  @override
  State<ProductEditScreen> createState() => _ProductEditScreenState(productid);
}

class _ProductEditScreenState extends State<ProductEditScreen> {

  String productid;
  _ProductEditScreenState(this.productid);

  bool _checkData = false;
  bool _loading = false;

  bool _sms = false;
  bool _email = false;

  int mobilehiddenvalue = 1;
  int negotiableValue = 1;

  TextEditingController phoneController = TextEditingController();
  int phonemaxLength = 10;

  bool _checkstock = false;

  List<int> communicationprefs = [];

  String mainimage = "Main Image (Minimum Aspect Ration - 648px X 480px)*";
  String productname;
  String productimage;
  String boostpack;
  String description;
  String productprice;
  String mobile = "";
  String address;
  String email;

  String categoryhint = "Select Category";
  String subcategoryhint = "Select Subcategory";

  List additionalimage = [];
  List<dynamic> _categorieslist = [];
  List<dynamic> _subcategorieslist = [];


  String negotiablevalue = "Yes";
  String hidemobilevalue = "Yes";
  String statusvalue = "Active";
  int statusint = 1;
  List<String> Negotiablelist = ['Yes', 'No'];
  List<String> hidemobilelist = ['Yes', 'No'];
  List<String> statuslist = ["Active", "Inctive"];

  bool _checkhour = false;
  bool _checkday = false;
  bool _checkmonth = false;
  bool _checkyear = false;

  bool _termcondition = false;

  String hourlyprice;
  String daysprice;
  String monthprice;
  String yearprice;

  String initiacatlvalue;
  String initialsubcatvalue;
  String categoryid;
  String subcategoryid;
  String securityamount;

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

  @override
  void initState() {
    super.initState();
    _getpreproductedit(productid);
    _getCategories();
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
                        const Align(alignment: Alignment.topLeft, child: Text("General", style: TextStyle(color: kPrimaryColor, fontSize: 21, fontWeight: FontWeight.bold))),
                        SizedBox(height: 15),
                        const Align(alignment: Alignment.topLeft, child: Text("Main Image", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold))),
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
                                  child: mainimage == "Main Image (Minimum Aspect Ration - 648px X 480px)*" ? Text(mainimage, style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)) : Image.file(File(mainimage)),
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
                        SizedBox(height: 10),
                        Container(
                            height: 140,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                border:
                                Border.all(color: Colors.grey, width: 1.0),
                                borderRadius:
                                BorderRadius.all(Radius.circular(8.0))),
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
                                    hint: Text(categoryhint, style: const TextStyle(color: Colors.grey, fontSize: 14)),
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
                                    hint: Text(subcategoryhint,
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
                              decoration: InputDecoration(
                                hintText: productname == null ? "" : productname,
                                border: InputBorder.none,
                              ),
                              onChanged: (value) {
                                 productname = value;
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
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: description == null ? "" : description
                              ),
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
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: securityamount == null ? "" : securityamount
                              ),
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
                                       hintText: mobile == null ? "" : mobile,
                                       counterText: ""
                                   ),
                                   onChanged: (value) {
                                     if(value.length <= phonemaxLength){
                                        mobile = value;
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
                               decoration: BoxDecoration(
                                   border:
                                   Border.all(color: Colors.grey, width: 1.0),
                                   borderRadius:
                                   BorderRadius.all(Radius.circular(8.0))),
                               child: Padding(
                                 padding: const EdgeInsets.only(left: 5.0),
                                 child: TextField(
                                   keyboardType: TextInputType.emailAddress,
                                   decoration: InputDecoration(
                                       border: InputBorder.none,
                                       hintText: email == null ? "" : email
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
                               decoration: BoxDecoration(
                                   border:
                                   Border.all(color: Colors.grey, width: 1.0),
                                   borderRadius:
                                   BorderRadius.all(Radius.circular(8.0))),
                               child: DropdownButtonHideUnderline(
                                   child: Padding(
                                     padding:
                                     const EdgeInsets.only(left: 5.0, right: 5.0),
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
                                 decoration: InputDecoration(
                                   hintText: hourlyprice == null ? "" : hourlyprice,
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
                                 decoration: InputDecoration(
                                   border: InputBorder.none,
                                   hintText: daysprice == null ? "" : daysprice
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
                                 decoration: InputDecoration(
                                   hintText: monthprice == null ? "" : monthprice,
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
                                 decoration: InputDecoration(
                                   hintText: yearprice == null ? "" : yearprice,
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
                           Row(
                             children: [
                                 Text("Out Of Stock", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold)),
                                 SizedBox(width: 10),
                                 Checkbox(value: _checkstock, onChanged: (value){})
                             ],
                           ),
                           SizedBox(height: 10),
                           const Align(
                             alignment: Alignment.topLeft,
                             child: Text(
                               "Status",
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
                               child: DropdownButtonHideUnderline(
                                   child: Padding(
                                     padding:
                                     const EdgeInsets.only(left: 5.0, right: 5.0),
                                     child: DropdownButton(
                                       value: statusvalue,
                                       icon: const Icon(Icons.arrow_drop_down_rounded),
                                       items: statuslist.map((String items) {
                                         return DropdownMenuItem(
                                           value: items,
                                           child: Text(items),
                                         );
                                       }).toList(),
                                       isExpanded: true,
                                       onChanged: (value) {
                                         setState(() {
                                           statusvalue = value;
                                           if(statusvalue == "Yes"){
                                             statusint = 1;
                                           }
                                           else{
                                             statusint = 0;
                                           }
                                         });
                                       },
                                     ),
                                   ))),
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
                SizedBox(height: 20),
                InkWell(
                  onTap: (){
                    submitpostaddData(additionalimage);
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

  Future _getpreproductedit(String productid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final body = {"id": productid};
    print(productid);
    var response = await http.post(Uri.parse(BASE_URL + editviewpost),
        body: jsonEncode(body),
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json'
        });
    print(response.body);
    if (response.statusCode == 200) {
      var data = json.decode(response.body)['Response'];
      setState(() {
        productname = data['posted_ad'][0]['title'].toString();
        final document = parse(data['posted_ad'][0]['description'].toString());
        description = parse(document.body.text).documentElement.text.toString();
        mobile = data['posted_ad'][0]['mobile'].toString();
        email = data['posted_ad'][0]['email'].toString();
        securityamount = data['posted_ad'][0]['security'].toString();

        categoryhint = data['posted_ad'][0]['categories'][0]['title'].toString();
        subcategoryhint = data['posted_ad'][0]['categories'][1]['title'].toString();

        categoryid = data['posted_ad'][0]['categories'][0]['id'].toString();
        subcategoryid = data['posted_ad'][0]['categories'][1]['id'].toString();

        //statusint = data['posted_ad'][0]['status'].toString() == "6" ? 1 : 0;
        //statusvalue = data['posted_ad'][0]['status'].toString() == "6" ? "Active" : "Inactive";

        negotiablevalue = data['posted_ad'][0]['negotiate'].toString() == "1" ? "Yes" : "No";
        hidemobilevalue = data['posted_ad'][0]['mobile_hidden'].toString() == "1" ? "Yes" : "No";

        _checkstock = data['posted_ad'][0]['out_of_stock'].toString() == "0" ? false : true;

        data['posted_ad'].forEach((element) {
             if(element['preferences'].toString() == "1"){
                communicationprefs.add(1);
                _email = true;
             }
             else if(element['preferences'].toString() == "2"){
               communicationprefs.add(2);
               _sms = true;
             }
             else{
               communicationprefs.add(1);
               communicationprefs.add(2);
               _sms = true;
               _email = true;
             }
        });


        data['Images'].forEach((element){
            //additionalimage.add('https://dev.techstreet.in/rentit4me/public/assets/frontend/images/listings/6259622011f4a.jpg');
            if(element['is_main'] == 1){
               mainimage = "https://dev.techstreet.in/rentit4me/public/${element['upload_base_path'].toString()}${element['file_name'].toString()}";
            }
            else{
              additionalimage.add("https://dev.techstreet.in/rentit4me/public/${element['upload_base_path'].toString()}${element['file_name'].toString()}");
            }

        });
        data['Pricing'].forEach((element) {
            if(element['rent_type_name'].toString() == "Hourly"){
               _checkhour = true;
               hourlyprice = element['price'].toString();
            }
            else if(element['rent_type_name'].toString() == "Yearly"){
               _checkyear = true;
               yearprice = element['price'].toString();
            }
            else if(element['rent_type_name'].toString() == "Monthly"){
               _checkmonth = true;
               monthprice = element['price'].toString();
            }
            else{
                _checkday = true;
                daysprice = element['price'].toString();
            }
        });


        _checkData = true;
      });
    } else {
      throw Exception('Failed to get data due to ${response.body}');
    }
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

  Future<Map> submitpostaddData(List files) async {
    print(productid);
    print(categoryid);
    print(subcategoryid);
    print(description);
    print(productname);
    print(mobile);
    print(email);
    print(negotiableValue.toString());
    print(statusint);
    print(securityamount);
    print(mobilehiddenvalue.toString());
    print(communicationprefs);

    print(files.length.toString());

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
          'POST', Uri.parse(BASE_URL + updatepost));


      requestMulti.fields["post_id"] = productid;
      requestMulti.fields["category[0]"] = categoryid;
      requestMulti.fields["category[1]"] = subcategoryid;
      requestMulti.fields["title"] = productname;
      requestMulti.fields["description"] = description;
      requestMulti.fields["security"] = securityamount;
      requestMulti.fields["negotiate"] = negotiableValue.toString();
      requestMulti.fields["mobile"] = mobile;
      requestMulti.fields["email"] = email;
      requestMulti.fields["mobile_hidden"] = mobilehiddenvalue.toString();
      requestMulti.fields["com_prefs"] = communicationprefs.toString();
      requestMulti.fields["status"] = statusint.toString();
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
      if(jsonDecode(respStr)['ErrorCode'] == 0) {
        showToast(jsonDecode(respStr)['ErrorMessage'].toString());
      }else{
        showToast(jsonDecode(respStr)['ErrorMessage'].toString());
      }
    }
  }
}
