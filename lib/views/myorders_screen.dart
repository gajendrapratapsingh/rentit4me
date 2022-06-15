import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rentit4me/network/api.dart';
import 'package:rentit4me/themes/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({Key key}) : super(key: key);

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {

  String searchvalue = " Search";
  List<dynamic> myorderslist = [];

  bool _progress = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _myorderslist();
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
        title: Text("My Orders", style: TextStyle(color: kPrimaryColor)),
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
                          Text("My Orders", style: TextStyle(color: kPrimaryColor, fontSize: 18, fontWeight: FontWeight.w700)),
                          Visibility(visible: _progress, child: Container(height: 24, width: 24, child: CircularProgressIndicator(color: kPrimaryColor , strokeWidth: 2)))
                        ],
                      ),
                      const SizedBox(height: 10),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: const[
                            DataColumn(label: Text('Order Id', textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Product', textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Quantity', textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Period', textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Rent Type', textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Product Price(INR)', textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Offer Amount(INR)', textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Total Rent(INR)', textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Total Security(INR)', textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Final Amount(INR)', textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Start Date', textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('End Date', textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Created At', textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Status', textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Action', textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))),
                          ],
                          rows: myorderslist.map(
                            ((element) => DataRow(
                              cells: <DataCell>[
                                DataCell(Text(element["order_id"].toString())),
                                DataCell(Text(element["title"].toString())),
                                DataCell(Text(element["quantity"].toString())),
                                _getPeriod(element["period"].toString(), element["rent_type_name"].toString()),
                                DataCell(Text(element["rent_type_name"].toString())),
                                DataCell(Text(element["product_price"].toString())),
                                DataCell(Text(element["renter_amount"].toString())),
                                DataCell(Text(element["total_rent"].toString())),
                                DataCell(Text(element["total_security"].toString())),
                                DataCell(Text(element["final_amount"].toString())),
                                DataCell(Text(element["start_date"].toString())),
                                DataCell(Text(element["end_date"].toString())),
                                DataCell(Text(element["created_at"].toString())),
                                DataCell(Text(element["status"].toString())),
                                element["status"].toString() ==  "delivered" ? DataCell(TextButton( onPressed: (){showDialog(context: context, barrierDismissible: false, builder: (context)=> StatefulBuilder(
                                    builder: (context, setState){
                                      return AlertDialog(title: const Align(
                                        alignment: Alignment.topLeft,
                                        child: Text("Response", style: TextStyle(color: Colors.deepOrangeAccent)),
                                      ),content:
                                      Container(
                                        child: SingleChildScrollView(
                                          child: Column(
                                              children:[
                                                SizedBox(height: 2),
                                                Divider(height: 1, color: Colors.grey, thickness: 1),
                                                SizedBox(height: 25),
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

  Future<void> _myorderslist() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      _progress = true;
    });
    final body = {
      "id": prefs.getString('userid'),
    };
    var response = await http.post(Uri.parse(BASE_URL + myorders),
        body: jsonEncode(body),
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json'
        }
    );
    print(response.body);
    if (response.statusCode == 200) {
      if(jsonDecode(response.body)['ErrorCode'].toString() == "0"){
        setState((){
            myorderslist = jsonDecode(response.body)['Response']['Orders'];
            _progress = false;
        });
      }
      else {
        setState((){
          _progress = false;
        });
        showToast(jsonDecode(response.body)['ErrorMessage'].toString());
      }
    } else {
      setState((){
        _progress = false;
      });
      print(response.body);
      throw Exception('Failed to get data due to ${response.body}');
    }
  }
}
