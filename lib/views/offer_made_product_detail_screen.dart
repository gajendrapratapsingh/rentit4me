import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rentit4me/network/api.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rentit4me/themes/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OfferMadeProductDetailScreen extends StatefulWidget {

  String offerid;
  String postadid;
  OfferMadeProductDetailScreen({this.postadid, this.offerid});

  @override
  State<OfferMadeProductDetailScreen> createState() => _OfferMadeProductDetailScreenState(postadid, offerid);
}

class _OfferMadeProductDetailScreenState extends State<OfferMadeProductDetailScreen> {

  String offerid;
  String postadid;
  _OfferMadeProductDetailScreenState(this.postadid, this.offerid);

  bool _loading = false;

  //Detail Information
  String productimage;
  String productname;
  String productqty;
  String description;
  String boostpack;
  String currency;
  String productprice;
  String name;
  String email;
  String address;
  String negotiable;
  String securitydeposit;

  //Offer Detail
  String quantity;
  String period;
  String renttype;
  String productpeice;
  String productsecurity;
  String offerammount;
  String totalrent;
  String totalsecurity;
  String finalamount;
  String startdate;
  String enddate;
  String status;
  String createdAt;
  String renttypeid;

  String commprefs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(postadid);
    print(offerid);
    _getofferdetailproduct();
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
        title: Text("Offer Detail", style: TextStyle(color: kPrimaryColor)),
        centerTitle: true,
      ),
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        color: kPrimaryColor,
        child: SingleChildScrollView(
           child: Padding(
             padding: const EdgeInsets.all(8.0),
             child: _loading == true ? SizedBox() : Column(
               children: [
                 Card(
                   elevation: 4.0,
                   child: Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         const SizedBox(height: 5),
                         const Text("Product Detail", style: TextStyle(color: kPrimaryColor, fontSize: 18, fontWeight: FontWeight.w700)),
                         const SizedBox(height: 10),
                         productimage == null ? Container(
                           height: 180,
                           width: double.infinity,
                           child: Image.asset('assets/images/no_image.jpg'),
                         ) : Container(
                           height: 180,
                           width: double.infinity,
                           child: CachedNetworkImage(
                             imageUrl: sliderpath+productimage,
                             fit: BoxFit.fill,
                             errorWidget: (context, url, error) => Image.asset('assets/images/no_image.jpg', fit: BoxFit.fill),
                           ),
                         ),
                         const SizedBox(height: 10),
                         productname == null ? const SizedBox() : Text(productname, style: const TextStyle(color: kPrimaryColor, fontSize: 14, fontWeight: FontWeight.w700)),
                         boostpack == null ? const SizedBox(height: 0) : const SizedBox(height: 10),
                         boostpack == null ? const SizedBox(height: 0) : Container(
                           height: 30,
                           width: 80,
                           alignment: Alignment.center,
                           decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(8.0),
                               color: Colors.green
                           ),
                           child: const Text("Sponsored", style: TextStyle(color: Colors.white)),
                         ),
                         const SizedBox(height: 10),
                         description == null ? SizedBox() : Text(description, style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400)),
                         const SizedBox(height: 10),
                         productprice == null ? SizedBox() : Text(productprice, style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400)),
                         const SizedBox(height: 10),
                         Text("Security Deposit: INR $securitydeposit", style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400)),
                         const SizedBox(height: 5),
                       ],
                     ),
                   ),
                 ),
                 const SizedBox(height: 10),
                 Card(
                   elevation: 4.0,
                   child: Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         const SizedBox(height: 5.0),
                         const Text("Offer Detail", style: TextStyle(color: kPrimaryColor, fontSize: 18, fontWeight: FontWeight.w700)),
                         const SizedBox(height: 5),
                         const Divider(height: 5, color: kPrimaryColor, thickness: 2),
                         const Text("Offer Info", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500)),
                         const Divider(height: 5, color: kPrimaryColor, thickness: 2),
                         const SizedBox(height: 10),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             const Text("Quantity", style: TextStyle(color: Colors.black, fontSize: 14)),
                             quantity == null || quantity == "" ? const SizedBox() : Text(quantity, style: TextStyle(color: Colors.black, fontSize: 14))
                           ],
                         ),
                         const SizedBox(height: 10),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             const Text("Period", style: TextStyle(color: Colors.black, fontSize: 14)),
                             period == "" || period == null ? const SizedBox() : Text("$period ${_getrenttype(period.toString(), renttype.toString())}", style: TextStyle(color: Colors.black, fontSize: 14)),
                             //Text(period+" "+_getrenttype(renttypeid), style: TextStyle(color: Colors.black, fontSize: 14))
                           ],
                         ),
                         // const SizedBox(height: 10),
                         // Row(
                         //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         //   children: [
                         //     const Text("Rent Type", style: TextStyle(color: Colors.black, fontSize: 14)),
                         //     negotiable.toString() == "1" ? Container(
                         //         height: 20,
                         //         width: 80,
                         //         alignment: Alignment.center,
                         //         decoration: BoxDecoration(
                         //           borderRadius: BorderRadius.circular(8.0),
                         //           color: Colors.green
                         //         ),
                         //       child: Text("Negotiable", style: TextStyle(color: Colors.white)),
                         //     ) : Container(
                         //       height: 20,
                         //       width: 65,
                         //       alignment: Alignment.center,
                         //       decoration: BoxDecoration(
                         //           borderRadius: BorderRadius.circular(8.0),
                         //           color: Colors.green
                         //       ),
                         //       child: const Text("Fixed", style: TextStyle(color: Colors.white)),
                         //     )
                         //   ],
                         // ),
                         const SizedBox(height: 10),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             const Text("Product Price", style: TextStyle(color: Colors.black, fontSize: 14)),
                             productpeice == null ? const SizedBox() : Text(productpeice, style: TextStyle(color: Colors.black, fontSize: 14))
                           ],
                         ),
                         const SizedBox(height: 10),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             const Text("Product Security", style: TextStyle(color: Colors.black, fontSize: 14)),
                             productsecurity == null ? const SizedBox() : Text(productsecurity, style: TextStyle(color: Colors.black, fontSize: 14))
                           ],
                         ),
                         const SizedBox(height: 10),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             const Text("Offer Amount", style: TextStyle(color: Colors.black, fontSize: 14)),
                             offerammount == null ? const SizedBox() : Text(offerammount, style: const TextStyle(color: Colors.black, fontSize: 14))
                           ],
                         ),
                         const SizedBox(height: 10),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             const Text("Total Rent", style: TextStyle(color: Colors.black, fontSize: 14)),
                             totalrent == null ? const SizedBox() : Text(totalrent, style: const TextStyle(color: Colors.black, fontSize: 14))
                           ],
                         ),
                         const SizedBox(height: 10),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             const Text("Total Security", style: TextStyle(color: Colors.black, fontSize: 14)),
                             totalsecurity == null ? const SizedBox(): Text(totalsecurity, style: const TextStyle(color: Colors.black, fontSize: 14))
                           ],
                         ),
                         const SizedBox(height: 10),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             const Text("Final Amount", style: TextStyle(color: Colors.black, fontSize: 14)),
                             finalamount == null ? const SizedBox() : Text(finalamount, style: const TextStyle(color: Colors.black, fontSize: 14))
                           ],
                         ),
                         const SizedBox(height: 10),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             const Text("Start Date", style: TextStyle(color: Colors.black, fontSize: 14)),
                             startdate == null ? const SizedBox() : Text(startdate, style: const TextStyle(color: Colors.black, fontSize: 14))
                           ],
                         ),
                         const SizedBox(height: 10),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             const Text("End Date", style: TextStyle(color: Colors.black, fontSize: 14)),
                             enddate == null ? const SizedBox() : Text(enddate, style: const TextStyle(color: Colors.black, fontSize: 14))
                           ],
                         ),
                         const SizedBox(height: 10),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             const Text("Status", style: TextStyle(color: Colors.black, fontSize: 14)),
                             status == null ? const SizedBox() : Text(_getStatus(status), style: const TextStyle(color: Colors.black, fontSize: 14))
                           ],
                         ),
                         const SizedBox(height: 10),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             const Text("Created At", style: TextStyle(color: Colors.black, fontSize: 14)),
                             createdAt == null ? const SizedBox() : Text(createdAt, style: const TextStyle(color: Colors.black, fontSize: 14))
                           ],
                         ),
                         const SizedBox(height: 10),
                         const Divider(height: 5, color: kPrimaryColor, thickness: 2),
                         const Text("Product Info", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500)),
                         const Divider(height: 5, color: kPrimaryColor, thickness: 2),
                         const SizedBox(height: 10),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             const Text("Security (INR)", style: TextStyle(color: Colors.black, fontSize: 14)),
                             securitydeposit == null ? const SizedBox() : Text(securitydeposit, style: TextStyle(color: Colors.black, fontSize: 14))
                           ],
                         ),
                         const SizedBox(height: 10),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             const Text("Quantity", style: TextStyle(color: Colors.black, fontSize: 14)),
                             productqty == null  || productqty == "null" ? const Text("N/A", style: TextStyle(color: Colors.black, fontSize: 14)) : Text(productqty.toString(), style: TextStyle(color: Colors.black, fontSize: 14))
                           ],
                         ),
                         const SizedBox(height: 10),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             const Text("Currency", style: TextStyle(color: Colors.black, fontSize: 14)),
                             currency == null ? const SizedBox() : Text(currency, style: TextStyle(color: Colors.black, fontSize: 14))
                           ],
                         ),
                         const SizedBox(height: 10),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             const Text("Rent\nPrices", style: TextStyle(color: Colors.black, fontSize: 14)),
                             const SizedBox(width: 4.0),
                             productprice == null ? SizedBox() : Text(productprice, maxLines: 2, style: TextStyle(color: Colors.black, fontSize: 14))
                           ],
                         ),
                         // const SizedBox(height: 10),
                         // Row(
                         //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         //   children: [
                         //     const Text("Rent Type", style: TextStyle(color: Colors.black, fontSize: 14)),
                         //       negotiable.toString() == "1" ? Container(
                         //       height: 20,
                         //       width: 80,
                         //       alignment: Alignment.center,
                         //       decoration: BoxDecoration(
                         //           borderRadius: BorderRadius.circular(8.0),
                         //           color: Colors.green
                         //       ),
                         //       child: Text("Negotiable", style: TextStyle(color: Colors.white)),
                         //     ) : Container(
                         //       height: 20,
                         //       width: 65,
                         //       alignment: Alignment.center,
                         //       decoration: BoxDecoration(
                         //           borderRadius: BorderRadius.circular(8.0),
                         //           color: Colors.green
                         //       ),
                         //       child: Text("Fixed", style: TextStyle(color: Colors.white)),
                         //     )
                         //   ],
                         // ),
                         const SizedBox(height: 10),
                         const Divider(height: 5, color: kPrimaryColor, thickness: 2),
                         const Text("Rentee Information", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500)),
                         const Divider(height: 5, color: kPrimaryColor, thickness: 2),
                         const SizedBox(height: 10),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             const Text("Rentee Name", style: TextStyle(color: Colors.black, fontSize: 14)),
                             name == null ? const SizedBox() : Text(name, style: TextStyle(color: Colors.black, fontSize: 14))
                           ],
                         ),
                         const SizedBox(height: 10),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             const Text("Email", style: TextStyle(color: Colors.black, fontSize: 14)),
                             email == null ? const SizedBox() : Text(email, style: const TextStyle(color: Colors.black, fontSize: 14))
                           ],
                         ),
                         const SizedBox(height: 10),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             const Text("Address", style: TextStyle(color: Colors.black, fontSize: 14)),
                             SizedBox(
                                 width: size.width * 0.60,
                                 child: address == null ? SizedBox() : Text(address, textAlign: TextAlign.end, maxLines: 2, style: TextStyle(color: Colors.black, fontSize: 14))
                             )
                           ],
                         ),
                         const SizedBox(height: 5),
                       ],
                     ),
                   ),
                 )
               ],
             ),
           ),
        )
      ),
    );
  }

  Future<void> _getofferdetailproduct() async{
     SharedPreferences prefs = await SharedPreferences.getInstance();
     setState((){
        _loading = true;
     });
     final body = {"id": postadid, "offer_request_id" : offerid, "userid" : prefs.getString('userid')};
     var response = await http.post(Uri.parse(BASE_URL + offerdetail),
         body: jsonEncode(body),
         headers: {
           "Accept": "application/json",
           'Content-Type': 'application/json'
     });
     setState((){
       _loading = false;
     });
     if (response.statusCode == 200) {
       var data = json.decode(response.body)['Response'];
       setState(() {
         productimage = data['Image']['upload_base_path']+data['Image']['file_name'].toString();
         productname = data['Product Details']['title'].toString();
         final document = parse(data['Product Details']['description'].toString());
         description = parse(document.body.text).documentElement.text.toString();
         boostpack = data['Product Details']['boost_package_status'].toString();
         securitydeposit = data['Product Details']['security'].toString();
         negotiable = data['Product Details']['negotiate'].toString();
         productqty = data['Product Details']['quantity'].toString();
         currency = data['Product Details']['currency'].toString();

         List temp = [];
         data['Product Details']['prices'].forEach((element) {
           if(element['price'] != null){
             temp.add("INR ${element['price']} (${element['rent_type_name']})");
           }
         });

         productprice = temp.join("/").toString();

         //offer detail
         quantity = data['Offer Details']['quantity'].toString();
         period = data['Offer Details']['period'].toString();
         renttype = data['Offer Details']['rent_type_name'].toString();
         productpeice = data['Offer Details']['product_price'].toString();
         productsecurity = data['Offer Details']['product_security'].toString();
         offerammount = data['Offer Details']['renter_amount'].toString();
         totalrent = data['Offer Details']['total_rent'].toString();
         totalsecurity = data['Offer Details']['total_security'].toString();
         finalamount = data['Offer Details']['final_amount'].toString();
         startdate = data['Offer Details']['start_date'].toString();
         enddate = data['Offer Details']['end_date'].toString();
         status = data['Offer Details']['offer_status'].toString();
         renttypeid = data['Offer Details']['rent_type_id'].toString();
         //createdAt = data['Offer Details']['created_at'].toString().split("T")[0].toString();
         createdAt = data['Offer Details']['created_at'].toString();

         //Rentee Detail
         name = data['Advertiser Information']['name'].toString();
         email = data['Advertiser Information']['email'].toString();
         address = "${data['Advertiser Information']['address']}, ${data['Advertiser Information']['city_name']}, ${data['Advertiser Information']['state_name']}, ${data['Advertiser Information']['pincode']}";


       });
     } else {
       throw Exception('Failed to get data due to ${response.body}');
     }
  }

  String _getStatus(String statusvalue) {
    if(statusvalue == "13"){
       return "Complete";
    }
    else if(statusvalue == "1"){
      return "Accepted";
    }
    else if(statusvalue == "3"){
      return "Pending";
    }
    else if(statusvalue == "6"){
      return "Active";
    }
    else if(statusvalue == "4"){
      return "Inactive";
    }
    else if(statusvalue == "2"){
      return "Rejected";
    }
    else{
      return "Approved";
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
    else if(renttypevalue.toLowerCase() == "days"  && period != "1"){
      return "Days";
    }
    else if(renttypevalue.toLowerCase() == "monthly" && period == "1"){
      return "Month";
    }
    else if(renttypevalue.toLowerCase() == "monthly" && period != "1"){
      return "Months";
    }
    else if(renttypevalue.toLowerCase() == "yearly" && period == "1"){
      return "Year";
    }
    else if(renttypevalue.toLowerCase() == "yearly" && period != "1"){
      return "Years";
    }
  }
}
