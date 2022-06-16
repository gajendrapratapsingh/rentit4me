import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rentit4me/network/api.dart';
import 'package:rentit4me/themes/constant.dart';
import 'package:rentit4me/views/business_detail_screen.dart';
import 'package:rentit4me/views/home_screen.dart';
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
  List<String> _countrydata = [];
  String initialcountryname;
  String country_id;

  List<dynamic> statelistData = [];
  List<String> _statedata = [];
  String initialstatename;
  String state_id;

  List<dynamic> citylistData = [];
  List<String> _citydata = [];
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

  String commpref, kyc, trustbadge;

  //Bank detail
  String bankname= "";
  String branchname = "";
  String ifsccode = "";
  String accounttype = "";
  String acoountno = "";

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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2.0,
        leading: Padding(
          padding: EdgeInsets.only(left: 10),
          child: Image.asset('assets/images/logo.png'),
        ),
        title: Text("Personal Detail", style: TextStyle(color: kPrimaryColor)),
        centerTitle: true,
        /*actions: [
          IconButton(onPressed:(){}, icon: Icon(Icons.edit, color: kPrimaryColor)),
          IconButton(onPressed:(){}, icon: Icon(Icons.account_circle, color: kPrimaryColor)),
          IconButton(onPressed:(){}, icon: Icon(Icons.menu, color: kPrimaryColor))
        ],*/
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
                                  hint: Text("Select Country", style: TextStyle(color: Colors.black)),
                                  value: initialcountryname,
                                  elevation: 16,
                                  isExpanded: true,
                                  style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
                                  onChanged: (String data) {
                                    setState(() {
                                      countrylistData.forEach((element) {
                                        if(element['name'].toString() == data.toString()){
                                          initialcountryname = data.toString();
                                          country_id = element['id'].toString();
                                          _getStateData(country_id);
                                        }
                                      });
                                    });
                                  },
                                  items: _countrydata.map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            )
                        ),
                        SizedBox(height: 10),
                        Text("State*", style: TextStyle(color: kPrimaryColor, fontSize: 16, fontWeight: FontWeight.w500)),
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
                                  elevation: 16,
                                  isExpanded: true,
                                  hint: Text("Select State", style: TextStyle(color: Colors.black, fontSize: 16)),
                                  items: _statedata.map((String item) => DropdownMenuItem<String>(child: Text(item), value: item)).toList(),
                                  onChanged: (String value) {
                                    setState(() {
                                      this.initialstatename = value;
                                      statelistData.forEach((element) {
                                        if(element['name'].toString() == value.toString()){
                                          state_id = element['id'].toString();
                                          _getCityData(state_id);
                                        }
                                      });
                                    });
                                  },
                                  value: initialstatename,
                                ),
                              ),
                            )
                        ),
                        SizedBox(height: 10),
                        Text("City*", style: TextStyle(color: kPrimaryColor, fontSize: 16, fontWeight: FontWeight.w500)),
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
                                  hint: Text("Select City", style: TextStyle(color: Colors.black)),
                                  value: initialcityname,
                                  elevation: 16,
                                  isExpanded: true,
                                  style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
                                  onChanged: (String data) {
                                    setState(() {
                                      citylistData.forEach((element) {
                                        if(element['name'].toString() == data.toString()){
                                          initialcityname = data.toString();
                                          city_id = element['id'].toString();
                                        }
                                      });
                                    });
                                  },
                                  items: _citydata.map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            )
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
                                    if(_emailcheck){
                                      emailvalue = 1;
                                      commpref = "1,";
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
                                    if(_smscheck){
                                      smsvalue = 2;
                                      commpref = "2,";
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
                                  decoration: InputDecoration(
                                    hintText: acoountno,
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (value){
                                    setState((){
                                      acoountno = value;
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
                                padding: const EdgeInsets.only(left: 10.0),
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: accounttype,
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (value){
                                    setState((){
                                      accounttype = value;
                                    });
                                  },
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
                      _personaldetailupdatewithdoc(country_id, state_id, city_id, address, commpref, kyc, trustbadge);
                    }
                    else{
                      _personaldetailupdatewithoutdoc(country_id, state_id, city_id, address, commpref, kyc, trustbadge);
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

  Future _getcountryData() async{
    var response = await http.get(Uri.parse(BASE_URL + getCountries),
        headers: {
          "Accept" : "application/json",
          'Content-Type' : 'application/json'
        }
    );
    print(response.body);
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body)['Response']['countries'];
      setState(() {
        countrylistData.addAll(list);
        countrylistData.forEach((element) {
          _countrydata.add(element['name'].toString());
        });
      });
    } else {
      print(response.body);
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  Future _getStateData(String id) async{
    print("country id "+id);
    statelistData.clear();
    _statedata.clear();
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
        statelistData.addAll(list);
        statelistData.forEach((element) {
          _statedata.add(element['name'].toString());
        });
      });
    } else {
      print(response.body);
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  Future _getCityData(String id) async{
    print("state id "+id);
    citylistData.clear();
    _citydata.clear();
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
    //print(response.body);
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body)['Response']['cities'];
      print(list);
      setState(() {
        citylistData.addAll(list);
        citylistData.forEach((element) {
          _citydata.add(element['name'].toString());
        });
      });
    } else {
      print(response.body);
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  Future _personaldetailupdatewithdoc(String countryid, String stateid, String cityid, String address, String commpref, String kyc, String trustbadge) async{
    //print("with doc"+ adharcarddoc);
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
    requestMulti.fields["account_no"] = acoountno;
    requestMulti.fields["adhaar_no"] = adharnum;

    requestMulti.files.add(await http.MultipartFile.fromPath('adhaar_doc', '/data/user/0/com.example.rentit4me/cache/scaled_image_picker2196264881771538336.jpg'));

    //requestMulti.files.add(await http.MultipartFile.fromPath('adhaar_doc', adharcarddoc));

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
               Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) =>  HomeScreen()));
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
    //requestMulti.fields["id"] = "846";
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
    requestMulti.fields["account_no"] = acoountno;
    //requestMulti.fields["adhaar_no"] = adharnum;

    //requestMulti.files.add(await http.MultipartFile.fromPath('adhaar_doc', adharcarddoc));

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
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) =>  HomeScreen()));
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
}
