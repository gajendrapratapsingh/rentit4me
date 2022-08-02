import 'dart:io';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rentit4me/network/api.dart';
import 'package:rentit4me/themes/constant.dart';
import 'package:rentit4me/views/dashboard.dart';
import 'package:rentit4me/views/home_screen.dart';
import 'package:rentit4me/views/make_payment_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BankAndBusinessDetailScreen extends StatefulWidget {
  const BankAndBusinessDetailScreen({Key key}) : super(key: key);

  @override
  State<BankAndBusinessDetailScreen> createState() => _BankAndBusinessDetailScreenState();
}

class _BankAndBusinessDetailScreenState extends State<BankAndBusinessDetailScreen> {

  bool _loading = false;

  String usertype;
  String businessname;
  String accounttype;
  List<String> _accounttypelist = ["Saving", "Current"];

  String panno;
  String gstno;
  String adharno;
  String gstdoc;
  String adharcarddoc;
  String pancarddoc;

  //Bank detail
  String bankname;
  String branchname;
  String ifsccode;
  String accountno;

  String package_id;
  String payment_status;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getprofileData();
    //_getcountryData();
  }

  @override
  Widget build(BuildContext context) {
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
        title: const Text("Business Detail", style: TextStyle(color: kPrimaryColor)),
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
                      children: [
                        const Text("Bank Detail", style: TextStyle(color: kPrimaryColor, fontSize: 18, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 20),
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Text("Account Type*", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w500)),
                        ),
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
                                  counterText: ""
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
                  ),
                ),
                SizedBox(height: 20),
                Card(
                  elevation: 4.0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: Column(
                      children: [
                        const Text("Business Detail", style: TextStyle(color: kPrimaryColor, fontSize: 18, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 20),
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Text("Business Name*", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w500)),
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
                                  hintText: businessname,
                                  border: InputBorder.none,
                                ),
                                readOnly: true,
                                onChanged: (value){
                                  setState((){
                                    businessname = value;
                                  });
                                },
                              ),
                            )
                        ),
                        const SizedBox(height: 10),
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Text("GST Number*", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w500)),
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
                                  hintText: gstno,
                                  border: InputBorder.none,
                                ),
                                onChanged: (value){
                                  setState((){
                                    gstno = value;
                                  });
                                },
                              ),
                            )
                        ),
                        const SizedBox(height: 10),
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Text("Pan Number*", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w500)),
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
                                  hintText: panno,
                                  border: InputBorder.none,
                                ),
                                onChanged: (value){
                                  setState((){
                                    panno = value;
                                  });
                                },
                              ),
                            )
                        ),
                        const SizedBox(height: 10),
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Text("Adhar Number*", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w500)),
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
                                  hintText: adharno,
                                  border: InputBorder.none,
                                  counterText: ""
                                ),
                                maxLength: 12,
                                onChanged: (value){
                                  setState((){
                                    adharno = value;
                                  });
                                },
                              ),
                            )
                        ),
                        const SizedBox(height: 10),
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Text("GST*", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w500)),
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
                              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  gstdoc.toString() == "" || gstdoc.toString() == "null" ? SizedBox() : CircleAvatar(
                                    radius: 25,
                                    backgroundImage: FileImage(File(gstdoc)),
                                  ),
                                  /*CircleAvatar(
                                      child: profileimage == null || profileimage == "null" || profileimage == "" ? Image.asset('assets/images/no_image.jpg') : CachedNetworkImage(
                                        imageUrl: profileimage,
                                        errorWidget: (context, url, error) => Icon(Icons.error),
                                      ),
                                    ),*/
                                  InkWell(
                                    onTap: (){
                                       _capturedoc("gst");
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
                        ),
                        const SizedBox(height: 10),
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Text("PAN*", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w500)),
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
                              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  pancarddoc.toString() == "" || pancarddoc.toString() == "null" ? SizedBox() : CircleAvatar(
                                    radius: 25,
                                    backgroundImage: FileImage(File(pancarddoc)),
                                  ),
                                  /*CircleAvatar(
                                      child: profileimage == null || profileimage == "null" || profileimage == "" ? Image.asset('assets/images/no_image.jpg') : CachedNetworkImage(
                                        imageUrl: profileimage,
                                        errorWidget: (context, url, error) => Icon(Icons.error),
                                      ),
                                    ),*/
                                  InkWell(
                                    onTap: (){
                                      _capturedoc("pan");
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
                        ),
                        const SizedBox(height: 10),
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Text("Adhar*", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w500)),
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
                              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  adharcarddoc.toString() == "" || adharcarddoc.toString() == "null" ? SizedBox() : CircleAvatar(
                                    radius: 25,
                                    backgroundImage: FileImage(File(adharcarddoc)),
                                  ),
                                  /*CircleAvatar(
                                      child: profileimage == null || profileimage == "null" || profileimage == "" ? Image.asset('assets/images/no_image.jpg') : CachedNetworkImage(
                                        imageUrl: profileimage,
                                        errorWidget: (context, url, error) => Icon(Icons.error),
                                      ),
                                    ),*/
                                  InkWell(
                                    onTap: (){
                                      _capturedoc("adhar");
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
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){
                    if(accounttype == null || accounttype == "" || accounttype == "Select"){
                      showToast("Please select account type");
                    }
                    else if(bankname == null || bankname == ""){
                      showToast("Please enter bank name");
                    }
                    else if(branchname == null || branchname == ""){
                      showToast('Please enter branch name');
                    }
                    else if(accountno == null || accountno == ""){
                      showToast('Please enter account number');
                    }
                    else if(ifsccode == null || ifsccode == ""){
                      showToast('Please enter ifsc code');
                    }
                    else if(businessname == null || businessname == ""){
                      showToast('Please enter business name');
                    }
                    else if(gstno == null || gstno == ""){
                      showToast('Please enter GST number');
                    }
                    else if(panno == null || panno == ""){
                      showToast('Please enter pan number');
                    }
                    else if(adharno == null || adharno == ""){
                      showToast('Please enter adhar number');
                    }
                    else if(gstdoc == null || gstdoc == ""){
                      showToast('Please upload GST document');
                    }
                    else if(pancarddoc == null || pancarddoc == ""){
                      showToast('Please upload pan document');
                    }
                    else if(adharcarddoc == null || adharcarddoc == ""){
                      showToast('Please upload adhar document');
                    }
                    else{
                      _billingandtaxation();
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

  Future _getprofileData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString('userid'));
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
      setState(() {
        usertype = data['User']['user_type'].toString();
        businessname = data['User']['business_name'].toString();
        package_id = data['User']['package_id'].toString();
        payment_status = data['User']['payment_status'].toString();
      });

    } else {
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  Future _billingandtaxation() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      _loading = true;
    });
    var requestMulti = http.MultipartRequest('POST', Uri.parse(BASE_URL+billingandtaxation));
    requestMulti.fields["id"] = prefs.getString('userid');
    requestMulti.fields["account_type"] = accounttype;
    requestMulti.fields["bank_name"] = bankname;
    requestMulti.fields["branch_name"] = branchname;
    requestMulti.fields["ifsc"] = ifsccode;
    requestMulti.fields["account_no"] = accountno;
    requestMulti.fields["adhaar_no"] = adharno;
    requestMulti.fields["pan_no"] = panno;
    requestMulti.fields["gst_no"] = gstno;

    requestMulti.files.add(await http.MultipartFile.fromPath('gst_doc', gstdoc));
    requestMulti.files.add(await http.MultipartFile.fromPath('pan_doc', pancarddoc));
    requestMulti.files.add(await http.MultipartFile.fromPath('adhaar_doc', adharcarddoc));

    requestMulti.send().then((response) {
      response.stream.toBytes().then((value) {
        try {
          var responseString = String.fromCharCodes(value);
          setState((){
            _loading = false;
          });
          var jsonData = jsonDecode(responseString);
          print("response "+jsonData.toString());
          if (jsonData['ErrorCode'].toString() == "0") {
            if(package_id != null && package_id.toString() != "1") {
              if(payment_status == "1"){
                 Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) =>  Dashboard()));
              }
              else{
                 Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) =>  MakePaymentScreen()));
              }
             }
             else{
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) =>  Dashboard()));
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

  Future<void> _capturedoc(String type) async {
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
                              if(type == "gst"){
                                setState(() {
                                  gstdoc = result.path.toString();
                                });
                              }
                              else if(type == "adhar"){
                                setState(() {
                                  adharcarddoc = result.path.toString();
                                });
                              }
                              else {
                                setState(() {
                                  pancarddoc = result.path.toString();
                                });
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
                              if(type == "gst"){
                                setState(() {
                                  gstdoc = result.path.toString();
                                });
                              }
                              else if(type == "adhar"){
                                setState(() {
                                  adharcarddoc = result.path.toString();
                                });
                              }
                              else {
                                setState(() {
                                  pancarddoc = result.path.toString();
                                });
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
                          label: const Text("Gallery", style: TextStyle(color: Colors.black))),
                    ],
                  )
                ])));
  }


}
