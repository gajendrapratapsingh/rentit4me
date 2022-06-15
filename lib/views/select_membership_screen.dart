import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rentit4me/network/api.dart';
import 'package:rentit4me/themes/constant.dart';
import 'package:rentit4me/views/home_screen.dart';
import 'package:rentit4me/views/personal_detail_screen.dart';
import 'package:rentit4me/views/user_detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectMemberShipScreen extends StatefulWidget {
  const SelectMemberShipScreen({Key key}) : super(key: key);

  @override
  _SelectMemberShipScreenState createState() => _SelectMemberShipScreenState();
}

class _SelectMemberShipScreenState extends State<SelectMemberShipScreen> {

  List<dynamic> membershipplanlist = [];
  bool _loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getmembershipplan();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2.0,
        leading: Padding(
          padding: EdgeInsets.only(left: 10),
          child: Image.asset('assets/images/logo.png'),
        ),
        title: Text("Membership", style: TextStyle(color: kPrimaryColor)),
        centerTitle: true,
        /*actions: [
          IconButton(onPressed:(){}, icon: Icon(Icons.edit, color: kPrimaryColor)),
          IconButton(onPressed:(){}, icon: Icon(Icons.account_circle, color: kPrimaryColor)),
          IconButton(onPressed:(){}, icon: Icon(Icons.menu, color: kPrimaryColor))
        ],*/
      ),
       body: ModalProgressHUD(
         inAsyncCall: _loading,
         child: Padding(
           padding: EdgeInsets.all(7.0),
           child: membershipplanlist.isEmpty || membershipplanlist.length == 0 ? const Center(
             child: CircularProgressIndicator(),
           ) : ListView.separated(
             itemCount: membershipplanlist.length,
             shrinkWrap: true,
             scrollDirection: Axis.vertical,
             separatorBuilder: (BuildContext context, int index) => const Divider(height: 10, thickness: 0, color: Colors.white),
             itemBuilder: (BuildContext context, int index) {
               return Container(
                 height: 260,
                 width: double.infinity,
                 child: Card(
                   elevation: 8.0,
                   shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(16.0),
                   ),
                   child: Column(
                     children: [
                       const SizedBox(height: 10),
                       Text(membershipplanlist[index]['name'].toString(), style: TextStyle(color: kPrimaryColor, fontSize: 21, fontWeight: FontWeight.w500)),
                       const SizedBox(height: 10),
                       Container(
                         height: 80,
                         width: double.infinity,
                         decoration: const BoxDecoration(
                             color: Colors.deepOrangeAccent
                         ),
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             Text(membershipplanlist[index]['amount'].toString(), style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w700)),
                             const Text("/", style: TextStyle(color: Colors.white, fontSize: 16)),
                             const Text("month", style: TextStyle(color: Colors.white, fontSize: 16))
                           ],
                         ),
                       ),
                       const SizedBox(height: 5.0),
                       const Text("Ad Duration", style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 14)),
                       const SizedBox(height: 5.0),
                       Text(membershipplanlist[index]['ad_duration'].toString(), style: TextStyle(color: Colors.black, fontSize: 14)),
                       const SizedBox(height: 5.0),
                       const Text("Ad Limit", style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 14)),
                       Text(membershipplanlist[index]['ad_limit'].toString(), style: TextStyle(color: Colors.black, fontSize: 14)),
                       const SizedBox(height: 5.0),
                       InkWell(
                         onTap: (){
                           _selectmembership(membershipplanlist[index]['id'].toString());
                         },
                         child: Container(
                           width: size.width * 0.25,
                           height: 35,
                           alignment: AlignmentDirectional.center,
                           decoration: const BoxDecoration(
                               color: kPrimaryColor,
                               borderRadius: BorderRadius.all(Radius.circular(8.0))
                           ),
                           child: Text("Get Plan", style: TextStyle(color: Colors.white, fontSize: 14)),
                         ),
                       )
                     ],
                   ),
                 ),
               );
             },
           ),
         ),
       ),
    );
  }

  Future _getmembershipplan() async {
    var response = await http.get(Uri.parse(BASE_URL+getmembership));
    print(response.body);
    if (response.statusCode == 200) {
       setState(() {
           membershipplanlist.addAll(json.decode(response.body)['Response']);
       });
    } else {
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  Future _selectmembership(String membershipid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _loading = true;
    });
    final body = {
      "id": prefs.getString('userid'),
      "package_id" : membershipid
    };
    var response = await http.post(Uri.parse(BASE_URL + selectmembership),
        body: jsonEncode(body),
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json'
        }
    );
    if (response.statusCode == 200) {
      setState(() {
        _loading = false;
      });
      print(response.body);
      if(jsonDecode(response.body)['ErrorCode'].toString() == "0"){
        showToast(jsonDecode(response.body)['ErrorMessage'].toString());
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => PersonalDetailScreen()));
      }
      else {
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
