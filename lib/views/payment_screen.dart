import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rentit4me/network/api.dart';
import 'package:rentit4me/themes/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {

  String searchvalue = " Search";
  List<dynamic> paymentlist = [];

  bool _loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _paymentlist();

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
        title: Text("Payment", style: TextStyle(color: kPrimaryColor)),
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
                          Text("Transactions", style: TextStyle(color: kPrimaryColor, fontSize: 18, fontWeight: FontWeight.w700)),
                          Visibility(visible: _loading, child: Container(height: 24, width: 24, child: CircularProgressIndicator(color: kPrimaryColor , strokeWidth: 2)))
                        ],
                      ),
                      const SizedBox(height: 10),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: const[
                            DataColumn(label: Text('TXN_ID', textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Amount(INR)', textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Pay For', textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Type', textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Status', textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Created Date', textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))),

                          ],
                          rows: paymentlist.map(
                            ((element) => DataRow(
                              cells: <DataCell>[
                                DataCell(Text(element["txn_id"].toString())),
                                DataCell(Text(element["txn_amount"].toString())),
                                DataCell(Text(element["payment_for"].toString())),
                                DataCell(Text(element["type"].toString())),
                                DataCell(Text(element["status"].toString())),
                                DataCell(Text(element["created_at"].toString())),
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

  Future<void> _paymentlist() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _loading = true;
    });
    final body = {
      "id": prefs.getString('userid'),
    };
    var response = await http.post(Uri.parse(BASE_URL + transactions),
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
            paymentlist = jsonDecode(response.body)['Response']['Transactions'];
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
}
