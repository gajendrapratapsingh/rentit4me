import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rentit4me/network/api.dart';
import 'package:rentit4me/themes/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GenerateTicketScreen extends StatefulWidget {
  const GenerateTicketScreen({Key key}) : super(key: key);

  @override
  State<GenerateTicketScreen> createState() => _GenerateTicketScreenState();
}

class _GenerateTicketScreenState extends State<GenerateTicketScreen> {

  bool _loading = false;

  String title = "Title";
  String message = "Message";

  String initialtype = 'Payment';
  String initialpriority = 'Low';

  // List of items in our dropdown menu
  var typelist = [
    'Payment',
    'Order',
  ];

  var prioritylist = [
     'Low',
     'Medium',
     'High'
  ];

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
        title: Text("Ticket", style: TextStyle(color: kPrimaryColor)),
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
                     padding: const EdgeInsets.all(8.0),
                     child: Column(
                       children: [
                         const Align(
                           alignment: Alignment.topLeft,
                           child: Text("Generate Ticket", style: TextStyle(color: kPrimaryColor, fontSize: 18, fontWeight: FontWeight.w700)),
                         ),
                         const SizedBox(height: 10),
                         const Align(
                             alignment: Alignment.topLeft,
                             child: Text("Title", style: TextStyle(color: kPrimaryColor, fontSize: 14, fontWeight: FontWeight.w500))),
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
                                   hintText: title,
                                   border: InputBorder.none,
                                 ),
                                 onChanged: (value){
                                   setState((){
                                     title = value;
                                   });
                                 },
                               ),
                             )
                         ),
                         SizedBox(height: 10),
                         const Align(
                             alignment: Alignment.topLeft,
                             child: Text("Type", style: TextStyle(color: kPrimaryColor, fontSize: 14, fontWeight: FontWeight.w500))),
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
                               padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                               child: DropdownButtonHideUnderline(
                                 child: DropdownButton(
                                   hint: Text("Select"),
                                   isExpanded: true,
                                   value: initialtype,
                                   icon: const Icon(Icons.arrow_drop_down_sharp),
                                   items: typelist.map((String items) {
                                     return DropdownMenuItem(
                                       value: items,
                                       child: Text(items),
                                     );
                                   }).toList(),
                                   onChanged: (String changevalue) {
                                     setState(() {
                                       initialtype = changevalue;
                                     });
                                   },
                                 ),
                               ),
                             )
                         ),
                         SizedBox(height: 10),
                         const Align(
                             alignment: Alignment.topLeft,
                             child: Text("Priority", style: TextStyle(color: kPrimaryColor, fontSize: 14, fontWeight: FontWeight.w500))),
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
                               padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                               child: DropdownButtonHideUnderline(
                                 child: DropdownButton(
                                   hint: Text("Select"),
                                   isExpanded: true,
                                   value: initialpriority,
                                   icon: const Icon(Icons.arrow_drop_down_sharp),
                                   items: prioritylist.map((String items) {
                                     return DropdownMenuItem(
                                       value: items,
                                       child: Text(items),
                                     );
                                   }).toList(),
                                   onChanged: (String changevalue) {
                                     setState(() {
                                       initialpriority = changevalue;
                                     });
                                   },
                                 ),
                               ),
                             )
                         ),
                         SizedBox(height: 10),
                         const Align(
                             alignment: Alignment.topLeft,
                             child: Text("Message", style: TextStyle(color: kPrimaryColor, fontSize: 14, fontWeight: FontWeight.w500))),
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
                                 maxLines: 2,
                                 decoration: InputDecoration(
                                   hintText: message,
                                   border: InputBorder.none,
                                 ),
                                 onChanged: (value){
                                   setState((){
                                     message = value;
                                   });
                                 },
                               ),
                             )
                         ),
                       ],
                     ),
                   ),
                 ),
                 SizedBox(height: 10),
                 InkWell(
                   onTap: () {
                     _generateticket();
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
                       child: Text("Create", style: TextStyle(color: Colors.white)),
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

  Future<void> _generateticket() async{
     SharedPreferences prefs = await SharedPreferences.getInstance();
     setState((){
       _loading = true;
     });
     final body = {
       "id": prefs.getString('userid'),
       "type" : initialtype,
       "title" : title,
       "priority" : initialpriority,
       "message" : message
     };
     var response = await http.post(Uri.parse(BASE_URL + generateticket),
         body: jsonEncode(body),
         headers: {
           "Accept": "application/json",
           'Content-Type': 'application/json'
         }
     );
     print(response.body);
     if(jsonDecode(response.body)['ErrorCode'].toString() == "0"){
       setState((){
         _loading = false;
       });
       showToast(jsonDecode(response.body)['ErrorMessage'].toString());
       //prefs.setString('userid', jsonDecode(response.body)['Response']['id'].toString());
       //prefs.setBool('logged_in', true);
       //Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) =>  SelectMemberShipScreen()));
     }
  }
}
