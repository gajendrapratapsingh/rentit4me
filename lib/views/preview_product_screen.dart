import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:rentit4me/themes/constant.dart';
import 'package:rentit4me/network/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreviewProductScreen extends StatefulWidget {
  String productid;
  PreviewProductScreen({this.productid});

  @override
  State<PreviewProductScreen> createState() => _PreviewProductScreenState(productid);
}

class _PreviewProductScreenState extends State<PreviewProductScreen> {

  String productid;
  _PreviewProductScreenState(this.productid);

  bool _checkData = false;

  String productname;
  String productimage;
  String boostpack;
  String description;
  String renttype;
  String negotiate;
  String productprice;
  String securitydeposit;
  String addedby;
  String address;
  String email;

  String mobile;
  String mobile_hidden;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getpreproductDetail(productid);
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
        title: const Text("Preview", style: TextStyle(color: kPrimaryColor)),
        centerTitle: true,
      ),
      body: _checkData == false
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          child: Column(
            children: [
              productimage == null ? Container(
                height: 120,
                width: double.infinity,
                child: Image.asset('assets/images/no_image.jpg'),
              ) : Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: kPrimaryColor, width: 1)
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: CachedNetworkImage(
                    imageUrl: "https://dev.techstreet.in/rentit4me/public/assets/frontend/images/listings/"+productimage,
                    fit: BoxFit.fill,
                    errorWidget: (context, url, error) => Image.asset('assets/images/no_image.jpg', fit: BoxFit.fill),
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              Align(
                  alignment: Alignment.topLeft,
                  child: productname == "null" ||
                      productname == null ||
                      productname == ""
                      ? SizedBox()
                      : Text(productname,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold))),
              const SizedBox(height: 4.0),
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
                      child: Text("Sponsored", style: TextStyle(color: Colors.black, fontSize: 16))
                  )
              ),
              const SizedBox(height: 15.0),
              Align(
                  alignment: Alignment.topLeft,
                  child: description == "" ||
                      description == "null" ||
                      description == null
                      ? SizedBox()
                      : Text(description,
                      style: const TextStyle(color: Colors.black, fontSize: 12))),
              const SizedBox(height: 35.0),
              Align(
                  alignment: Alignment.topLeft,
                  child: renttype == null ||
                      renttype == "" ||
                      renttype == "null"
                      ? Text("$productprice",
                      style: const TextStyle(
                          color: kPrimaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500))
                      : Text("INR $productprice $renttype",
                      style: const TextStyle(
                          color: kPrimaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500))),
              const SizedBox(height: 15.0),
              Align(
                  alignment: Alignment.topLeft,
                  child: Text("Security Deposit : INR $securitydeposit",
                      style: const TextStyle(color: kPrimaryColor, fontSize: 16, fontWeight: FontWeight.w500))),
              const SizedBox(height: 15.0),
              Align(
                  alignment: Alignment.topLeft,
                  child: Text("Added By : $addedby",
                      style: const TextStyle(
                          color: kPrimaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500))),
              const SizedBox(height: 35.0),
              const SizedBox(height: 40),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Address : ", style: TextStyle(color: kPrimaryColor, fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(
                    width: size.width * 0.70,
                    child: Text("$address", maxLines: 2, style: const TextStyle(color: kPrimaryColor, fontSize: 18)),
                  )
                ],
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Price : ",
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  SizedBox(
                    width: size.width * 0.70,
                    child: negotiate == "0" ? const Text("Fixed", maxLines: 2, style: TextStyle(color: kPrimaryColor, fontSize: 18)) : const Text("Negotiable", maxLines: 2, style: TextStyle(color: kPrimaryColor, fontSize: 18)),
                  )
                ],
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Email : ",
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  SizedBox(
                    width: size.width * 0.70,
                    child: Text("$email",
                        maxLines: 1,
                        style: const TextStyle(color: kPrimaryColor, fontSize: 18)),
                  )
                ],
              ),
              mobile_hidden == "1" ? SizedBox() : SizedBox(height: 20),
              mobile_hidden == "1" ? SizedBox() : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Mobile : ",
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  SizedBox(
                    width: size.width * 0.70,
                    child: Text("$mobile",
                        maxLines: 1,
                        style: const TextStyle(color: kPrimaryColor, fontSize: 18)),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future _getpreproductDetail(String productid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final body = {"id": productid, "userid": prefs.getString('userid')};
    var response = await http.post(Uri.parse(BASE_URL + previewpost),
        body: jsonEncode(body),
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json'
    });
    if (response.statusCode == 200) {
      var data = json.decode(response.body)['Response'];
      setState(() {
        productimage = data['Images'][0]['file_name'].toString();
        productname = data['posted_ad']['title'].toString();
        final document = parse(data['posted_ad']['description'].toString());
        description = parse(document.body.text).documentElement.text.toString();
        boostpack = data['posted_ad']['boost_package_status'].toString();
        renttype = data['posted_ad']['rent_type'].toString();

        List temp = [];
        data['Pricing'].forEach((element) {
          if(element['price'] != null){
            temp.add("INR "+element['price'].toString()+" ("+element['rent_type_name'].toString()+")");
          }
        });

        productprice = temp.join("/").toString();
        negotiate = data['posted_ad']['negotiate'].toString();

        securitydeposit = data['posted_ad']['security'].toString();
        addedby = data['Additional']['added-by']['name'].toString();
        address = data['Additional']['added-by']['address'].toString()+", "+data['Additional']['added-by']['city_name'].toString()+", "+data['Additional']['added-by']['state_name'].toString()+", "+data['Additional']['added-by']['pincode'].toString()+", "+data['Additional']['added-by']['country_name'].toString();

        email = data['posted_ad']['email'].toString();
        mobile = data['posted_ad']['mobile'].toString();
        mobile_hidden = data['posted_ad']['mobile_hidden'].toString();

        _checkData = true;
      });
    } else {
      throw Exception('Failed to get data due to ${response.body}');
    }
  }
}
