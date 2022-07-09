import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:dropdown_search/dropdown_search.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rentit4me/network/api.dart';
import 'package:rentit4me/themes/constant.dart';
import 'package:rentit4me/views/business_detail_screen.dart';
import 'package:rentit4me/views/home_screen.dart';
import 'package:rentit4me/views/make_payment_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersonalDetailScreen extends StatefulWidget {
  const PersonalDetailScreen({Key key}) : super(key: key);

  @override
  State<PersonalDetailScreen> createState() => _PersonalDetailScreenState();
}

class _PersonalDetailScreenState extends State<PersonalDetailScreen> {

  bool _loading = false;

  String usertype;

  List<dynamic> countrylistData = [];
  String initialcountryname;
  String country_id;

  List<dynamic> statelistData = [];
  String initialstatename;
  String state_id;

  List<dynamic> citylistData = [];
  String initialcityname;
  String city_id;

  String initialkyc;
  List<String> _kycdata = ["Yes", "No"];
  String initialtrustedbadge;
  List<String> _badgedata = ["Yes", "No"];

  String adharcarddoc = "";
  String address;
  String adharnum;

  bool _emailcheck = false;
  bool _smscheck = false;
  int _hidemobile = 0;
  bool _hidemob = false;

  int emailvalue;
  int smsvalue;

  String kyc, trustbadge;

  List<int> commprefs = [];

  List<String> _accounttypelist = ["Saving", "Current"];

  String selectedCountry = "Select Country";
  String selectedState = "Select State";
  String selectedCity = "Select City";

  //Bank detail
  String bankname = "";
  String branchname = "";
  String ifsccode = "";
  String accounttype;
  String accountno = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getcheckapproveData();
    _getcountryData();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
        title: Text("Personal Detail", style: TextStyle(color: kPrimaryColor)),
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
                        Text("Country*", style: TextStyle(color: kPrimaryColor, fontSize: 16, fontWeight: FontWeight.w500)),
                        SizedBox(height: 8.0),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
                          child: DropdownSearch(
                            selectedItem: selectedCountry,
                            mode: Mode.DIALOG,
                            showSelectedItem: true,
                            autoFocusSearchBox: true,
                            showSearchBox: true,
                            hint: 'Select Country',
                            dropdownSearchDecoration:  InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.deepOrangeAccent,width: 1)

                                ),
                                contentPadding: EdgeInsets.only(left: 10)),
                            items: countrylistData.map((e) {
                              return e['name'].toString();
                            }).toList(),
                            onChanged: (value) {
                               if(value!="Select Country")
                               {
                                 countrylistData.forEach((element) {
                                 if(element['name'].toString()==value){
                                  setState(() {
                                    initialcountryname = value.toString();
                                    initialstatename = null;
                                    initialcityname = null;
                                    country_id = element['id'].toString();
                                    _getStateData(element['id'].toString());
                                  });
                                }
                              });
                             }else{
                               showToast("Select Country");
                              }
                            },
                          ),
                        ),
                        // Container(
                        //     decoration: BoxDecoration(
                        //         border: Border.all(
                        //             width: 1,
                        //             color: Colors.deepOrangeAccent
                        //         ),
                        //         borderRadius: BorderRadius.all(Radius.circular(12))
                        //     ),
                        //     child: Padding(
                        //       padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        //       child: DropdownButtonHideUnderline(
                        //         child: DropdownButton<String>(
                        //           hint: Text("Select Country", style: TextStyle(color: Colors.black)),
                        //           value: initialcountryname,
                        //           elevation: 16,
                        //           isExpanded: true,
                        //           style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
                        //           onChanged: (String data) {
                        //             setState(() {
                        //               initialcountryname = data.toString();
                        //               initialstatename = null;
                        //               initialcityname = null;
                        //               country_id = data.toString();
                        //               _getStateData(data);
                        //             });
                        //           },
                        //           items: countrylistData.map((items) {
                        //             return DropdownMenuItem<String>(
                        //               value: items['id'].toString(),
                        //               child: Text(items['name']),
                        //             );
                        //           }).toList(),
                        //         ),
                        //       ),
                        //     )
                        // ),
                        SizedBox(height: 10),
                        Text("State*", style: TextStyle(color: kPrimaryColor, fontSize: 16, fontWeight: FontWeight.w500)),
                        SizedBox(height: 8.0),
                        DropdownSearch(
                          selectedItem: selectedState,
                          mode: Mode.DIALOG,
                          showSelectedItem: true,
                          autoFocusSearchBox: true,
                          showSearchBox: true,
                          hint: 'Select State',
                          dropdownSearchDecoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.deepOrangeAccent,width: 1)),
                                contentPadding: EdgeInsets.only(left: 10)),
                          items: statelistData.map((e) {
                            return e['name'].toString();
                          }).toList(),
                          onChanged: (value) {
                            if(value!="Select State")
                            {
                                statelistData.forEach((element) {
                                if(element['name'].toString()==value){
                                  setState(() {
                                     initialstatename = value.toString();
                                     initialstatename = null;
                                     initialcityname = null;
                                     state_id = element['id'].toString();
                                    _getCityData(element['id'].toString());
                                  });
                                }
                              });
                            }else{
                              showToast("Select State");
                            }
                          },
                        ),
                        // Container(
                        //     decoration: BoxDecoration(
                        //         border: Border.all(
                        //             width: 1,
                        //             color: Colors.deepOrangeAccent
                        //         ),
                        //         borderRadius: BorderRadius.all(Radius.circular(12))
                        //     ),
                        //     child: Padding(
                        //       padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        //       child: DropdownButtonHideUnderline(
                        //         child: DropdownButton<String>(
                        //           elevation: 16,
                        //           isExpanded: true,
                        //           hint: Text("Select State", style: TextStyle(color: Colors.black, fontSize: 16)),
                        //           items: statelistData.map((items) {
                        //             return DropdownMenuItem<String>(
                        //               value: items['id'].toString(),
                        //               child: Text(items['name']),
                        //             );
                        //           }).toList(),
                        //           onChanged: (String data) {
                        //             setState(() {
                        //               initialstatename = data.toString();
                        //               initialcityname = null;
                        //               state_id = data.toString();
                        //               _getCityData(state_id);
                        //             });
                        //           },
                        //           value: initialstatename,
                        //         ),
                        //       ),
                        //     )
                        // ),
                        SizedBox(height: 10),
                        Text("City*", style: TextStyle(color: kPrimaryColor, fontSize: 16, fontWeight: FontWeight.w500)),
                        SizedBox(height: 8.0),
                        // Container(
                        //     decoration: BoxDecoration(
                        //         border: Border.all(
                        //             width: 1,
                        //             color: Colors.deepOrangeAccent
                        //         ),
                        //         borderRadius: BorderRadius.all(Radius.circular(12))
                        //     ),
                        //     child: Padding(
                        //       padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        //       child: DropdownButtonHideUnderline(
                        //         child: DropdownButton<String>(
                        //           hint: Text("Select City", style: TextStyle(color: Colors.black)),
                        //           value: initialcityname,
                        //           elevation: 16,
                        //           isExpanded: true,
                        //           style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
                        //           onChanged: (String data) {
                        //             setState(() {
                        //               initialcityname = data.toString();
                        //               city_id = data.toString();
                        //             });
                        //           },
                        //           items: citylistData.map((items) {
                        //             return DropdownMenuItem<String>(
                        //               value: items['id'].toString(),
                        //               child: Text(items['name']),
                        //             );
                        //           }).toList(),
                        //         ),
                        //       ),
                        //     )
                        // ),
                        DropdownSearch(
                          selectedItem: selectedCity,
                          mode: Mode.DIALOG,
                          showSelectedItem: true,
                          autoFocusSearchBox: true,
                          showSearchBox: true,
                          hint: 'Select City',
                          dropdownSearchDecoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.deepOrangeAccent,width: 1)),
                              contentPadding: EdgeInsets.only(left: 10)),
                          items: citylistData.map((e) {
                            return e['name'].toString();
                          }).toList(),
                          onChanged: (value) {
                            if(value!="Select City")
                            {
                              citylistData.forEach((element) {
                                if(element['name'].toString()==value){
                                  setState(() {
                                    initialcityname = value.toString();
                                    //initialstatename = null;
                                    //initialcityname = null;
                                    city_id = element['id'].toString();
                                    //_getStateData(element['id'].toString());
                                  });
                                }
                              });
                            }else{
                              showToast("Select Country");
                            }
                          },
                        ),
                        SizedBox(height: 10),
                        Text("Address*", style: TextStyle(color: kPrimaryColor, fontSize: 16, fontWeight: FontWeight.w500)),
                        SizedBox(height: 8.0),
                        Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1,
                                    color: Colors.deepOrangeAccent
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(12))
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: address,
                                  border: InputBorder.none,
                                  suffixIcon: IconButton(onPressed: (){
                                    if(address == null || address == ""){
                                      _determinePosition().then((value) => _getAddress(value));
                                    }
                                  }, icon: Icon(Icons.my_location, color: address == null ? Colors.deepOrangeAccent : Colors.grey))
                                ),
                                onChanged: (value){
                                  setState((){
                                     address = value;
                                  });
                                },
                              ),
                            )
                        ),
                        SizedBox(height: 10),
                        Text("Communication Preferences*", style: TextStyle(color: kPrimaryColor, fontSize: 16, fontWeight: FontWeight.w500)),
                        SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Checkbox(value: _emailcheck, onChanged: (value){
                                  setState(() {
                                    _emailcheck = value;
                                    if(_emailcheck) {
                                      commprefs.add(1);
                                    }
                                    else{
                                      commprefs.forEach((element) {
                                        if(element == 1){
                                          commprefs.removeWhere((element) => element == 1);
                                        }
                                      });
                                    }
                                  });
                                }),
                                Text("Email", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w700))
                              ],
                            ),
                            SizedBox(width: 20),
                            Row(
                              children: [
                                Checkbox(value: _smscheck, onChanged: (value){
                                  setState(() {
                                    _smscheck = value;
                                    if(_smscheck) {
                                      commprefs.add(2);
                                    }
                                    else{
                                      commprefs.forEach((element) {
                                        if(element == 2){
                                          commprefs.removeWhere((element) => element == 2);
                                        }
                                      });
                                    }
                                  });
                                }),
                                Text("SMS", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w700))
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        Text("Kyc*", style: TextStyle(color: kPrimaryColor, fontSize: 16, fontWeight: FontWeight.w500)),
                        SizedBox(height: 8.0),
                        Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1,
                                    color: Colors.deepOrangeAccent
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(12))
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  hint: Text("Select", style: TextStyle(color: Colors.black)),
                                  value: initialkyc,
                                  elevation: 16,
                                  isExpanded: true,
                                  style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
                                  onChanged: (String data) {
                                    setState(() {
                                       initialkyc = data;
                                       if(initialkyc == "Yes"){
                                         kyc = "1";
                                       }
                                       else{
                                         kyc = "0";
                                       }
                                    });
                                  },
                                  items: _kycdata.map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            )
                        ),
                        SizedBox(height: 10.0),
                        Text("Trusted Badge*", style: TextStyle(color: kPrimaryColor, fontSize: 16, fontWeight: FontWeight.w500)),
                        SizedBox(height: 8.0),
                        Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1,
                                    color: Colors.deepOrangeAccent
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(12))
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  hint: Text("Select", style: TextStyle(color: Colors.black)),
                                  value: initialtrustedbadge,
                                  elevation: 16,
                                  isExpanded: true,
                                  style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
                                  onChanged: (String data) {
                                    setState(() {
                                      initialtrustedbadge = data;
                                      if(initialtrustedbadge == "Yes"){
                                        trustbadge = "1";
                                      }
                                      else{
                                        trustbadge = "0";
                                      }
                                    });
                                  },
                                  items: _badgedata.map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            )
                        ),
                        initialkyc == "Yes"  && usertype == "3" ? SizedBox(height: 10) : SizedBox(),
                        initialkyc == "Yes"  && usertype == "3" ? Text("Adhar Number", style: TextStyle(color: kPrimaryColor, fontSize: 16, fontWeight: FontWeight.w500)) : SizedBox(),
                        initialkyc == "Yes"  && usertype == "3" ? SizedBox(height: 8.0) : SizedBox(),
                        initialkyc == "Yes"  && usertype == "3" ? Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1,
                                    color: Colors.deepOrangeAccent
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(12))
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: adharnum,
                                  border: InputBorder.none,
                                ),
                                onChanged: (value){
                                  setState((){
                                    adharnum = value;
                                  });
                                },
                              ),
                            )
                        ) : SizedBox(),
                        initialkyc == "Yes"  && usertype == "3" ? SizedBox(height: 10) : SizedBox(),
                        initialkyc == "Yes"  && usertype == "3" ? Text("Adhar Card", style: TextStyle(color: kPrimaryColor, fontSize: 16, fontWeight: FontWeight.w500)) : SizedBox(),
                        initialkyc == "Yes"  && usertype == "3" ? SizedBox(height: 8.0) : SizedBox(),
                        initialkyc == "Yes"  && usertype == "3" ? Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1,
                                    color: Colors.deepOrangeAccent
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(12))
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  adharcarddoc.toString() == "" || adharcarddoc.toString() == "null" ? SizedBox() : CircleAvatar(
                                    radius: 25,
                                    backgroundImage: FileImage(File(adharcarddoc)),
                                  ),
                                  InkWell(
                                    onTap: (){
                                      _captureadharcard();
                                    },
                                    child: Container(
                                      height: 45,
                                      width: 120,
                                      alignment: Alignment.center,
                                      decoration: const BoxDecoration(
                                          color: Colors.deepOrangeAccent,
                                          borderRadius: BorderRadius.all(Radius.circular(8.0))
                                      ),
                                      child: Text("Choose file", style: TextStyle(color: Colors.white, fontSize: 16)),
                                    ),
                                  )
                                ],
                              ),
                            )
                        ) : SizedBox(),
                      ],
                    ),
                  ),
                ),
                usertype == "3" ? SizedBox(height: 10) : SizedBox(),
                usertype == "3" ? Card(
                  elevation: 4.0,
                  child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      child: Column(
                        children: [
                           const Text("Bank Detail", style: TextStyle(color: kPrimaryColor, fontSize: 18, fontWeight: FontWeight.w700)),
                           const SizedBox(height: 10),
                           const Align(
                            alignment: Alignment.topLeft,
                            child: Text("Bank Name*", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w500)),
                           ),
                           const SizedBox(height: 8),
                           Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1,
                                      color: Colors.deepOrangeAccent
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(12))
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: bankname,
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (value){
                                    setState((){
                                      bankname = value;
                                    });
                                  },
                                ),
                              )
                          ),
                           const SizedBox(height: 10),
                           const Align(
                            alignment: Alignment.topLeft,
                            child: Text("Branch Name*", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w500)),
                           ),
                           const SizedBox(height: 8),
                           Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1,
                                      color: Colors.deepOrangeAccent
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(12))
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: branchname,
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (value){
                                    setState((){
                                      branchname = value;
                                    });
                                  },
                                ),
                              )
                          ),
                          const SizedBox(height: 10),
                          const Align(
                            alignment: Alignment.topLeft,
                            child: Text("Account Number*", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w500)),
                          ),
                          const SizedBox(height: 8),
                          Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1,
                                      color: Colors.deepOrangeAccent
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(12))
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: accountno,
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (value){
                                    setState((){
                                      accountno = value;
                                    });
                                    },
                                ),
                              )
                          ),
                          const SizedBox(height: 10),
                          const Align(
                            alignment: Alignment.topLeft,
                            child: Text("Account Type*", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w500)),
                          ),
                          const SizedBox(height: 8),
                          Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1,
                                      color: Colors.deepOrangeAccent
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(12))
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    hint: Text("Select", style: TextStyle(color: Colors.black)),
                                    value: accounttype,
                                    elevation: 16,
                                    isExpanded: true,
                                    style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
                                    onChanged: (String data) {
                                      setState(() {
                                        accounttype = data;
                                      });
                                    },
                                    items: _accounttypelist.map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              )
                          ),
                          const SizedBox(height: 10),
                          const Align(
                            alignment: Alignment.topLeft,
                            child: Text("IFSC Code*", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w500)),
                          ),
                          const SizedBox(height: 8),
                          Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1,
                                      color: Colors.deepOrangeAccent
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(12))
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: ifsccode,
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (value){
                                    setState((){
                                       ifsccode = value;
                                    });
                                  },
                                ),
                              )
                          ),
                        ],
                      ),
                  )
                ) : SizedBox(),
                SizedBox(height: 10),
                InkWell(
                  onTap: (){
                    if(kyc == "1" && usertype == "3"){
                      if(country_id == null || country_id == ""){
                        showToast("Please select your country");
                      }
                      else if(state_id == null || state_id == ""){
                        showToast("Please select your state");
                      }
                      else if(city_id == null || city_id == ""){
                        showToast("Please select your city");
                      }
                      else if(address == null || address == ""){
                        showToast("Please enter your address");
                      }
                      else if(commprefs.isEmpty || commprefs.length == 0){
                        showToast("Please check one communication preference");
                      }
                      else if(kyc == null || kyc == "" || kyc == "Select"){
                        showToast("Please select kyc");
                      }
                      else if(trustbadge == null || trustbadge == "" || trustbadge == "Select"){
                        showToast("Please select trusted Badge");
                      }
                      // else if(bankname == null || bankname == ""){
                      //   showToast("Please enter bank name");
                      // }
                      // else if(branchname == null || bankname == ""){
                      //   showToast("Please enter bank name");
                      // }
                      // else if(accountno == null || accountno == ""){
                      //   showToast('Please enter account number');
                      // }
                      // else if(ifsccode == null || ifsccode == ""){
                      //   showToast('Please enter ifsc code');
                      // }
                      else{
                        _personaldetailupdatewithdoc(country_id, state_id, city_id, address, commprefs.join(","), kyc, trustbadge);
                      }
                    }
                    else{
                      if(country_id == null || country_id == ""){
                        showToast("Please select your country");
                      }
                      else if(state_id == null || state_id == ""){
                        showToast("Please select your state");
                      }
                      else if(city_id == null || city_id == ""){
                        showToast("Please select your city");
                      }
                      else if(address == null || address == ""){
                        showToast("Please enter your address");
                      }
                      else if(commprefs.isEmpty || commprefs.length == 0){
                        showToast("Please check one communication preference");
                      }
                      else if(kyc == null || kyc == "" || kyc == "Select"){
                        showToast("Please select kyc");
                      }
                      else if(trustbadge == null || trustbadge == "" || trustbadge == "Select"){
                        showToast("Please select trusted Badge");
                      }
                      else{
                        _personaldetailupdatewithoutdoc(country_id, state_id, city_id, address, commprefs.join(","), kyc, trustbadge);
                      }
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    child: Card(
                      elevation: 12.0,
                      color: Colors.deepOrangeAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                        child: Text("CONTINUE", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 16)),
                      ),
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

  Future _getcheckapproveData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final body = {
       "user_id": prefs.getString('userid'),
    };
    var response = await http.post(Uri.parse(BASE_URL + checkapprove),
        body: jsonEncode(body),
        headers: {
          "Accept" : "application/json",
          'Content-Type' : 'application/json'
        }
    );
    print(response.body);
    print(prefs.getString('userid'));
    if (response.statusCode == 200) {
      var data = json.decode(response.body)['Response'];
      setState(() {
         usertype = data['user_type'].toString();
      });

    } else {
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  Future _getprofileData() async{
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
    if (response.statusCode == 200) {
      var data = json.decode(response.body)['Response'];
      if(data['User']['package_id'] != null && data['User']['package_id'] != 1){
         if(data['User']['payment_status'].toString() == "1"){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) =>  HomeScreen()));
         }
         else{
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) =>  MakePaymentScreen()));
         }
      }
      else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) =>  HomeScreen()));
      }

    } else {
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  Future _getcountryData() async{
    setState((){
      _loading=true;
    });
    var response = await http.get(Uri.parse(BASE_URL + getCountries),
        headers: {
          "Accept" : "application/json",
          'Content-Type' : 'application/json'
        }
    );
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body)['Response']['countries'];
      setState(() {
        countrylistData.add({
          "name": "Select",
          "id": 0
        });
        countrylistData.addAll(list);
        _loading=false;

      });
    } else {
      print(response.body);
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  Future _getStateData(String id) async{
    setState((){
       _loading = true;
       statelistData.clear();
    });
    final body = {
      "id": int.parse(id),
    };
    var response = await http.post(Uri.parse(BASE_URL + getState),
        body: jsonEncode(body),
        headers: {
          "Accept" : "application/json",
          'Content-Type' : 'application/json'
        }
    );
    //print(response.body);
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body)['Response']['states'];
      print(list);
      setState(() {
        _loading = false;
        statelistData.addAll(list);
      });
    } else {
      print(response.body);
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  Future _getCityData(String id) async{
    setState((){
      _loading = true;
      citylistData.clear();
    });
    final body = {
      "id": int.parse(id),
    };
    var response = await http.post(Uri.parse(BASE_URL + getCity),
        body: jsonEncode(body),
        headers: {
          "Accept" : "application/json",
          'Content-Type' : 'application/json'
        }
    );
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body)['Response']['cities'];
      setState(() {
        _loading = false;
        citylistData.addAll(list);
      });
    } else {
      print(response.body);
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  Future _personaldetailupdatewithdoc(String countryid, String stateid, String cityid, String address, String commpref, String kyc, String trustbadge) async{
    print("with doc"+ adharcarddoc);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      _loading = true;
    });
    print("0 "+prefs.getString('userid'));
    print("5 "+address);
    print("7 "+commpref);
    print("8 "+kyc);
    print("9 "+trustbadge);
    print("country id "+country_id);
    print("state id "+state_id);
    print("city id "+city_id);

    var requestMulti = http.MultipartRequest('POST', Uri.parse(BASE_URL+personalupdate));
    requestMulti.fields["id"] = prefs.getString('userid');
    requestMulti.fields["address"] = address;
    requestMulti.fields["country"] = country_id;
    requestMulti.fields["state"] = state_id;
    requestMulti.fields["city"] = city_id;
    requestMulti.fields["kyc"] = kyc;
    requestMulti.fields["com_prefs"] = commpref;
    requestMulti.fields["trusted_badge"] = trustbadge;
    requestMulti.fields["account_type"] = accounttype;
    requestMulti.fields["bank_name"] = bankname;
    requestMulti.fields["branch_name"] = branchname;
    requestMulti.fields["ifsc"] = ifsccode;
    requestMulti.fields["account_no"] = accountno;
    requestMulti.fields["adhaar_no"] = adharnum;

    //requestMulti.files.add(await http.MultipartFile.fromPath('adhaar_doc', '/data/user/0/com.rent.renteeforme/cache/scaled_image_picker2196264881771538336.jpg'));

    requestMulti.files.add(await http.MultipartFile.fromPath('adhaar_doc', adharcarddoc));

    requestMulti.send().then((response) {
      response.stream.toBytes().then((value) {
        try {
          var responseString = String.fromCharCodes(value);
          setState((){
            _loading = false;
          });
          var jsonData = jsonDecode(responseString);
          if (jsonData['ErrorCode'].toString() == "0") {
             if(jsonData['Response']['user_type'].toString() == "3"){
                _getprofileData();
             }
             else{
               Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) =>  BankAndBusinessDetailScreen()));
             }
          } else {
            showToast(jsonData['Response'].toString());
          }
        } catch (e) {
          setState((){
            _loading = false;
          });
        }
      });
    });
  }

  Future _personaldetailupdatewithoutdoc(String countryid, String stateid, String cityid, String address, String commpref, String kyc, String trustbadge) async{
    print("Without doc");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      _loading = true;
    });

    final body = {
         "id" : prefs.getString('userid'),
         "address" : address,
         "country" : country_id,
         "state" : state_id,
         "city" : city_id,
         "kyc" :  kyc,
         "com_prefs" : commpref,
         "trusted_badge" : trustbadge,
         "account_type" : accounttype,
         "bank_name" : bankname,
         "branch_name" : branchname,
         "ifsc" : ifsccode,
         "account_no" : accountno
    };
    var response = await http.post(Uri.parse(BASE_URL + personalupdate),
        body: jsonEncode(body),
        headers: {
          "Accept" : "application/json",
          'Content-Type' : 'application/json'
        }
    );
    print(response.body);
    if (response.statusCode == 200) {
      if(json.decode(response.body)['Response']['user_type'].toString() == "3"){
        _getprofileData();
        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) =>  HomeScreen()));
      }
      else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) =>  BankAndBusinessDetailScreen()));
      }
    } else {
      setState(() {
        _loading = false;
      });
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  Future<void> _captureadharcard() async {
    final ImagePicker _picker = ImagePicker();
    await showModalBottomSheet(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
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
                              setState(() {
                                adharcarddoc = result.path.toString();
                              });
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
                          label: const Text("Camera", style: TextStyle(color: Colors.black))),
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
                              setState(() {
                                adharcarddoc = result.path.toString();
                              });
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
                          label: const Text("Gallery", style: TextStyle(color: Colors.black))),
                    ],
                  )
                ])));
  }

  Future<Position> _determinePosition() async {
    setState((){
       _loading = true;
    });
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<void> _getAddress(value) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(value.latitude, value.longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    setState(() {
      _loading = false;
      address = place.subLocality.toString() +
          "," +
          place.locality.toString() +
          "," +
          place.postalCode.toString() +
          "," +
          place.administrativeArea.toString() +
          "," +
          place.country.toString();
    });
  }

}
