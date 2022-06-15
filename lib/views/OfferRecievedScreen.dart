import 'package:flutter/material.dart';
import 'package:rentit4me/network/api.dart';
import 'package:rentit4me/themes/constant.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OfferRecievedScreen extends StatefulWidget {
  const OfferRecievedScreen({Key key}) : super(key: key);

  @override
  State<OfferRecievedScreen> createState() => _OfferRecievedScreenState();
}

class _OfferRecievedScreenState extends State<OfferRecievedScreen> {

  String searchvalue = " Search";
  List<dynamic> offerrecievedlist = [];

  List<String> responselist = ['Accept', 'Reject'];
  String responsevalue;
  String response;

  bool _loading = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _offerrecievedlist();
    /*Future<ProfileResponse> temp = _getprofile();
    print(temp);
    temp.then((value) {
      setState(() {
        //profileimage = value.avatarBaseUrl.toString()+value.avatarPath.toString();
        name = value.username.toString();
        mobile = value.mobile.toString();
        email = value.email.toString();
        address = value.address.toString();
        print(profileimage);
      });
    });*/
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
        title: Text("Offer Recieved", style: TextStyle(color: kPrimaryColor)),
        centerTitle: true,
        /*actions: [
          IconButton(onPressed:(){}, icon: Icon(Icons.edit, color: kPrimaryColor)),
          IconButton(onPressed:(){}, icon: Icon(Icons.account_circle, color: kPrimaryColor)),
          IconButton(onPressed:(){}, icon: Icon(Icons.menu, color: kPrimaryColor))
        ],*/
      ),
      body: SingleChildScrollView(
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
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text("Filter", style: TextStyle(color: kPrimaryColor, fontSize: 18, fontWeight: FontWeight.w700)),
                      ),
                      const SizedBox(height: 10),
                      const Align(
                          alignment: Alignment.topLeft,
                          child: Text("Search", style: TextStyle(color: kPrimaryColor, fontSize: 14, fontWeight: FontWeight.w500))),
                      SizedBox(height: 10),
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
                                hintText: searchvalue,
                                border: InputBorder.none,
                              ),
                              onChanged: (value){
                                setState((){
                                  searchvalue = value;
                                });
                              },
                            ),
                          )
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("From Date", style: TextStyle(color: kPrimaryColor, fontSize: 14, fontWeight: FontWeight.w500)),
                              SizedBox(height: 10),
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
                                        Text("From Date", style: TextStyle(color: Colors.grey)),
                                        IconButton(onPressed: (){}, icon: Icon(Icons.calendar_today_sharp, size: 16, color: kPrimaryColor))
                                      ],
                                    ),
                                  )
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("To Date", style: TextStyle(color: kPrimaryColor, fontSize: 14, fontWeight: FontWeight.w500)),
                              SizedBox(height: 10),
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
                                        Text("To Date", style: TextStyle(color: Colors.grey)),
                                        IconButton(onPressed: (){}, icon: Icon(Icons.calendar_today_sharp, size: 16, color: kPrimaryColor))
                                      ],
                                    ),
                                  )
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          //_generateticket();
                        },
                        child: Card(
                          elevation: 8.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Container(
                            height: 45,
                            width: double.infinity,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                                color: Colors.deepOrangeAccent,
                                borderRadius: BorderRadius.all(Radius.circular(8.0))
                            ),
                            child: Text("Filter", style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Card(
                elevation: 4.0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Offer Recieved", style: TextStyle(color: kPrimaryColor, fontSize: 18, fontWeight: FontWeight.w700)),
                          Visibility(visible: _loading, child: Container(height: 24, width: 24, child: CircularProgressIndicator(color: kPrimaryColor , strokeWidth: 2)))
                        ],
                      ),
                      const SizedBox(height: 10),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: const[
                            DataColumn(label: Text('Renter', textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Product', textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Quantity', textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Period', textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Rent Type', textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Product Price(XCD)', textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Offer Amount(XCD)', textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Total Rent(XCD)', textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Total Security(XCD)', textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Final Amount(XCD)', textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Renew Date', textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Start Date', textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('End Date', textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Created At', textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Status', textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Action', textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))),
                          ],
                          rows: offerrecievedlist.map(
                            ((element) => DataRow(
                              cells: <DataCell>[
                                DataCell(Text(element["name"].toString())),
                                DataCell(Text(element["title"].toString())),
                                DataCell(Text(element["quantity"].toString())),
                                _getPeriod(element["period"].toString(), element["rent_type_name"].toString()),
                                DataCell(Text(element["rent_type_name"].toString())),
                                DataCell(Text(element["product_price"].toString())),
                                DataCell(Text(element["renter_amount"].toString())),
                                DataCell(Text(element["total_rent"].toString())),
                                DataCell(Text(element["total_security"].toString())),
                                DataCell(Text(element["final_amount"].toString())),
                                DataCell(Text(element["renew_date"].toString())),
                                DataCell(Text(element["start_date"].toString())),
                                DataCell(Text(element["end_date"].toString())),
                                DataCell(Text(element["created_at"].toString())),
                                _getstatus(element["offer_status"].toString()),
                                element["offer_status"].toString() ==  "3" ? DataCell(TextButton( onPressed: (){showDialog(context: context, barrierDismissible: false, builder: (context)=> StatefulBuilder(
                                    builder: (context, setState){
                                      return AlertDialog(title: const Align(
                                        alignment: Alignment.topLeft,
                                        child: Text("Response", style: TextStyle(color: Colors.deepOrangeAccent)),
                                      ),content:
                                      Container(
                                        child: SingleChildScrollView(
                                          child: Column(
                                              children:[
                                                DropdownButtonHideUnderline(
                                                  child: DropdownButton<String>(
                                                    hint: Text("Select", style: TextStyle(color: Colors.black, fontSize: 18)),
                                                    value: response,
                                                    elevation: 16,
                                                    isExpanded: true,
                                                    style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
                                                    onChanged: (String data) {
                                                      setState(() {
                                                        if(data.toString() == "Reject"){
                                                          responsevalue = "2";
                                                          response = data.toString();
                                                        }
                                                        else{
                                                          responsevalue = "1";
                                                          response = data.toString();
                                                        }
                                                      });
                                                    },
                                                    items: responselist.map<DropdownMenuItem<String>>((String value) {
                                                      return DropdownMenuItem<String>(
                                                        value: value,
                                                        child: Text(value),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ),
                                                SizedBox(height: 2),
                                                Divider(height: 1, color: Colors.grey, thickness: 1),
                                                SizedBox(height: 25),
                                                InkWell(
                                                  onTap: () {
                                                    if(responsevalue == null || responsevalue == "" || responsevalue == "null"){
                                                       showToast("Please select your response");
                                                    }
                                                    else{
                                                      print(element['user_id'].toString());
                                                      print(element['post_ad_id'].toString());
                                                      print(responsevalue);
                                                      _offeraction(element['post_ad_id'].toString(), responsevalue, element['user_id'].toString());
                                                    }
                                                  },
                                                  child: Container(
                                                    height: 45,
                                                    width: double.infinity,
                                                    alignment: Alignment.center,
                                                    decoration: const BoxDecoration(
                                                        color: Colors.deepOrangeAccent,
                                                        borderRadius: BorderRadius.all(Radius.circular(8.0))
                                                    ),
                                                    child: Text("Submit", style: TextStyle(color: Colors.white)),
                                                  ),
                                                )
                                              ]
                                          ),
                                        ),
                                      )
                                      );
                                    }
                                ));}, child: Text("Respond"))) : DataCell(Padding(padding: EdgeInsets.only(left: 20), child: Text("NA"))),
                              ],
                            )),
                          ).toList(),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  DataCell _getstatus(String statusvalue){
    if(statusvalue == "3"){
      return DataCell(Text("Pending"));
    }
    else if(statusvalue == "13"){
      return DataCell(Text("Completed"));
    }
    else if(statusvalue == "2"){
      return DataCell(Text("Rejected"));
    }
    else{
      return DataCell(Text("Accepted"));
    }
  }

  Future<void> _offerrecievedlist() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _loading = true;
    });
    final body = {
      "user_id": prefs.getString('userid'),
    };
    var response = await http.post(Uri.parse(BASE_URL + offerrecieve),
        body: jsonEncode(body),
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json'
        }
    );
    print(response.body);
    if (response.statusCode == 200) {
      setState(() {
         _loading = false;
       });
      if(jsonDecode(response.body)['ErrorCode'].toString() == "0"){
        setState((){
          offerrecievedlist = jsonDecode(response.body)['Response']['data'];
          _loading = false;
        });
      }
      else {
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

  Future<void> _offeraction(String postid, String offerstatus, String userid) async{
     SharedPreferences prefs = await SharedPreferences.getInstance();
     final body = {
       "post_ad_id" : postid,
       "user_id" : userid,
       "offer_status" : offerstatus
     };
     var response = await http.post(Uri.parse(BASE_URL + offeraction),
         body: jsonEncode(body),
         headers: {
           "Accept": "application/json",
           'Content-Type': 'application/json'
         }
     );
     print(response.body);
     if (response.statusCode == 200) {
       if(jsonDecode(response.body)['ErrorCode'].toString() == "0"){
         showToast(jsonDecode(response.body)['Response'].toString());
         Navigator.pop(context);
         _offerrecievedlist();
       }
       else {
         showToast(jsonDecode(response.body)['ErrorMessage'].toString());
       }
     } else {
       print(response.body);
       throw Exception('Failed to get data due to ${response.body}');
     }
  }

  DataCell _getPeriod(String period, String type) {
    if(type == "hourly"){
      if(period == "1"){
        return DataCell(Text(period+" "+"Hour"));
      }
      else{
        return DataCell(Text(period+" "+"Hours"));
      }
    }
    else if(type == "yearly"){
      if(period == "1"){
        return DataCell(Text(period+" "+"Year"));
      }
      else{
        return DataCell(Text(period+" "+"Years"));
      }
    }
    else if(type == "monthly"){
      if(period == "1"){
        return DataCell(Text(period+" "+"Month"));
      }
      else{
        return DataCell(Text(period+" "+"Months"));
      }
    }
    else{
      if(period == "1"){
        return DataCell(Text(period+" "+"Day"));
      }
      else{
        return DataCell(Text(period+" "+"Days"));
      }
    }
  }
}
