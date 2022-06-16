import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:rentit4me/network/api.dart';
import 'package:rentit4me/themes/constant.dart';
import 'package:rentit4me/views/home_screen.dart';
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
  int totalrent = 0;
  int totalsecurity = 0;
  int finalamount = 0;
  String days;

  List<dynamic> rentpricelist = [];
  List<String> renttypelist = [];

  List<dynamic> likedadproductlist = [];

  String productQty;
  String startDate = "From Date";
  String actionbtn;

  String productimage = 'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80';

  String usertype;
  String trustedbadge;
  String trustedbadgeapproval;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getproductDetail(productid);
    _getcheckapproveData();
    _getmakeoffer(productid);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
       resizeToAvoidBottomInset: false,
       appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2.0,
        leading: Padding(
          padding: EdgeInsets.only(left: 10),
          child: Image.asset('assets/images/logo.png'),
        ),
        title: Text("Detail", style: TextStyle(color: kPrimaryColor)),
        centerTitle: true,
        /*actions: [
          IconButton(onPressed:(){}, icon: Icon(Icons.edit, color: kPrimaryColor)),
          IconButton(onPressed:(){}, icon: Icon(Icons.account_circle, color: kPrimaryColor)),
          IconButton(onPressed:(){}, icon: Icon(Icons.menu, color: kPrimaryColor))
        ],*/
      ),
       body: _checkData == false ? Center(
         child: CircularProgressIndicator(),
       ) : SingleChildScrollView(
         child: Padding(
           padding: const EdgeInsets.all(10.0),
           child: Column(
             children: [
               Container(
                 height: 120,
                 width: double.infinity,
                 child: CachedNetworkImage(
                   imageUrl: sliderpath+productimage,
                   fit: BoxFit.fill,
                 ),
               ),
               Container(
                 height: 80,
                 padding: EdgeInsets.symmetric(vertical: 8.0),
                 width: double.infinity,
                 child: ListView.separated(
                     shrinkWrap: true,
                     separatorBuilder: (BuildContext context, int index) => const SizedBox(width: 10),
                     itemCount: 3,
                     scrollDirection: Axis.horizontal,
                     itemBuilder: (context, index){
                       return Container(
                         height: 60,
                         width: 80,
                         child: CachedNetworkImage(
                           imageUrl: sliderpath+productimage,
                           fit: BoxFit.fill,
                         ),
                       );
                     }
                 ),
               ),
               Align(
                   alignment: Alignment.topLeft,
                   child: productname == "null" || productname == null || productname == "" ? SizedBox() : Text(productname, style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold))
               ),
               SizedBox(height: 4.0),
               Align(
                   alignment: Alignment.topLeft,
                   child: boostpack == "null" || boostpack == "" || boostpack == null ? SizedBox() : Text("Sponsored", style: TextStyle(color: Colors.black, fontSize: 14))
               ),
               SizedBox(height: 15.0),
               Align(
                   alignment: Alignment.topLeft,
                   child: description == "" || description == "null" || description == null ? SizedBox() : Text(description, style: TextStyle(color: Colors.black, fontSize: 12))
               ),
               SizedBox(height: 35.0),
               Align(
                   alignment: Alignment.topLeft,
                   child: renttype == null || renttype == "" || renttype == "null" ? Text("INR $productprice", style: TextStyle(color: kPrimaryColor, fontSize: 16, fontWeight: FontWeight.w500)) : Text("INR $productprice $renttype", style: TextStyle(color: kPrimaryColor, fontSize: 16, fontWeight: FontWeight.w500))
               ),
               SizedBox(height: 15.0),
               Align(
                   alignment: Alignment.topLeft,
                   child: Text("Security Deposit : INR $securitydeposit", style: TextStyle(color: kPrimaryColor, fontSize: 16, fontWeight: FontWeight.w500))
               ),
               SizedBox(height: 15.0),
               Align(
                   alignment: Alignment.topLeft,
                   child: Text("Added By : $addedby", style: TextStyle(color: kPrimaryColor, fontSize: 16, fontWeight: FontWeight.w500))
               ),
               SizedBox(height: 35.0),
               _checkuser == false ? Container(
                 height: 60,
                 width: double.infinity,
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     InkWell(
                       onTap : (){},
                       child: Container(
                         height: 45,
                         width: size.width * 0.45,
                         alignment: Alignment.center,
                         decoration: const BoxDecoration(
                             color: kPrimaryColor,
                             borderRadius: BorderRadius.all(Radius.circular(22.0))
                         ),
                         child: Text("START DISCUSSION", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                       ),
                     ),
                     InkWell(
                       onTap: () {
                          if(trustedbadge == "1"){
                            if(trustedbadgeapproval == "Pending" || trustedbadgeapproval == "pending"){
                              showToast("Your verification is under process.");
                            }
                            else{
                              setState((){
                                productQty = null;
                                totalrent=0;
                                useramount = null;
                                days = null;
                                totalsecurity = 0;
                                finalamount = 0;
                              });
                              showDialog(context: context, barrierDismissible: false, builder: (context)=> StatefulBuilder(
                                  builder: (context, setState){
                                    return AlertDialog(title: const Align(
                                      alignment: Alignment.topLeft,
                                      child: Text("Make An Offer", style: TextStyle(color: Colors.deepOrangeAccent)),
                                    ),content:
                                    Container(
                                      child: SingleChildScrollView(
                                        child: Column(
                                            children:[
                                              DropdownButtonHideUnderline(
                                                child: DropdownButton<String>(
                                                  hint: Text("Select", style: TextStyle(color: Colors.black, fontSize: 18)),
                                                  value: renttypename,
                                                  elevation: 16,
                                                  isExpanded: true,
                                                  style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
                                                  onChanged: (String data) {
                                                    setState(() {
                                                      rentpricelist.forEach((element) {
                                                        if(element['rent_type_name'].toString() == data.toString()){
                                                          renttypename = data.toString();
                                                          productamount = element['price'].toString();
                                                          useramount = element['price'].toString();
                                                          renttypeid = element['rent_type_id'].toString();
                                                          renteramount = "Listed Price: ${element['price'].toString()+"/"+element['rent_type_name'].toString()}";
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
                                              Divider(height: 1, color: Colors.grey, thickness: 1),
                                              SizedBox(height: 20),
                                              Align(
                                                  alignment: Alignment.topLeft,
                                                  child: renteramount == "null" || renteramount == null || renteramount == "" ?  Text("Listed Price: 0", style: TextStyle(color: Colors.black, fontSize: 16)) : Text(renteramount, style: TextStyle(color: Colors.black, fontSize: 16))
                                              ),
                                              SizedBox(height: 2),
                                              Divider(height: 1, color: Colors.grey, thickness: 1),
                                              SizedBox(height: 20),
                                              Align(
                                                  alignment: Alignment.topLeft,
                                                  child: securitydeposit == "" || securitydeposit == "null" || securitydeposit == null ? Text("Security Deposit : 0", style: TextStyle(color: Colors.black, fontSize: 16)) : Text("Security Deposit: $securitydeposit", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ),
                                              SizedBox(height: 2),
                                              Divider(height: 1, color: Colors.grey, thickness: 1),
                                              SizedBox(height: 10),
                                              TextField(
                                                keyboardType: TextInputType.number,
                                                decoration: const InputDecoration(
                                                  hintText: 'Enter Product Quantity',
                                                  border: null,
                                                ),
                                                onChanged: (value){
                                                  setState(() {
                                                    if(negotiable == "0"){
                                                      productQty = value.toString();
                                                      days == "null" || days == "" || days == null ? totalrent = 0 : totalrent = int.parse(productQty)*int.parse(days)*int.parse(productamount);
                                                      totalsecurity = int.parse(productQty)*int.parse(securitydeposit);
                                                      days == "null" || days == "" || days == null ? finalamount = totalsecurity+totalrent : finalamount = totalrent+totalsecurity;
                                                    }
                                                    else{
                                                      setState((){
                                                        useramount = useramount == null ? null : useramount;
                                                        days=days == null ? null : days;
                                                      });

                                                      int qtyg = int.parse(value.toString());
                                                      int useramountg = useramount == null ? 1 : int.parse(useramount.toString());
                                                      int daysg = days == null ? 1 : int.parse(days.toString());

                                                      int totalrentg = qtyg*useramountg*daysg;
                                                      setState((){
                                                        totalrent = 0;
                                                        productQty = qtyg.toString();
                                                        totalrent = totalrentg;
                                                        totalsecurity = int.parse(securitydeposit)*qtyg;
                                                        finalamount = totalsecurity + totalrent;
                                                      });
                                                    }

                                                  });
                                                },
                                              ),
                                              negotiable == "1" ? TextField(
                                                keyboardType: TextInputType.number,
                                                decoration: InputDecoration(
                                                  hintText: _getrenttypeamounthint(renttypename),
                                                  border: null,
                                                ),
                                                onChanged: (value){
                                                  setState((){
                                                    productQty = productQty == null ? null : productQty;
                                                    days = days == null ? null : days;
                                                  });
                                                  int qtyg = int.parse(productQty.toString());
                                                  int useramountg =  int.parse(value.toString());
                                                  int daysg = days == null ? 1 : int.parse(days.toString());
                                                  int totalrentg = qtyg*useramountg*daysg;
                                                  setState((){
                                                    totalrent = 0;
                                                    totalrent = totalrentg;
                                                    useramount = useramountg.toString();
                                                    totalsecurity = int.parse(securitydeposit)*qtyg;
                                                    finalamount = totalsecurity + totalrent;
                                                  });
                                                },
                                              ) : SizedBox(),
                                              TextField(
                                                keyboardType: TextInputType.number,
                                                decoration: InputDecoration(
                                                  hintText: _getrenttypehint(renttypename),
                                                  border: null,
                                                ),
                                                onChanged: (value){
                                                  if(negotiable == "0") {
                                                    setState((){
                                                      productQty = productQty == null ? null : productQty;
                                                      days = value.toString();
                                                      days == null ? totalrent = 0 : totalrent = int.parse(productQty)*int.parse(days)*int.parse(productamount);
                                                      totalsecurity = int.parse(productQty)*int.parse(securitydeposit);
                                                      days == "null" || days == "" || days == null ? finalamount = totalsecurity+totalrent : finalamount = totalrent+totalsecurity;
                                                    });
                                                  }
                                                  else{
                                                    setState((){
                                                      productQty= productQty == null ? null : productQty;
                                                      useramount= useramount == null ? null : useramount;
                                                    });

                                                    int qtyg = int.parse(productQty.toString());
                                                    int useramountg = useramount == null ? 1 : int.parse(useramount.toString());
                                                    int daysg =  int.parse(value.toString());
                                                    int totalrentg = qtyg*useramountg*daysg;
                                                    setState((){
                                                      totalrent = 0;
                                                      days = daysg.toString();
                                                      totalrent = totalrentg;
                                                      totalsecurity = int.parse(securitydeposit)*qtyg;
                                                      finalamount = totalsecurity + totalrent;
                                                    });
                                                  }
                                                },
                                              ),
                                              SizedBox(height: 20),
                                              Align(
                                                  alignment: Alignment.topLeft,
                                                  child: totalrent == "" || totalrent == "null" || totalrent == null ? Text("Total Rent : 0", style: TextStyle(color: Colors.black, fontSize: 16)) : Text("Total Rent: $totalrent", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ),
                                              SizedBox(height: 2),
                                              Divider(height: 1, color: Colors.grey, thickness: 1),
                                              SizedBox(height: 20),
                                              Align(
                                                  alignment: Alignment.topLeft,
                                                  child: totalsecurity == "" || totalsecurity == "null" || totalsecurity == null ? Text("Total Security : 0", style: TextStyle(color: Colors.black, fontSize: 16)) : Text("Total Security: $totalsecurity", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ),
                                              SizedBox(height: 2),
                                              Divider(height: 1, color: Colors.grey, thickness: 1),
                                              SizedBox(height: 20),
                                              Align(
                                                  alignment: Alignment.topLeft,
                                                  child: finalamount == "" || finalamount == "null" || finalamount == null ? Text("Final Amount : 0", style: TextStyle(color: Colors.black, fontSize: 16)) : Text("Final Amount: $finalamount", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ),
                                              SizedBox(height: 2),
                                              Divider(height: 1, color: Colors.grey, thickness: 1),
                                              SizedBox(height: 10),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(startDate, style: TextStyle(color: Colors.black, fontSize: 16)),
                                                  IconButton(onPressed: (){
                                                    _selectStartDate(context, setState);
                                                  }, icon: Icon(Icons.calendar_today, size: 16))
                                                ],
                                              ),
                                              Divider(height: 1, color: Colors.grey, thickness: 1),
                                              SizedBox(height: 25),
                                              InkWell(
                                                onTap: () {
                                                  _setmakeoffer();
                                                },
                                                child: Container(
                                                  height: 45,
                                                  width: double.infinity,
                                                  alignment: Alignment.center,
                                                  decoration: const BoxDecoration(
                                                      color: Colors.deepOrangeAccent,
                                                      borderRadius: BorderRadius.all(Radius.circular(8.0))
                                                  ),
                                                  child: Text("Make Offer", style: TextStyle(color: Colors.white)),
                                                ),
                                              )
                                            ]
                                        ),
                                      ),
                                    )
                                    );
                                  }
                              ));
                            }
                          }
                          else{
                            setState((){
                              productQty = null;
                              totalrent=0;
                              useramount = null;
                              days = null;
                              totalsecurity = 0;
                              finalamount = 0;
                            });
                            showDialog(context: context, barrierDismissible: false, builder: (context)=> StatefulBuilder(
                                builder: (context, setState){
                                  return AlertDialog(title: const Align(
                                    alignment: Alignment.topLeft,
                                    child: Text("Make An Offer", style: TextStyle(color: Colors.deepOrangeAccent)),
                                  ),content:
                                  Container(
                                    child: SingleChildScrollView(
                                      child: Column(
                                          children:[
                                            DropdownButtonHideUnderline(
                                              child: DropdownButton<String>(
                                                hint: Text("Select", style: TextStyle(color: Colors.black, fontSize: 18)),
                                                value: renttypename,
                                                elevation: 16,
                                                isExpanded: true,
                                                style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
                                                onChanged: (String data) {
                                                  setState(() {
                                                    rentpricelist.forEach((element) {
                                                      if(element['rent_type_name'].toString() == data.toString()){
                                                        renttypename = data.toString();
                                                        productamount = element['price'].toString();
                                                        useramount = element['price'].toString();
                                                        renttypeid = element['rent_type_id'].toString();
                                                        renteramount = "Listed Price: ${element['price'].toString()+"/"+element['rent_type_name'].toString()}";
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
                                            Divider(height: 1, color: Colors.grey, thickness: 1),
                                            SizedBox(height: 20),
                                            Align(
                                                alignment: Alignment.topLeft,
                                                child: renteramount == "null" || renteramount == null || renteramount == "" ?  Text("Listed Price: 0", style: TextStyle(color: Colors.black, fontSize: 16)) : Text(renteramount, style: TextStyle(color: Colors.black, fontSize: 16))
                                            ),
                                            SizedBox(height: 2),
                                            Divider(height: 1, color: Colors.grey, thickness: 1),
                                            SizedBox(height: 20),
                                            Align(
                                                alignment: Alignment.topLeft,
                                                child: securitydeposit == "" || securitydeposit == "null" || securitydeposit == null ? Text("Security Deposit : 0", style: TextStyle(color: Colors.black, fontSize: 16)) : Text("Security Deposit: $securitydeposit", style: TextStyle(color: Colors.black, fontSize: 16))
                                            ),
                                            SizedBox(height: 2),
                                            Divider(height: 1, color: Colors.grey, thickness: 1),
                                            SizedBox(height: 10),
                                            TextField(
                                              keyboardType: TextInputType.number,
                                              decoration: const InputDecoration(
                                                hintText: 'Enter Product Quantity',
                                                border: null,
                                              ),
                                              onChanged: (value){
                                                setState(() {
                                                  if(negotiable == "0"){
                                                    productQty = value.toString();
                                                    days == "null" || days == "" || days == null ? totalrent = 0 : totalrent = int.parse(productQty)*int.parse(days)*int.parse(productamount);
                                                    totalsecurity = int.parse(productQty)*int.parse(securitydeposit);
                                                    days == "null" || days == "" || days == null ? finalamount = totalsecurity+totalrent : finalamount = totalrent+totalsecurity;
                                                  }
                                                  else{
                                                    setState((){
                                                      useramount = useramount == null ? null : useramount;
                                                      days=days == null ? null : days;
                                                    });

                                                    int qtyg = int.parse(value.toString());
                                                    int useramountg = useramount == null ? 1 : int.parse(useramount.toString());
                                                    int daysg = days == null ? 1 : int.parse(days.toString());

                                                    int totalrentg = qtyg*useramountg*daysg;
                                                    setState((){
                                                      totalrent = 0;
                                                      productQty = qtyg.toString();
                                                      totalrent = totalrentg;
                                                      totalsecurity = int.parse(securitydeposit)*qtyg;
                                                      finalamount = totalsecurity + totalrent;
                                                    });
                                                  }

                                                });
                                              },
                                            ),
                                            negotiable == "1" ? TextField(
                                              keyboardType: TextInputType.number,
                                              decoration: InputDecoration(
                                                hintText: _getrenttypeamounthint(renttypename),
                                                border: null,
                                              ),
                                              onChanged: (value){
                                                setState((){
                                                  productQty = productQty == null ? null : productQty;
                                                  days = days == null ? null : days;
                                                });
                                                int qtyg = int.parse(productQty.toString());
                                                int useramountg =  int.parse(value.toString());
                                                int daysg = days == null ? 1 : int.parse(days.toString());
                                                int totalrentg = qtyg*useramountg*daysg;
                                                setState((){
                                                  totalrent = 0;
                                                  totalrent = totalrentg;
                                                  useramount = useramountg.toString();
                                                  totalsecurity = int.parse(securitydeposit)*qtyg;
                                                  finalamount = totalsecurity + totalrent;
                                                });
                                              },
                                            ) : SizedBox(),
                                            TextField(
                                              keyboardType: TextInputType.number,
                                              decoration: InputDecoration(
                                                hintText: _getrenttypehint(renttypename),
                                                border: null,
                                              ),
                                              onChanged: (value){
                                                if(negotiable == "0") {
                                                  setState((){
                                                    productQty = productQty == null ? null : productQty;
                                                    days = value.toString();
                                                    days == null ? totalrent = 0 : totalrent = int.parse(productQty)*int.parse(days)*int.parse(productamount);
                                                    totalsecurity = int.parse(productQty)*int.parse(securitydeposit);
                                                    days == "null" || days == "" || days == null ? finalamount = totalsecurity+totalrent : finalamount = totalrent+totalsecurity;
                                                  });
                                                }
                                                else{
                                                  setState((){
                                                    productQty= productQty == null ? null : productQty;
                                                    useramount= useramount == null ? null : useramount;
                                                  });

                                                  int qtyg = int.parse(productQty.toString());
                                                  int useramountg = useramount == null ? 1 : int.parse(useramount.toString());
                                                  int daysg =  int.parse(value.toString());
                                                  int totalrentg = qtyg*useramountg*daysg;
                                                  setState((){
                                                    totalrent = 0;
                                                    days = daysg.toString();
                                                    totalrent = totalrentg;
                                                    totalsecurity = int.parse(securitydeposit)*qtyg;
                                                    finalamount = totalsecurity + totalrent;
                                                  });
                                                }
                                              },
                                            ),
                                            SizedBox(height: 20),
                                            Align(
                                                alignment: Alignment.topLeft,
                                                child: totalrent == "" || totalrent == "null" || totalrent == null ? Text("Total Rent : 0", style: TextStyle(color: Colors.black, fontSize: 16)) : Text("Total Rent: $totalrent", style: TextStyle(color: Colors.black, fontSize: 16))
                                            ),
                                            SizedBox(height: 2),
                                            Divider(height: 1, color: Colors.grey, thickness: 1),
                                            SizedBox(height: 20),
                                            Align(
                                                alignment: Alignment.topLeft,
                                                child: totalsecurity == "" || totalsecurity == "null" || totalsecurity == null ? Text("Total Security : 0", style: TextStyle(color: Colors.black, fontSize: 16)) : Text("Total Security: $totalsecurity", style: TextStyle(color: Colors.black, fontSize: 16))
                                            ),
                                            SizedBox(height: 2),
                                            Divider(height: 1, color: Colors.grey, thickness: 1),
                                            SizedBox(height: 20),
                                            Align(
                                                alignment: Alignment.topLeft,
                                                child: finalamount == "" || finalamount == "null" || finalamount == null ? Text("Final Amount : 0", style: TextStyle(color: Colors.black, fontSize: 16)) : Text("Final Amount: $finalamount", style: TextStyle(color: Colors.black, fontSize: 16))
                                            ),
                                            SizedBox(height: 2),
                                            Divider(height: 1, color: Colors.grey, thickness: 1),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(startDate, style: TextStyle(color: Colors.black, fontSize: 16)),
                                                IconButton(onPressed: (){
                                                  _selectStartDate(context, setState);
                                                }, icon: Icon(Icons.calendar_today, size: 16))
                                              ],
                                            ),
                                            Divider(height: 1, color: Colors.grey, thickness: 1),
                                            SizedBox(height: 25),
                                            InkWell(
                                              onTap: () {
                                                _setmakeoffer();
                                              },
                                              child: Container(
                                                height: 45,
                                                width: double.infinity,
                                                alignment: Alignment.center,
                                                decoration: const BoxDecoration(
                                                    color: Colors.deepOrangeAccent,
                                                    borderRadius: BorderRadius.all(Radius.circular(8.0))
                                                ),
                                                child: Text("Make Offer", style: TextStyle(color: Colors.white)),
                                              ),
                                            )
                                          ]
                                      ),
                                    ),
                                  )
                                  );
                                }
                            ));
                          }
                       },
                       child: Container(
                         height: 45,
                         width: size.width * 0.45,
                         alignment: Alignment.center,
                         decoration: const BoxDecoration(
                             color: Colors.deepOrangeAccent,
                             borderRadius: BorderRadius.all(Radius.circular(22.0))
                         ),
                         child: Text(actionbtn.toString().toUpperCase(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                       ),
                     ),
                   ],
                 ),
               ) : SizedBox(),
               SizedBox(height: 40),
               Row(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text("Address : ", style: TextStyle(color: kPrimaryColor, fontSize: 18, fontWeight: FontWeight.bold)),
                   SizedBox(
                     width: size.width * 0.70,
                     child: Text("$address", maxLines: 2, style: TextStyle(color: kPrimaryColor, fontSize: 18)),
                   )

                 ],
               ),
               SizedBox(height: 20),
               Row(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text("Price : ", style: TextStyle(color: kPrimaryColor, fontSize: 18, fontWeight: FontWeight.bold)),
                   SizedBox(
                     width: size.width * 0.70,
                     child: Text("$productprice", maxLines: 1, style: TextStyle(color: kPrimaryColor, fontSize: 18)),
                   )

                 ],
               ),
               SizedBox(height: 20),
               Row(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text("Email : ", style: TextStyle(color: kPrimaryColor, fontSize: 18, fontWeight: FontWeight.bold)),
                   SizedBox(
                     width: size.width * 0.70,
                     child: Text("$email", maxLines: 1, style: TextStyle(color: kPrimaryColor, fontSize: 18)),
                   )

                 ],
               ),
               SizedBox(height: 40),
               const Text(
                 "You May Also Like",
                 style: TextStyle(color: Colors.deepOrangeAccent, fontWeight: FontWeight.w700, fontSize: 21),
               ),
               SizedBox(height: 10),
               GridView.builder(
                   shrinkWrap: true,
                   itemCount: likedadproductlist.length,
                   physics: ClampingScrollPhysics(),
                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                       crossAxisCount: 2,
                       crossAxisSpacing: 4.0,
                       mainAxisSpacing: 4.0,
                       childAspectRatio: 0.90
                   ),
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
                             placeholder: (context, url) => Image.asset('assets/images/no_image.jpg'),
                             errorWidget: (context, url, error) => Image.asset('assets/images/no_image.jpg'),
                             fit: BoxFit.cover,
                             imageUrl: productimage,
                           ),
                           SizedBox(height: 5.0),
                           Padding(
                             padding: EdgeInsets.only(left: 5.0, right: 15.0),
                             child: Align(
                               alignment: Alignment.topLeft,
                               child: Text(likedadproductlist[index]['title'].toString(), maxLines: 2, style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 16)),
                             ),
                           ),
                           SizedBox(height: 5.0),
                           Padding(
                             padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                             child: Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 SizedBox(
                                   width: size.width * 0.28,
                                   child: Text("Starting from ${likedadproductlist[index]['currency'].toString()} ${likedadproductlist[index]['prices'][0]['price'].toString()}",  style: TextStyle(color: kPrimaryColor, fontSize: 12)),
                                 ),
                                 IconButton(
                                     iconSize: 28,
                                     onPressed: (){}, icon: Icon(Icons.add_box_rounded, color: kPrimaryColor))
                               ],
                             ),
                           )
                         ],
                       ),
                     );
                   }
               ),
             ],
           ),
         ),
       ),
    );
  }

  Future _getcheckapproveData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final body = {
      //"user_id": "846",  //this is business user id
      "user_id": prefs.getString('userid'),
    };
    var response = await http.post(Uri.parse(BASE_URL + checkapprove),
        body: jsonEncode(body),
        headers: {
          "Accept" : "application/json",
          'Content-Type' : 'application/json'
        }
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body)['Response'];
      setState(() {
        usertype = data['user_type'].toString();
        trustedbadge = data['trusted_badge'].toString();
        trustedbadgeapproval = data['trusted_badge_approval'].toString();
      });

    } else {
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  String _getrenttypeamounthint(String renttype){
    if(renttype == "Hourly" || renttype == "hourly"){
      return "Enter Amount per Hour";
    }
    else if(renttype == "Weekly" || renttype == "weekly"){
      return "Enter Amount per Week";
    }
    else if(renttype == "Monthly" || renttype == "monthly"){
      return "Enter Amount per Month";
    }
    else if(renttype == "Yearly" || renttype == "yearly"){
      return "Enter Amount per Year";
    }
    else {
      return "Enter Amount per Day";
    }
  }

  String _getrenttypehint(String renttype){
    if(renttype == "Hourly" || renttype == "hourly"){
      return "Enter Hours";
    }
    else if(renttype == "Weekly" || renttype == "weekly"){
      return "Enter Weeks";
    }
    else if(renttype == "Monthly" || renttype == "monthly"){
      return "Enter Months";
    }
    else if(renttype == "Yearly" || renttype == "yearly"){
      return "Enter Years";
    }
    else {
      return "Enter Days";
    }
  }

  Future _getproductDetail(String productid) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final body = {
      "id": productid,
      "user_id" : prefs.getString('userid')
    };
    print(productid);
    print(prefs.getString('userid'));
    var response = await http.post(Uri.parse(BASE_URL + productdetail),
        body: jsonEncode(body),
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json'
        }
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body)['Response'];
      setState(() {
         productimage = "${data['Images'][0]['upload_base_path'].toString()+data['Images'][0]['file_name'].toString()}";
         productname = data['posted_ad']['title'].toString();
         final document = parse(data['posted_ad']['description'].toString());
         description = parse(document.body.text).documentElement.text.toString();
         boostpack = data['posted_ad']['boost_package_status'].toString();
         renttype = data['posted_ad']['rent_type'].toString();
         productprice = data['posted_ad']['prices'][0]['price'].toString();
         securitydeposit = data['posted_ad']['security'].toString();
         addedby = data['additional']['added-by']['name'].toString();
         email = data['additional']['added-by']['email'].toString();
         address = data['additional']['added-by']['address'].toString();
         actionbtn = data['offer'].toString();
         likedadproductlist = data['liked_ads'];
         if(data['posted_ad']['user_id'].toString() == prefs.getString('userid')){
            _checkuser = true;
         }
         else{
           _checkuser = false;
         }

         _checkData = true;
      });
    } else {
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  Future _getmakeoffer(String productid) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final body = {
      "user_id": prefs.getString('userid'),
      "post_ad_id" : productid
    };
    var response = await http.post(Uri.parse(BASE_URL + createoffer),
        body: jsonEncode(body),
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json'
        }
    );
    print(response.body);
    if (response.statusCode == 200) {
      var data = json.decode(response.body)['Response'];
      setState(() {
           negotiable = data['posted_ad']['negotiate'].toString();
           securitydeposit = data['posted_ad']['security'].toString();
           rentpricelist.addAll(data['posted_ad']['prices']);
           for(int i=0; i<data['posted_ad']['prices'].length; i++){
             renttypelist.add(data['posted_ad']['prices'][i]['rent_type_name'].toString());
          }
      });
    } else {
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  Future _setmakeoffer() async{
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
         }
     );
     if (response.statusCode == 200) {
       Navigator.pop(context);
       var data = json.decode(response.body);
       showToast(data['ErrorMessage'].toString());
       Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => HomeScreen()));
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
         startDate = DateFormat('MM/dd/yyyy').format(picked);
      });
  }
}
