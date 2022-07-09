// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:quickblox_sdk/auth/module.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';
import 'package:rentit4me/helper/loader.dart';
import 'package:rentit4me/network/api.dart';
import 'package:rentit4me/themes/constant.dart';
import 'package:rentit4me/views/conversation.dart';
import 'package:rentit4me/views/home_screen.dart';
import 'package:rentit4me/views/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetailScreen extends StatefulWidget {
  String productid;
  ProductDetailScreen({this.productid});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState(productid);
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String productid;

  _ProductDetailScreenState(this.productid);

  String productname;
  String productprice;
  String description;
  String securitydeposit;
  String addedby;
  String boostpack;
  String renttype;
  String renttypeid;
  String useramount;

  String query_id;
  String address;
  String price;
  String email;

  bool _checkData = false;
  bool _checkuser = false;

  String renttypename;
  String renteramount;
  String productamount;
  String securityamount;

  String negotiable;
  double totalrent = 0;
  double totalsecurity = 0;
  double finalamount = 0;
  String days;

  List<dynamic> rentpricelist = [];
  List<String> renttypelist = [];

  List<dynamic> likedadproductlist = [];

  String productQty;
  String startDate = "From Date";
  String actionbtn;

  String capitalize(str) {
    return "${str[0].toUpperCase()}${str.substring(1).toLowerCase()}";
  }

  String productimage;

  String userid;
  String usertype;
  String trustedbadge;
  String trustedbadgeapproval;

  String appId = "96417";
  String authKey = "BmYxKrbn3HDthbc";
  String authSecret = "XRfs7bw3Y9H4yMc";
  String accountKey = "hr2cuVsMyCZXsZMEE32H";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeDateFormatting();

    init();

    _getproductDetail(productid);
    _getcheckapproveData();
    _getmakeoffer(productid);

  }

  void init() async {
    try {
      print("init calling");
      await QB.settings.init(appId, authKey, authSecret, accountKey);
      mylogin();
    } on PlatformException catch (e) {
      print(e);
    }
  }

  void mylogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString('quicklogin'));
    print(prefs.getString('quickpassword'));
    try {
      QBLoginResult result = await QB.auth.login(prefs.getString('quicklogin'), prefs.getString('quickpassword'));
      //_connectnow();
    } on PlatformException catch (e) {
      // Some error occurred, look at the exception message for more details
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
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
        title: Text("Detail", style: TextStyle(color: kPrimaryColor)),
        centerTitle: true,
      ),
      body: _checkData == false
          ? Center(
        child: CircularProgressIndicator(),
      )
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Container(
                height: 120,
                width: double.infinity,
                child: CachedNetworkImage(
                  imageUrl: sliderpath + productimage,
                  fit: BoxFit.fill,
                ),
              ),
              Container(
                height: 80,
                padding: EdgeInsets.only(left: 0, top: 5, right: 0),
                width: size.width,
                child: ListView.separated(
                    shrinkWrap: true,
                    separatorBuilder: (BuildContext context,
                        int index) => const SizedBox(width: 10),
                    itemCount: 3,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Container(
                        height: 55,
                        width: size.width * 0.30,
                        child: CachedNetworkImage(
                          imageUrl: sliderpath + productimage,
                          fit: BoxFit.fill,
                        ),
                      );
                    }),
              ),
              SizedBox(height: 5.0),
              Align(
                  alignment: Alignment.topLeft,
                  child: productname == "null" ||
                      productname == null ||
                      productname == ""
                      ? SizedBox()
                      : Text(productname,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold))),
              SizedBox(height: 4.0),
              Align(
                  alignment: Alignment.topLeft,
                  child: boostpack == "null" ||
                      boostpack == "" ||
                      boostpack == null
                      ? SizedBox()
                      : Container(
                      height: 25,
                      width: 100,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4.0)
                      ),
                      child: Text("Sponsored",
                          style: TextStyle(color: Colors.black, fontSize: 16))
                  )
              ),
              SizedBox(height: 15.0),
              Align(
                  alignment: Alignment.topLeft,
                  child: description == "" ||
                      description == "null" ||
                      description == null
                      ? SizedBox()
                      : Text(description,
                      style: TextStyle(
                          color: Colors.black, fontSize: 12))),
              SizedBox(height: 35.0),
              Align(
                  alignment: Alignment.topLeft,
                  child: renttype == null ||
                      renttype == "" ||
                      renttype == "null"
                      ? Text("$productprice",
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500))
                      : Text("$productprice",
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500))),
              SizedBox(height: 15.0),
              Align(
                  alignment: Alignment.topLeft,
                  child: Text("Security Deposit : INR $securitydeposit",
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500))),
              SizedBox(height: 15.0),
              Align(
                  alignment: Alignment.topLeft,
                  child: Text("Added By : $addedby",
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500))),
              SizedBox(height: 35.0),
              userid == null || userid == "" ? Container(
                height: 60,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => LoginScreen()));
                      },
                      child: Container(
                        height: 45,
                        width: size.width * 0.45,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.all(
                                Radius.circular(22.0))),
                        child: Text("LOGIN TO START DISCUSSION",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700)),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => LoginScreen()));
                      },
                      child: Container(
                        height: 45,
                        width: size.width * 0.45,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                            color: Colors.deepOrangeAccent,
                            borderRadius: BorderRadius.all(
                                Radius.circular(22.0))),
                        child: Text("RENT NOW",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ],
                ),
              ) :
              _checkuser == false
                  ? Container(
                height: 60,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => Conversation(query_id: query_id)));
                      },
                      child: Container(
                        height: 45,
                        width: size.width * 0.45,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.all(
                                Radius.circular(22.0))),
                        child: Text("START DISCUSSION",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700)),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        print("0");
                        if (trustedbadge == "1") {
                          print("trusted badge 1");
                          if (trustedbadgeapproval == "Pending" ||
                              trustedbadgeapproval == "pending") {
                            print("2");
                            showToast("Your verification is under process.");
                          } else {
                            print("3");
                            setState(() {
                              productQty = getOfferData['quantity'].toString();
                              totalrent = double.parse(
                                  getOfferData['total_rent'].toString());
                              useramount =
                                  getOfferData['renter_amount'].toString();
                              days = getOfferData['period'].toString();
                              totalsecurity = double.parse(
                                  getOfferData['total_security'].toString());
                              finalamount = double.parse(
                                  getOfferData['final_amount'].toString());
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) =>
                                      StatefulBuilder(
                                          builder: (context, setState) {
                                            return AlertDialog(
                                                title: const Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Text(
                                                      "Make An Offer",
                                                      style: TextStyle(
                                                          color: Colors
                                                              .deepOrangeAccent)),
                                                ),
                                                content: Container(
                                                  child: SingleChildScrollView(
                                                    child: Column(
                                                        children: [
                                                          DropdownButtonHideUnderline(
                                                            child: DropdownButton<
                                                                String>(
                                                              hint: Text(
                                                                  "Select",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize: 18)),
                                                              value:
                                                              capitalize(
                                                                  getOfferData['rent_type_name']
                                                                      .toString()),
                                                              elevation:
                                                              16,
                                                              isExpanded:
                                                              true,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .grey
                                                                      .shade700,
                                                                  fontSize: 16),
                                                              onChanged:
                                                                  (
                                                                  String data) {
                                                                setState(() {
                                                                  rentpricelist
                                                                      .forEach((
                                                                      element) {
                                                                    setState(() {
                                                                      if (element['rent_type_name']
                                                                          .toString() ==
                                                                          data
                                                                              .toString()) {
                                                                        renttypename =
                                                                            data
                                                                                .toString();
                                                                        productamount =
                                                                            element['price']
                                                                                .toString();
                                                                        useramount =
                                                                            element['price']
                                                                                .toString();
                                                                        renttypeid =
                                                                            element['rent_type_id']
                                                                                .toString();
                                                                        renteramount =
                                                                        "Listed Price: ${element['price']
                                                                            .toString() +
                                                                            "/" +
                                                                            element['rent_type_name']
                                                                                .toString()}";
                                                                      }
                                                                    });
                                                                  });
                                                                });
                                                                print(
                                                                    renttypename);
                                                              },
                                                              items:
                                                              renttypelist.map<
                                                                  DropdownMenuItem<
                                                                      String>>((
                                                                  String value) {
                                                                return DropdownMenuItem<
                                                                    String>(
                                                                  value: value,
                                                                  child: Text(
                                                                      value),
                                                                );
                                                              }).toList(),
                                                            ),
                                                          ),
                                                          SizedBox(height: 2),
                                                          Divider(
                                                              height:
                                                              1,
                                                              color: Colors
                                                                  .grey,
                                                              thickness:
                                                              1),
                                                          SizedBox(
                                                              height:
                                                              20),
                                                          Align(
                                                              alignment: Alignment
                                                                  .topLeft,
                                                              child: renteramount ==
                                                                  "null" ||
                                                                  renteramount ==
                                                                      null ||
                                                                  renteramount ==
                                                                      ""
                                                                  ? Text(
                                                                  "Listed Price: 09",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize: 16))
                                                                  : Text(
                                                                  renteramount,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize: 16))),
                                                          SizedBox(height: 2),
                                                          Divider(height: 1,
                                                              color: Colors
                                                                  .grey,
                                                              thickness: 1),
                                                          SizedBox(height: 20),
                                                          Align(
                                                              alignment: Alignment
                                                                  .topLeft,
                                                              child: securitydeposit ==
                                                                  "" ||
                                                                  securitydeposit ==
                                                                      "null" ||
                                                                  securitydeposit ==
                                                                      null
                                                                  ? Text(
                                                                  "Security Deposit : 0",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize: 16))
                                                                  : Text(
                                                                  "Security Deposit: $securitydeposit",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize: 16))),
                                                          SizedBox(
                                                              height:
                                                              2),
                                                          Divider(
                                                              height:
                                                              1,
                                                              color: Colors
                                                                  .grey,
                                                              thickness:
                                                              1),
                                                          SizedBox(
                                                              height:
                                                              10),
                                                          TextFormField(
                                                            initialValue:
                                                            productQty,
                                                            keyboardType:
                                                            TextInputType
                                                                .number,
                                                            decoration:
                                                            const InputDecoration(
                                                              hintText:
                                                              'Enter Product Quantity',
                                                              border:
                                                              null,
                                                            ),
                                                            onChanged:
                                                                (value) {
                                                              setState(
                                                                      () {
                                                                    if (negotiable ==
                                                                        "0") {
                                                                      productQty =
                                                                          value
                                                                              .toString();
                                                                      days ==
                                                                          "null" ||
                                                                          days ==
                                                                              "" ||
                                                                          days ==
                                                                              null
                                                                          ?
                                                                      totalrent =
                                                                      0
                                                                          : totalrent =
                                                                          double
                                                                              .parse(
                                                                              productQty) *
                                                                              double
                                                                                  .parse(
                                                                                  days) *
                                                                              double
                                                                                  .parse(
                                                                                  productamount);
                                                                      totalsecurity =
                                                                          double
                                                                              .parse(
                                                                              productQty) *
                                                                              double
                                                                                  .parse(
                                                                                  securitydeposit);
                                                                      days ==
                                                                          "null" ||
                                                                          days ==
                                                                              "" ||
                                                                          days ==
                                                                              null
                                                                          ?
                                                                      finalamount =
                                                                          totalsecurity +
                                                                              totalrent
                                                                          : finalamount =
                                                                          totalrent +
                                                                              totalsecurity;
                                                                    } else {
                                                                      setState(() {
                                                                        useramount =
                                                                        useramount ==
                                                                            null
                                                                            ? null
                                                                            : useramount;
                                                                        days =
                                                                        days ==
                                                                            null
                                                                            ? null
                                                                            : days;
                                                                      });

                                                                      double qtyg = double
                                                                          .parse(
                                                                          value
                                                                              .toString());
                                                                      double useramountg = useramount ==
                                                                          null
                                                                          ? 1
                                                                          : double
                                                                          .parse(
                                                                          useramount
                                                                              .toString());
                                                                      double daysg = days ==
                                                                          null
                                                                          ? 1
                                                                          : double
                                                                          .parse(
                                                                          days
                                                                              .toString());

                                                                      double totalrentg = qtyg *
                                                                          useramountg *
                                                                          daysg;
                                                                      setState(() {
                                                                        totalrent =
                                                                        0;
                                                                        productQty =
                                                                            qtyg
                                                                                .toString();
                                                                        totalrent =
                                                                            totalrentg;
                                                                        totalsecurity =
                                                                            int
                                                                                .parse(
                                                                                securitydeposit) *
                                                                                qtyg;
                                                                        finalamount =
                                                                            totalsecurity +
                                                                                totalrent;
                                                                      });
                                                                    }
                                                                  });
                                                            },
                                                          ),
                                                          negotiable == "1"
                                                              ? TextFormField(
                                                            initialValue: useramount,
                                                            keyboardType: TextInputType
                                                                .number,
                                                            decoration: InputDecoration(
                                                              hintText: _getrenttypeamounthint(
                                                                  getOfferData['rent_type_name']
                                                                      .toString()),
                                                              border: null,
                                                            ),
                                                            onChanged: (value) {
                                                              setState(() {
                                                                productQty =
                                                                productQty ==
                                                                    null
                                                                    ? null
                                                                    : productQty;
                                                                days =
                                                                days == null
                                                                    ? null
                                                                    : days;
                                                              });
                                                              double qtyg = double
                                                                  .parse(
                                                                  productQty
                                                                      .toString());
                                                              double useramountg = double
                                                                  .parse(value
                                                                  .toString());
                                                              double daysg = days ==
                                                                  null
                                                                  ? 1
                                                                  : double
                                                                  .parse(days
                                                                  .toString());
                                                              double totalrentg = qtyg *
                                                                  useramountg *
                                                                  daysg;
                                                              setState(() {
                                                                totalrent = 0;
                                                                totalrent =
                                                                    totalrentg;
                                                                useramount =
                                                                    useramountg
                                                                        .toString();
                                                                totalsecurity =
                                                                    double
                                                                        .parse(
                                                                        securitydeposit) *
                                                                        qtyg;
                                                                finalamount =
                                                                    totalsecurity +
                                                                        totalrent;
                                                              });
                                                            },
                                                          )
                                                              : SizedBox(),
                                                          TextFormField(
                                                            initialValue:
                                                            days,
                                                            keyboardType:
                                                            TextInputType
                                                                .number,
                                                            decoration:
                                                            InputDecoration(
                                                              hintText:
                                                              _getrenttypehint(
                                                                  capitalize(
                                                                      getOfferData['rent_type_name']
                                                                          .toString())),
                                                              border:
                                                              null,
                                                            ),
                                                            onChanged:
                                                                (value) {
                                                              if (negotiable ==
                                                                  "0") {
                                                                setState(() {
                                                                  productQty =
                                                                  productQty ==
                                                                      null
                                                                      ? null
                                                                      : productQty;
                                                                  days = value
                                                                      .toString();
                                                                  days == null
                                                                      ?
                                                                  totalrent = 0
                                                                      : totalrent =
                                                                      double
                                                                          .parse(
                                                                          productQty) *
                                                                          double
                                                                              .parse(
                                                                              days) *
                                                                          double
                                                                              .parse(
                                                                              productamount);
                                                                  totalsecurity =
                                                                      double
                                                                          .parse(
                                                                          productQty) *
                                                                          double
                                                                              .parse(
                                                                              securitydeposit);
                                                                  days ==
                                                                      "null" ||
                                                                      days ==
                                                                          "" ||
                                                                      days ==
                                                                          null
                                                                      ?
                                                                  finalamount =
                                                                      totalsecurity +
                                                                          totalrent
                                                                      : finalamount =
                                                                      totalrent +
                                                                          totalsecurity;
                                                                });
                                                              } else {
                                                                setState(() {
                                                                  productQty =
                                                                  productQty ==
                                                                      null
                                                                      ? null
                                                                      : productQty;
                                                                  useramount =
                                                                  useramount ==
                                                                      null
                                                                      ? null
                                                                      : useramount;
                                                                });

                                                                double
                                                                qtyg =
                                                                double.parse(
                                                                    productQty
                                                                        .toString());
                                                                double useramountg = useramount ==
                                                                    null
                                                                    ? 1
                                                                    : double
                                                                    .parse(
                                                                    useramount
                                                                        .toString());
                                                                double
                                                                daysg =
                                                                double.parse(
                                                                    value
                                                                        .toString());
                                                                double totalrentg = qtyg *
                                                                    useramountg *
                                                                    daysg;
                                                                setState(() {
                                                                  totalrent = 0;
                                                                  days = daysg
                                                                      .toString();
                                                                  totalrent =
                                                                      totalrentg;
                                                                  totalsecurity =
                                                                      double
                                                                          .parse(
                                                                          securitydeposit) *
                                                                          qtyg;
                                                                  finalamount =
                                                                      totalsecurity +
                                                                          totalrent;
                                                                });
                                                              }
                                                            },
                                                          ),
                                                          SizedBox(
                                                              height:
                                                              20),
                                                          Align(
                                                              alignment: Alignment
                                                                  .topLeft,
                                                              child: totalrent ==
                                                                  "" ||
                                                                  totalrent ==
                                                                      "null" ||
                                                                  totalrent ==
                                                                      null
                                                                  ? Text(
                                                                  "Total Rent : 0",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize: 16))
                                                                  : Text(
                                                                  "Total Rent: " +
                                                                      totalrent
                                                                          .toString(),
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize: 16))),
                                                          SizedBox(
                                                              height:
                                                              2),
                                                          Divider(
                                                              height:
                                                              1,
                                                              color: Colors
                                                                  .grey,
                                                              thickness:
                                                              1),
                                                          SizedBox(
                                                              height:
                                                              20),
                                                          Align(
                                                              alignment: Alignment
                                                                  .topLeft,
                                                              child: totalsecurity ==
                                                                  "" ||
                                                                  totalsecurity ==
                                                                      "null" ||
                                                                  totalsecurity ==
                                                                      null
                                                                  ? Text(
                                                                  "Total Security : 0",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize: 16))
                                                                  : Text("Total Security: " + totalsecurity.toString(),
                                                                  style: TextStyle(color: Colors.black, fontSize: 16))),
                                                          SizedBox(height: 2),
                                                          Divider(height: 1, color: Colors.grey, thickness: 1),
                                                          SizedBox(height: 20),
                                                          Align(
                                                              alignment: Alignment.topLeft,
                                                              child: finalamount == "" || finalamount == "null" || finalamount == null
                                                                  ? Text("Final Amount : 0", style: TextStyle(color: Colors.black, fontSize: 16))
                                                                  : Text("Final Amount: " + finalamount.toString(), style: TextStyle(color: Colors.black, fontSize: 16))),
                                                          SizedBox(height: 2),
                                                          Divider(height: 1, color: Colors.grey, thickness: 1),
                                                          SizedBox(height: 10),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text(startDate, style: TextStyle(color: Colors.black, fontSize: 16)),
                                                              IconButton(
                                                                  onPressed: () {
                                                                    print("You are here1");
                                                                    if (renttypename == "Hourly" || renttypename == "hourly") {
                                                                       _datetimepickerwithhour();
                                                                    }
                                                                    else {
                                                                      _selectStartDate(
                                                                          context,
                                                                          setState);
                                                                    }
                                                                  },
                                                                  icon: Icon(
                                                                      Icons
                                                                          .calendar_today,
                                                                      size: 16))
                                                            ],
                                                          ),
                                                          Divider(
                                                              height:
                                                              1,
                                                              color: Colors
                                                                  .grey,
                                                              thickness:
                                                              1),
                                                          SizedBox(
                                                              height:
                                                              25),
                                                          InkWell(
                                                            onTap:
                                                                () {
                                                              Navigator.of(
                                                                  context,
                                                                  rootNavigator: true)
                                                                  .pop();
                                                              if (renttypename ==
                                                                  null ||
                                                                  renttypename ==
                                                                      "") {
                                                                showToast(
                                                                    "Please select rent type");
                                                              }
                                                              else if (days ==
                                                                  null ||
                                                                  days == "") {
                                                                showToast(
                                                                    "Please enter period");
                                                              }
                                                              else
                                                              if (productQty ==
                                                                  null ||
                                                                  productQty ==
                                                                      "") {
                                                                showToast(
                                                                    "Please enter product quantity");
                                                              }
                                                              else
                                                              if (startDate ==
                                                                  null ||
                                                                  startDate ==
                                                                      "" ||
                                                                  startDate ==
                                                                      "From Date") {
                                                                showToast(
                                                                    "Please enter start date");
                                                              }
                                                              else {
                                                                Navigator.of(
                                                                    context,
                                                                    rootNavigator: true)
                                                                    .pop();
                                                                _setmakeoffer();
                                                              }
                                                            },
                                                            child:
                                                            Container(
                                                              height:
                                                              45,
                                                              width:
                                                              double.infinity,
                                                              alignment:
                                                              Alignment.center,
                                                              decoration: const BoxDecoration(
                                                                  color: Colors
                                                                      .deepOrangeAccent,
                                                                  borderRadius: BorderRadius
                                                                      .all(
                                                                      Radius
                                                                          .circular(
                                                                          8.0))),
                                                              child: Text(
                                                                  "Make Offer",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white)),
                                                            ),
                                                          )
                                                        ]),
                                                  ),
                                                ));
                                          }));
                            });
                          }
                        } else {
                          print("4");
                          if (actionbtn == "Make An Offer") {
                            print("5");
                            setState(() {
                              productQty = null;
                              totalrent = 0;
                              useramount = null;
                              days = null;
                              totalsecurity = 0;
                              finalamount = 0;
                            });
                            print(renttypelist);
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) =>
                                    StatefulBuilder(
                                        builder: (context, setState) {
                                          return AlertDialog(title: const Align(
                                              alignment: Alignment.topLeft,
                                              child: Text("Make An Offer",
                                                  style: TextStyle(color: Colors
                                                      .deepOrangeAccent))),
                                              content: Container(
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                      children: [
                                                        DropdownButtonHideUnderline(
                                                          child: DropdownButton<
                                                              String>(
                                                            hint: Text("Select",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize: 18)),
                                                            value: renttypename,
                                                            elevation: 16,
                                                            isExpanded: true,
                                                            style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
                                                            onChanged: (String data) {
                                                              setState(() {
                                                                rentpricelist.forEach((element) {
                                                                  if (element['rent_type_name'].toString() == data.toString()) {
                                                                    renttypename = data.toString();
                                                                    productamount = element['price'].toString();
                                                                    useramount = element['price'].toString();
                                                                    renttypeid = element['rent_type_id'].toString();
                                                                    renteramount =
                                                                    "Listed Price: ${element['price'].toString() + "/" + element['rent_type_name'].toString()}";
                                                                  }
                                                                });
                                                              });
                                                            },
                                                            items: renttypelist.map<DropdownMenuItem<String>>((String value) {
                                                              return DropdownMenuItem<String>(
                                                                value: value,
                                                                child: Text(value),
                                                              );
                                                            }).toList(),
                                                          ),
                                                        ),
                                                        SizedBox(height: 2),
                                                        Divider(height: 1,
                                                            color: Colors.grey,
                                                            thickness: 1),
                                                        SizedBox(height: 20),
                                                        Align(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: renteramount ==
                                                                "null" ||
                                                                renteramount ==
                                                                    null ||
                                                                renteramount ==
                                                                    ""
                                                                ? Text(
                                                                "Listed Price: 0",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize: 16))
                                                                : Text(
                                                                renteramount,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize: 16))),
                                                        SizedBox(height: 2),
                                                        Divider(height: 1,
                                                            color: Colors.grey,
                                                            thickness: 1),
                                                        SizedBox(height: 20),
                                                        Align(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: securitydeposit ==
                                                                "" ||
                                                                securitydeposit ==
                                                                    "null" ||
                                                                securitydeposit ==
                                                                    null
                                                                ? Text(
                                                                "Security Deposit : 0",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize: 16))
                                                                : Text(
                                                                "Security Deposit: $securitydeposit",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize: 16))),
                                                        SizedBox(height: 2),
                                                        Divider(height: 1,
                                                            color: Colors.grey,
                                                            thickness: 1),
                                                        SizedBox(height: 10),
                                                        TextField(
                                                          keyboardType: TextInputType
                                                              .number,
                                                          decoration: const InputDecoration(
                                                            hintText: 'Enter Product Quantity',
                                                            border: null,
                                                          ),
                                                          onChanged:
                                                              (value) {
                                                            setState(
                                                                    () {
                                                                  if (negotiable ==
                                                                      "0") {
                                                                    productQty =
                                                                        value
                                                                            .toString();
                                                                    days ==
                                                                        "null" ||
                                                                        days ==
                                                                            "" ||
                                                                        days ==
                                                                            null
                                                                        ?
                                                                    totalrent =
                                                                    0
                                                                        : totalrent =
                                                                        double
                                                                            .parse(
                                                                            productQty) *
                                                                            double
                                                                                .parse(
                                                                                days) *
                                                                            double
                                                                                .parse(
                                                                                productamount);
                                                                    totalsecurity =
                                                                        double
                                                                            .parse(
                                                                            productQty) *
                                                                            double
                                                                                .parse(
                                                                                securitydeposit);
                                                                    days ==
                                                                        "null" ||
                                                                        days ==
                                                                            "" ||
                                                                        days ==
                                                                            null
                                                                        ?
                                                                    finalamount =
                                                                        totalsecurity +
                                                                            totalrent
                                                                        : finalamount =
                                                                        totalrent +
                                                                            totalsecurity;
                                                                  } else {
                                                                    setState(() {
                                                                      useramount =
                                                                      useramount ==
                                                                          null
                                                                          ? null
                                                                          : useramount;
                                                                      days =
                                                                      days ==
                                                                          null
                                                                          ? null
                                                                          : days;
                                                                    });
                                                                    double qtyg = double
                                                                        .parse(
                                                                        value
                                                                            .toString());
                                                                    double useramountg = useramount ==
                                                                        null
                                                                        ? 1
                                                                        : double
                                                                        .parse(
                                                                        useramount
                                                                            .toString());
                                                                    double daysg = days ==
                                                                        null
                                                                        ? 1
                                                                        : double
                                                                        .parse(
                                                                        days
                                                                            .toString());
                                                                    double totalrentg = qtyg *
                                                                        useramountg *
                                                                        daysg;
                                                                    setState(() {
                                                                      totalrent =
                                                                      0;
                                                                      productQty =
                                                                          qtyg
                                                                              .toString();
                                                                      totalrent =
                                                                          totalrentg;
                                                                      totalsecurity =
                                                                          double
                                                                              .parse(
                                                                              securitydeposit) *
                                                                              qtyg;
                                                                      finalamount =
                                                                          totalsecurity +
                                                                              totalrent;
                                                                    });
                                                                  }
                                                                });
                                                          },
                                                        ),
                                                        negotiable ==
                                                            "1"
                                                            ? TextField(
                                                          keyboardType:
                                                          TextInputType.number,
                                                          decoration: InputDecoration(
                                                            hintText: _getrenttypeamounthint(
                                                                renttypename),
                                                            border: null,
                                                          ),
                                                          onChanged:
                                                              (value) {
                                                            setState(() {
                                                              productQty =
                                                              productQty == null
                                                                  ? null
                                                                  : productQty;
                                                              days =
                                                              days == null
                                                                  ? null
                                                                  : days;
                                                            });
                                                            double qtyg = double
                                                                .parse(
                                                                productQty
                                                                    .toString());
                                                            double useramountg = double
                                                                .parse(value
                                                                .toString());
                                                            double daysg = days ==
                                                                null
                                                                ? 1
                                                                : double.parse(
                                                                days
                                                                    .toString());
                                                            double totalrentg = qtyg *
                                                                useramountg *
                                                                daysg;
                                                            setState(() {
                                                              totalrent = 0;
                                                              totalrent =
                                                                  totalrentg;
                                                              useramount =
                                                                  useramountg
                                                                      .toString();
                                                              totalsecurity =
                                                                  double.parse(
                                                                      securitydeposit) *
                                                                      qtyg;
                                                              finalamount =
                                                                  totalsecurity +
                                                                      totalrent;
                                                            });
                                                          },
                                                        )
                                                            : SizedBox(),
                                                        TextField(
                                                          keyboardType: TextInputType
                                                              .number,
                                                          decoration: InputDecoration(
                                                            hintText: _getrenttypehint(
                                                                renttypename),
                                                            border: null,
                                                          ),
                                                          onChanged: (value) {
                                                            if (negotiable ==
                                                                "0") {
                                                              setState(() {
                                                                productQty =
                                                                productQty ==
                                                                    null
                                                                    ? null
                                                                    : productQty;
                                                                days = value
                                                                    .toString();
                                                                days == null
                                                                    ?
                                                                totalrent = 0
                                                                    : totalrent =
                                                                    double
                                                                        .parse(
                                                                        productQty) *
                                                                        double
                                                                            .parse(
                                                                            days) *
                                                                        double
                                                                            .parse(
                                                                            productamount);
                                                                totalsecurity =
                                                                    double
                                                                        .parse(
                                                                        productQty) *
                                                                        double
                                                                            .parse(
                                                                            securitydeposit);
                                                                days ==
                                                                    "null" ||
                                                                    days ==
                                                                        "" ||
                                                                    days == null
                                                                    ?
                                                                finalamount =
                                                                    totalsecurity +
                                                                        totalrent
                                                                    : finalamount =
                                                                    totalrent +
                                                                        totalsecurity;
                                                              });
                                                            } else {
                                                              setState(() {
                                                                productQty =
                                                                productQty ==
                                                                    null
                                                                    ? null
                                                                    : productQty;
                                                                useramount =
                                                                useramount ==
                                                                    null
                                                                    ? null
                                                                    : useramount;
                                                              });
                                                              double qtyg = double
                                                                  .parse(
                                                                  productQty
                                                                      .toString());
                                                              double useramountg = useramount ==
                                                                  null
                                                                  ? 1
                                                                  : double
                                                                  .parse(
                                                                  useramount
                                                                      .toString());
                                                              double daysg = double
                                                                  .parse(value
                                                                  .toString());
                                                              double totalrentg = qtyg *
                                                                  useramountg *
                                                                  daysg;
                                                              setState(() {
                                                                totalrent = 0;
                                                                days = daysg
                                                                    .toString();
                                                                totalrent =
                                                                    totalrentg;
                                                                totalsecurity =
                                                                    double
                                                                        .parse(
                                                                        securitydeposit) *
                                                                        qtyg;
                                                                finalamount =
                                                                    totalsecurity +
                                                                        totalrent;
                                                              });
                                                            }
                                                          },
                                                        ),
                                                        SizedBox(height: 20),
                                                        Align(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: totalrent ==
                                                                "" ||
                                                                totalrent ==
                                                                    "null" ||
                                                                totalrent ==
                                                                    null
                                                                ? Text(
                                                                "Total Rent : 0",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize: 16))
                                                                : Text(
                                                                "Total Rent: $totalrent",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize: 16))),
                                                        SizedBox(height: 2),
                                                        Divider(height: 1,
                                                            color: Colors.grey,
                                                            thickness: 1),
                                                        SizedBox(height: 20),
                                                        Align(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: totalsecurity ==
                                                                "" ||
                                                                totalsecurity ==
                                                                    "null" ||
                                                                totalsecurity ==
                                                                    null
                                                                ? Text(
                                                                "Total Security : 0",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize: 16))
                                                                : Text(
                                                                "Total Security: $totalsecurity",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize: 16))),
                                                        SizedBox(height: 2),
                                                        Divider(height: 1,
                                                            color: Colors.grey,
                                                            thickness: 1),
                                                        SizedBox(height: 20),
                                                        Align(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: finalamount ==
                                                                "" ||
                                                                finalamount ==
                                                                    "null" ||
                                                                finalamount ==
                                                                    null
                                                                ? Text(
                                                                "Final Amount : 0",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize: 16))
                                                                : Text(
                                                                "Final Amount: $finalamount",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize: 16))),
                                                        SizedBox(height: 2),
                                                        Divider(height: 1,
                                                            color: Colors.grey,
                                                            thickness: 1),
                                                        SizedBox(height: 10),
                                                        renttypename == "Hourly" ? _datetimepickerwithhour() : Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Text(startDate, style: TextStyle(color: Colors.black, fontSize: 16)),
                                                            IconButton(onPressed: () {
                                                                  print("You are here3");
                                                                  print("my rent type $renttypename");
                                                                  // setState((){
                                                                  //     startDate = null;
                                                                  // });
                                                                  if (renttypename == "Hourly" || renttypename == "hourly") {
                                                                     _datetimepickerwithhour();
                                                                  }
                                                                  else {
                                                                    _selectStartDate(context, setState);
                                                                  }
                                                                },
                                                                icon: Icon(Icons
                                                                    .calendar_today,
                                                                    size: 16))
                                                          ],
                                                        ),
                                                        Divider(height: 1,
                                                            color: Colors.grey,
                                                            thickness: 1),
                                                        SizedBox(height: 25),
                                                        InkWell(
                                                          onTap: () {
                                                            if (renttypename ==
                                                                null ||
                                                                renttypename ==
                                                                    "") {
                                                              showToast(
                                                                  "Please select rent type");
                                                            }
                                                            else
                                                            if (productQty ==
                                                                null ||
                                                                productQty ==
                                                                    "") {
                                                              showToast(
                                                                  "Please enter product quantity");
                                                            }
                                                            else
                                                            if (days == null ||
                                                                days == "") {
                                                              showToast(
                                                                  "Please enter period");
                                                            }
                                                            else
                                                            if (startDate ==
                                                                null ||
                                                                startDate ==
                                                                    "" ||
                                                                startDate ==
                                                                    "From Date") {
                                                              showToast(
                                                                  "Please enter start date");
                                                            }
                                                            else {
                                                              Navigator.of(
                                                                  context,
                                                                  rootNavigator: true)
                                                                  .pop();
                                                              _setmakeoffer();
                                                            }
                                                          },
                                                          child:
                                                          Container(
                                                            height:
                                                            45,
                                                            width: double
                                                                .infinity,
                                                            alignment:
                                                            Alignment.center,
                                                            decoration: const BoxDecoration(
                                                                color:
                                                                Colors
                                                                    .deepOrangeAccent,
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                    .circular(
                                                                    8.0))),
                                                            child: Text(
                                                                "Make Offer",
                                                                style:
                                                                TextStyle(
                                                                    color: Colors
                                                                        .white)),
                                                          ),
                                                        )
                                                      ]),
                                                ),
                                              ));
                                        }));
                          } else if (actionbtn == "Edit Offer") {
                            print("6");
                            print(getOfferData);
                            setState(() {
                              renttypeid =
                                  getOfferData['rent_type_id'].toString();
                              startDate = getOfferData['start_date'].toString();
                              renttypename = capitalize(
                                  getOfferData['rent_type_name'].toString());
                              productQty = getOfferData['quantity'].toString();
                              totalrent = double.parse(
                                  getOfferData['total_rent'].toString());
                              useramount =
                                  getOfferData['renter_amount'].toString();
                              days = getOfferData['period'].toString();
                              totalsecurity = double.parse(
                                  getOfferData['total_security'].toString());
                              finalamount = double.parse(
                                  getOfferData['final_amount'].toString());
                              renteramount = "Listed Price: " +
                                  getOfferData['product_price'].toString() +
                                  "/" + capitalize(
                                  getOfferData['rent_type_name'].toString());
                            });
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder:
                                    (context) =>
                                    StatefulBuilder(builder:
                                        (context, setState) {
                                      return AlertDialog(
                                          title: const Align(
                                            alignment: Alignment
                                                .topLeft,
                                            child: Text(
                                                "Make An Offer",
                                                style: TextStyle(
                                                    color: Colors
                                                        .deepOrangeAccent)),
                                          ),
                                          content: Container(
                                            child:
                                            SingleChildScrollView(
                                              child: Column(
                                                  children: [
                                                    DropdownButtonHideUnderline(
                                                      child: DropdownButton<
                                                          String>(
                                                        hint: Text("Select",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 18)),
                                                        value: renttypename,
                                                        elevation: 16,
                                                        isExpanded: true,
                                                        style: TextStyle(
                                                            color: Colors.grey
                                                                .shade700,
                                                            fontSize: 16),
                                                        onChanged: (
                                                            String data) {
                                                          print(rentpricelist);
                                                          rentpricelist
                                                              .forEach((
                                                              element) {
                                                            setState(() {
                                                              if (element['rent_type_name']
                                                                  .toString() ==
                                                                  data
                                                                      .toString()) {
                                                                renttypeid =
                                                                    element['rent_type_id']
                                                                        .toString();
                                                                renttypename =
                                                                    capitalize(
                                                                        data
                                                                            .toString());
                                                                productamount =
                                                                    element['price']
                                                                        .toString();
                                                                useramount =
                                                                    element['price']
                                                                        .toString();
                                                                renttypeid =
                                                                    element['rent_type_id']
                                                                        .toString();
                                                                renteramount =
                                                                "Listed Price: ${element['price']
                                                                    .toString() +
                                                                    "/" +
                                                                    element['rent_type_name']
                                                                        .toString()}";
                                                              }
                                                            });
                                                          });
                                                          print(renttypename);
                                                        },
                                                        items: renttypelist.map<
                                                            DropdownMenuItem<
                                                                String>>((String
                                                        value) {
                                                          return DropdownMenuItem<
                                                              String>(
                                                            value:
                                                            value,
                                                            child:
                                                            Text(value),
                                                          );
                                                        }).toList(),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        height:
                                                        2),
                                                    Divider(
                                                        height:
                                                        1,
                                                        color: Colors
                                                            .grey,
                                                        thickness:
                                                        1),
                                                    SizedBox(
                                                        height:
                                                        20),
                                                    Align(
                                                        alignment:
                                                        Alignment
                                                            .topLeft,
                                                        child: renteramount ==
                                                            null
                                                            ? Text(
                                                            "Listed Price: 0",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 16))
                                                            : Text(renteramount,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 16))),
                                                    SizedBox(
                                                        height:
                                                        2),
                                                    Divider(
                                                        height:
                                                        1,
                                                        color: Colors
                                                            .grey,
                                                        thickness:
                                                        1),
                                                    SizedBox(
                                                        height:
                                                        20),
                                                    Align(
                                                        alignment:
                                                        Alignment
                                                            .topLeft,
                                                        child: securitydeposit ==
                                                            "" ||
                                                            securitydeposit ==
                                                                "null" ||
                                                            securitydeposit ==
                                                                null
                                                            ? Text(
                                                            "Security Deposit : 0",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 16))
                                                            : Text(
                                                            "Security Deposit: $securitydeposit",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 16))),
                                                    SizedBox(
                                                        height:
                                                        2),
                                                    Divider(
                                                        height:
                                                        1,
                                                        color: Colors
                                                            .grey,
                                                        thickness:
                                                        1),
                                                    SizedBox(height: 10),
                                                    TextFormField(
                                                      initialValue: productQty,
                                                      keyboardType: TextInputType
                                                          .number,
                                                      decoration: const InputDecoration(
                                                        hintText: 'Enter Product Quantity',
                                                        border: null,
                                                      ),
                                                      onChanged: (value) {
                                                        totalrent = 0;
                                                        finalamount = 0;
                                                        if (negotiable == "0") {
                                                          setState(() {
                                                            productQty = value
                                                                .toString();
                                                            days == "null" ||
                                                                days == "" ||
                                                                days == null
                                                                ? totalrent = 0
                                                                : totalrent =
                                                                double.parse(
                                                                    productQty) *
                                                                    double
                                                                        .parse(
                                                                        days) *
                                                                    double
                                                                        .parse(
                                                                        productamount);
                                                            totalsecurity =
                                                                double.parse(
                                                                    productQty) *
                                                                    double
                                                                        .parse(
                                                                        securitydeposit);
                                                            days == "null" ||
                                                                days == "" ||
                                                                days == null
                                                                ? finalamount =
                                                                totalsecurity +
                                                                    totalrent
                                                                : finalamount =
                                                                totalrent +
                                                                    totalsecurity;
                                                          });
                                                        } else {
                                                          setState(() {
                                                            if (value.isEmpty) {
                                                              productQty = "";
                                                            }
                                                            totalrent = 0;
                                                            finalamount = 0;
                                                            useramount =
                                                            useramount == null
                                                                ? null
                                                                : useramount;
                                                            days = days == null
                                                                ? null
                                                                : days;
                                                          });

                                                          double qtyg = value
                                                              .isEmpty
                                                              ? 0
                                                              : double.parse(
                                                              value.toString());
                                                          double useramountg = useramount ==
                                                              null
                                                              ? renteramount
                                                              : double.parse(
                                                              useramount
                                                                  .toString());
                                                          double daysg = days ==
                                                              null ? 1 : double
                                                              .parse(
                                                              days.toString());
                                                          double totalrentg = 0;
                                                          if (qtyg == 0) {
                                                            totalrentg =
                                                                useramountg *
                                                                    daysg;
                                                          } else {
                                                            totalrentg = qtyg *
                                                                useramountg *
                                                                daysg;
                                                          }
                                                          print(qtyg);
                                                          print(useramountg);
                                                          print(daysg);
                                                          setState(() {
                                                            totalrent = 0;
                                                            productQty =
                                                                qtyg.toString();
                                                            totalrent =
                                                                totalrentg;
                                                            totalsecurity =
                                                                double.parse(
                                                                    securitydeposit) *
                                                                    qtyg;
                                                            finalamount =
                                                                totalsecurity +
                                                                    totalrent;
                                                          });
                                                        }
                                                      },
                                                    ),
                                                    negotiable ==
                                                        "1"
                                                        ? TextFormField(
                                                      initialValue: useramount,
                                                      keyboardType: TextInputType
                                                          .number,
                                                      decoration: InputDecoration(
                                                        hintText: _getrenttypeamounthint(
                                                            renttypename),
                                                        border: null,
                                                      ),
                                                      onChanged: (value) {
                                                        setState(() {
                                                          totalrent = 0;
                                                          finalamount = 0;
                                                          productQty =
                                                          productQty == null
                                                              ? null
                                                              : productQty;
                                                          days = days == null
                                                              ? null
                                                              : days;
                                                        });
                                                        double qtyg = double
                                                            .parse(productQty
                                                            .toString());
                                                        double useramountg = value
                                                            .isEmpty
                                                            ? 0
                                                            : double.parse(
                                                            value.toString());
                                                        double daysg = days ==
                                                            null ? 1 : double
                                                            .parse(
                                                            days.toString());
                                                        double totalrentg = 0;
                                                        if (useramountg == 0) {
                                                          totalrentg =
                                                              qtyg * daysg;
                                                        } else {
                                                          totalrentg = qtyg *
                                                              useramountg *
                                                              daysg;
                                                        }
                                                        print(qtyg);
                                                        print(useramountg);
                                                        print(daysg);
                                                        setState(() {
                                                          totalrent = 0;
                                                          totalrent =
                                                              totalrentg;
                                                          useramount =
                                                              useramountg
                                                                  .toString();
                                                          totalsecurity =
                                                              double.parse(
                                                                  securitydeposit) *
                                                                  qtyg;
                                                          finalamount =
                                                              totalsecurity +
                                                                  totalrent;
                                                        });
                                                      },
                                                    )
                                                        : SizedBox(),
                                                    TextFormField(
                                                      initialValue: days,
                                                      keyboardType: TextInputType
                                                          .number,
                                                      decoration: InputDecoration(
                                                        hintText: _getrenttypehint(
                                                            renttypename),
                                                        border: null,
                                                      ),
                                                      onChanged: (value) {
                                                        if (negotiable == "0") {
                                                          setState(() {
                                                            productQty =
                                                            productQty == null
                                                                ? null
                                                                : productQty;
                                                            days = value
                                                                .toString();
                                                            days == null
                                                                ? totalrent = 0
                                                                : totalrent =
                                                                double.parse(
                                                                    productQty) *
                                                                    double
                                                                        .parse(
                                                                        days) *
                                                                    double
                                                                        .parse(
                                                                        productamount);
                                                            totalsecurity =
                                                                double.parse(
                                                                    productQty) *
                                                                    double
                                                                        .parse(
                                                                        securitydeposit);
                                                            days == "null" ||
                                                                days == "" ||
                                                                days == null
                                                                ? finalamount =
                                                                totalsecurity +
                                                                    totalrent
                                                                : finalamount =
                                                                totalrent +
                                                                    totalsecurity;
                                                          });
                                                        } else {
                                                          setState(() {
                                                            productQty =
                                                            productQty == null
                                                                ? null
                                                                : productQty;
                                                            useramount =
                                                            useramount == null
                                                                ? null
                                                                : useramount;
                                                          });

                                                          double qtyg = double
                                                              .parse(productQty
                                                              .toString());
                                                          double useramountg = useramount ==
                                                              null ? 1 : double
                                                              .parse(useramount
                                                              .toString());
                                                          double daysg = value
                                                              .isEmpty
                                                              ? 0
                                                              : double.parse(
                                                              value.toString());

                                                          double totalrentg = 0;
                                                          if (useramountg ==
                                                              0) {
                                                            totalrentg = qtyg *
                                                                useramountg;
                                                          } else {
                                                            totalrentg = qtyg *
                                                                useramountg *
                                                                daysg;
                                                          }
                                                          print(qtyg);
                                                          print(useramountg);
                                                          print(daysg);
                                                          setState(() {
                                                            totalrent = 0;
                                                            days = daysg
                                                                .toString();
                                                            totalrent =
                                                                totalrentg;
                                                            totalsecurity =
                                                                double.parse(
                                                                    securitydeposit) *
                                                                    qtyg;
                                                            finalamount =
                                                                totalsecurity +
                                                                    totalrent;
                                                          });
                                                        }
                                                      },
                                                    ),
                                                    SizedBox(height: 20),
                                                    Align(alignment: Alignment
                                                        .topLeft,
                                                        child: totalrent ==
                                                            "" ||
                                                            totalrent ==
                                                                "null" ||
                                                            totalrent == null
                                                            ? Text(
                                                            "Total Rent : 0",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 16))
                                                            : Text(
                                                            "Total Rent: " +
                                                                totalrent
                                                                    .toString(),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 16))),
                                                    SizedBox(height: 2),
                                                    Divider(
                                                        height:
                                                        1,
                                                        color: Colors
                                                            .grey,
                                                        thickness:
                                                        1),
                                                    SizedBox(height: 20),
                                                    Align(alignment: Alignment
                                                        .topLeft,
                                                        child: totalsecurity ==
                                                            "" ||
                                                            totalsecurity ==
                                                                "null" ||
                                                            totalsecurity ==
                                                                null
                                                            ? Text(
                                                            "Total Security : 0",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 16))
                                                            : Text(
                                                            "Total Security: " +
                                                                totalsecurity
                                                                    .toString(),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 16))),
                                                    SizedBox(height: 2),
                                                    Divider(height: 1,
                                                        color: Colors.grey,
                                                        thickness: 1),
                                                    SizedBox(height: 20),
                                                    Align(alignment: Alignment
                                                        .topLeft,
                                                        child: finalamount ==
                                                            "" ||
                                                            finalamount ==
                                                                "null" ||
                                                            finalamount == null
                                                            ? Text(
                                                            "Final Amount : 0",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 16))
                                                            : Text(
                                                            "Final Amount: " +
                                                                finalamount
                                                                    .toString(),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 16))),
                                                    SizedBox(height: 2),
                                                    Divider(height: 1,
                                                        color: Colors.grey,
                                                        thickness: 1),
                                                    SizedBox(height: 10),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text(startDate, style: TextStyle(color: Colors.black, fontSize: 16)),
                                                        IconButton(onPressed: () {
                                                              print("You are here2");
                                                              /*setState((){
                                                                 startDate = null;
                                                              });*/
                                                              if (renttypename == "Hourly" || renttypename == "hourly") {
                                                                _datetimepickerwithhour();
                                                              }
                                                              else {
                                                                _selectStartDate(context, setState);
                                                              }
                                                            },
                                                            icon: Icon(Icons
                                                                .calendar_today,
                                                                size: 16))
                                                      ],
                                                    ),
                                                    Divider(height: 1,
                                                        color: Colors.grey,
                                                        thickness: 1),
                                                    SizedBox(height: 25),
                                                    InkWell(
                                                      onTap: () {
                                                        if (renttypename ==
                                                            null ||
                                                            renttypename ==
                                                                "") {
                                                          showToast(
                                                              "Please select rent type");
                                                        }
                                                        else if (productQty ==
                                                            null ||
                                                            productQty == "") {
                                                          showToast(
                                                              "Please enter product quantity");
                                                        }
                                                        else if (days == null ||
                                                            days == "") {
                                                          showToast(
                                                              "Please enter period");
                                                        }
                                                        else
                                                        if (startDate == null ||
                                                            startDate == "" ||
                                                            startDate ==
                                                                "From Date") {
                                                          showToast(
                                                              "Please enter start date");
                                                        }
                                                        else {
                                                          //Navigator.of(context).pop();
                                                          Navigator.of(context,
                                                              rootNavigator: true)
                                                              .pop();
                                                          _setmakeoffer();
                                                        }
                                                      },
                                                      child: Container(
                                                        height: 45,
                                                        width: double.infinity,
                                                        alignment: Alignment
                                                            .center,
                                                        decoration: const BoxDecoration(
                                                            color: Colors
                                                                .deepOrangeAccent,
                                                            borderRadius: BorderRadius
                                                                .all(
                                                                Radius.circular(
                                                                    8.0))),
                                                        child: Text(
                                                            "Make Offer",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white)),
                                                      ),
                                                    )
                                                  ]),
                                            ),
                                          ));
                                    }));
                          }
                          else {
                            //Start Payment
                          }
                        }
                      },
                      child: Container(
                        height: 45,
                        width: size.width * 0.45,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                            color: Colors.deepOrangeAccent,
                            borderRadius: BorderRadius.all(
                                Radius.circular(22.0))),
                        child: Text(
                            actionbtn.toString().toUpperCase(),
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ],
                ),
              )
                  : SizedBox(),
              SizedBox(height: 40),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Address : ",
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  SizedBox(
                    width: size.width * 0.70,
                    child: Text("$address",
                        maxLines: 2,
                        style: TextStyle(
                            color: kPrimaryColor, fontSize: 18)),
                  )
                ],
              ),
              SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Price : ",
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  SizedBox(
                    width: size.width * 0.70,
                    child: negotiable == "0" ? Text("Fixed",
                        maxLines: 2,
                        style: TextStyle(
                            color: kPrimaryColor, fontSize: 18)) : Text(
                        "Negotiable",
                        maxLines: 2,
                        style: TextStyle(
                            color: kPrimaryColor, fontSize: 18)),
                  )
                ],
              ),
              SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Email : ",
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  SizedBox(
                    width: size.width * 0.70,
                    child: Text("$email",
                        maxLines: 1,
                        style: TextStyle(
                            color: kPrimaryColor, fontSize: 18)),
                  )
                ],
              ),
              likedadproductlist.length == 0 ? SizedBox(height: 0) : SizedBox(
                  height: 40),
              likedadproductlist.length == 0 ? SizedBox(height: 0) : const Text(
                "You May Also Like",
                style: TextStyle(
                    color: Colors.deepOrangeAccent,
                    fontWeight: FontWeight.w700,
                    fontSize: 21),
              ),
              likedadproductlist.length == 0 ? SizedBox(height: 0) : SizedBox(
                  height: 10),
              likedadproductlist.length == 0 ? SizedBox(height: 0) : GridView.builder(
                  shrinkWrap: true,
                  itemCount: likedadproductlist.length,
                  physics: ClampingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 4.0,
                      mainAxisSpacing: 4.0,
                      childAspectRatio: 1.0),
                  itemBuilder: (context, index) {
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Column(
                        children: [
                          CachedNetworkImage(
                            height: 80,
                            width: double.infinity,
                            placeholder: (context, url) =>
                                Image.asset('assets/images/no_image.jpg'),
                            errorWidget: (context, url, error) =>
                                Image.asset('assets/images/no_image.jpg'),
                            fit: BoxFit.cover,
                            imageUrl: "https://dev.techstreet.in/rentit4me/public/assets/frontend/images/listings/" +
                                likedadproductlist[index]['images'][0]['file_name']
                                    .toString(),
                          ),
                          SizedBox(height: 5.0),
                          Padding(
                            padding: EdgeInsets.only(left: 5.0, right: 15.0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                  likedadproductlist[index]['title'].toString(),
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16)),
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 4.0, right: 4.0),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: size.width * 0.28,
                                  child: Text(
                                      "Starting from ${likedadproductlist[index]['currency']
                                          .toString()} ${likedadproductlist[index]['prices'][0]['price']
                                          .toString()}",
                                      style: TextStyle(
                                          color: kPrimaryColor,
                                          fontSize: 12)),
                                ),
                                IconButton(
                                    iconSize: 28,
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (context) =>
                                              ProductDetailScreen(
                                                  productid: likedadproductlist[index]['id']
                                                      .toString())));
                                    },
                                    icon: Icon(Icons.add_box_rounded,
                                        color: kPrimaryColor))
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Future _getcheckapproveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final body = {
      "user_id": prefs.getString('userid'),
    };
    var response = await http.post(Uri.parse(BASE_URL + checkapprove),
        body: jsonEncode(body),
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json'
        });
    if(response.statusCode == 200) {
      var data = json.decode(response.body)['Response'];
      if(data != null){
        setState(() {
          usertype = data['user_type'].toString();
          trustedbadge = data['trusted_badge'].toString();
          trustedbadgeapproval = data['trusted_badge_approval'].toString();
        });
      }
    } else {
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  String _getrenttypeamounthint(String renttype) {
    if (renttype == "Hourly" || renttype == "hourly") {
      return "Enter Amount Per Hour";
    } else if (renttype == "Weekly" || renttype == "weekly") {
      return "Enter Amount Per Week";
    } else if (renttype == "Monthly" || renttype == "monthly") {
      return "Enter Amount Per Month";
    } else if (renttype == "Yearly" || renttype == "yearly") {
      return "Enter Amount Per Year";
    } else if (renttype == "Days" || renttype == "days") {
      return "Enter Amount Per Day";
    } else {
      return "Enter Amount Per Period";
    }
  }

  String _getrenttypehint(String renttype) {
    if (renttype == "Hourly" || renttype == "hourly") {
      return "Enter Hours";
    } else if (renttype == "Weekly" || renttype == "weekly") {
      return "Enter Weeks";
    } else if (renttype == "Monthly" || renttype == "monthly") {
      return "Enter Months";
    } else if (renttype == "Yearly" || renttype == "yearly") {
      return "Enter Years";
    } else if (renttype == "Days" || renttype == "days") {
      return "Enter Days";
    } else {
      return "Enter Period";
    }
  }

  Future _getproductDetail(String productid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final body = {"id": productid, "user_id": prefs.getString('userid')};
    print(productid);
    print(prefs.getString('userid'));
    var response = await http.post(Uri.parse(BASE_URL + productdetail),
        body: jsonEncode(body),
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json'
        });
    if (response.statusCode == 200) {
      var data = json.decode(response.body)['Response'];
      setState(() {
        userid = prefs.getString('userid');

        productimage = "${data['Images'][0]['upload_base_path'].toString() +
            data['Images'][0]['file_name'].toString()}";
        productname = data['posted_ad']['title'].toString();
        final document = parse(data['posted_ad']['description'].toString());
        description = parse(document.body.text).documentElement.text.toString();
        boostpack = data['posted_ad']['boost_package_status'].toString();
        renttype = data['posted_ad']['rent_type'].toString();
        negotiable = data['posted_ad']['negotiate'].toString();

        query_id = data['additional']['added-by']['quickblox_id'].toString();
        print("query id here $query_id");

        List temp = [];
        data['posted_ad']['prices'].forEach((element) {
          if (element['price'] != null) {
            temp.add("INR " + element['price'].toString() + " (" +
                element['rent_type_name'].toString() + ")");
          }
        });
        productprice = temp.join("/").toString();
        securitydeposit = data['posted_ad']['security'].toString();
        addedby = data['additional']['added-by']['name'].toString();
        email = data['additional']['added-by']['email'].toString();
        address = data['additional']['added-by']['address'].toString();
        actionbtn = data['offer'].toString();
        likedadproductlist = data['liked_ads'];
        if (data['posted_ad']['user_id'].toString() ==
            prefs.getString('userid')) {
          _checkuser = true;
        } else {
          _checkuser = false;
        }

        _checkData = true;
      });
    } else {
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  Map getOfferData = {};
  Future _getmakeoffer(String productid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(jsonEncode(
        {"user_id": prefs.getString('userid'), "post_ad_id": productid}));
    final body = {
      "user_id": prefs.getString('userid'),
      "post_ad_id": productid
    };
    var response = await http.post(Uri.parse(BASE_URL + createoffer),
        body: jsonEncode(body),
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json'
        });
    if (response.statusCode == 200) {
      var data = json.decode(response.body)['Response'];
      setState(() {
        if (data['data'] != "null") {
          getOfferData = data['data'];
        }

        securitydeposit = data['posted_ad']['security'].toString();
        rentpricelist.addAll(data['posted_ad']['prices']);
        rentpricelist.forEach((element) {
          if (element['price'] != null) {
            renttypelist.add(element['rent_type_name'].toString());
          }
        });
      });
    } else {
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  Future _setmakeoffer() async {
    showLaoding(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(jsonEncode({
      "post_ad_id": productid,
      "period": days,
      "rent_type": renttypeid,
      "quantity": productQty,
      "start_date": startDate,
      "renter_amount": useramount,
      "user_id": prefs.getString('userid'),
    }));
    final body = {
      "post_ad_id": productid,
      "period": days,
      "rent_type": renttypeid,
      "quantity": productQty,
      "start_date": startDate,
      "renter_amount": useramount,
      "user_id": prefs.getString('userid'),
    };
    var response = await http.post(Uri.parse(BASE_URL + makeoffer),
        body: jsonEncode(body),
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json'
        });
    Navigator.of(context, rootNavigator: true).pop();
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      showToast(data['ErrorMessage'].toString());
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => HomeScreen()));
    } else {
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  Future<void> _selectStartDate(BuildContext context, setState) async {
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
        startDate = DateFormat('yyyy/MM/dd').format(picked);
      });
  }

  Widget _datetimepickerwithhour() {
    return DateTimePicker(
        type: DateTimePickerType.dateTime,
        dateMask: 'yyyy/MMM/dd - hh:mm a',
        //initialValue: _initialValue,
        firstDate: DateTime(2000),
        lastDate: DateTime(2030),
        //icon: Icon(Icons.event),
        dateLabelText: 'Date Time',
        use24HourFormat: false,
        locale: Locale('en', 'US'),
        icon: Icon(Icons.calendar_today_sharp, size: 20),
        validator: (val) {
           setState((){
              startDate = val;
           });
        },
        onSaved: (val) {
          setState((){
            startDate = val;
          });
        },
        onChanged: (val) {
          setState((){
             startDate = val;
          });
        },
      onFieldSubmitted: (v){
           setState((){
             startDate = v;
          });
      },

    );
  }
}
