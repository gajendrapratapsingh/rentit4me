import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rentit4me/themes/constant.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:quickblox_sdk/auth/module.dart';
import 'package:quickblox_sdk/chat/constants.dart';
import 'package:quickblox_sdk/models/qb_dialog.dart';
import 'package:quickblox_sdk/models/qb_session.dart';
import 'package:quickblox_sdk/models/qb_user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rentit4me/network/api.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';
import 'package:rentit4me/views/conversation.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _loading = false;
  String query_id;


  var userlist = [];

  String appId = "96417";
  String authKey = "BmYxKrbn3HDthbc";
  String authSecret = "XRfs7bw3Y9H4yMc";
  String accountKey = "hr2cuVsMyCZXsZMEE32H";

  void init() async {
    setState((){
       _loading = true;
    });
    try {
      print("init calling");
      await QB.settings.init(appId, authKey, authSecret, accountKey);
      mylogin();
    } on PlatformException catch (e) {
      print(e);
      // Some error occurred, look at the exception message for more details
    }
  }

  void mylogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      print("mylogin calling");
      QBLoginResult result = await QB.auth.login(prefs.getString('quicklogin'), prefs.getString('quickpassword'));
      //_connectnow();
      _getchatUsers();
    } on PlatformException catch (e) {
      // Some error occurred, look at the exception message for more details
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //_getchatUsers();
    init();
    //getUsers();
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
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
        title: Text("Chat", style: TextStyle(color: kPrimaryColor)),
        centerTitle: true,
      ),
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        color: kPrimaryColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                  child: ListView.separated(
                    itemCount: userlist.length,
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap:() async{
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          userlist[index]['occupants_ids'].forEach((element){
                              if(element.toString() != prefs.getString('quickid')){
                                  setState((){
                                      query_id = element.toString();
                                  });
                              }
                          });
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Conversation(query_id: query_id)));
                        },
                        child: Container(
                           width: double.infinity,
                           child: Padding(
                               padding: EdgeInsets.all(8.0),
                               child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                     Container(
                                       height : 45,
                                       width: 45,
                                       alignment: Alignment.center,
                                       decoration: const BoxDecoration(
                                         borderRadius: BorderRadius.all(Radius.circular(22.0)),
                                         color: kPrimaryColor
                                         //color: Colors.primaries[_random.nextInt(Colors.primaries.length)][_random.nextInt(9) * 100] == Colors.white ? Colors.red: Colors.primaries[_random.nextInt(Colors.primaries.length)][_random.nextInt(9) * 100],
                                       ),
                                       child: Text(userlist[index]['name'].toString()[0].toUpperCase(), style: TextStyle(color: Colors.white, fontSize: 18)),
                                     ),
                                     SizedBox(width: 8.0),
                                     Expanded(
                                         child: Column(
                                           crossAxisAlignment: CrossAxisAlignment.start,
                                           children: [
                                              Text(userlist[index]['name'].toString(), style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
                                              SizedBox(height: 5.0),
                                              userlist[index]['last_message'] == null ? SizedBox() : Text(userlist[index]['last_message'].toString(), style: TextStyle(color: Colors.black))
                                           ],
                                         )
                                     ),
                                     SizedBox(width: 3.0),
                                     userlist[index]['created_at'] == null ? SizedBox() : Text(userlist[index]['created_at'].toString().split('T')[0].toString(), style: TextStyle(color: Colors.black))
                                  ],
                               ),
                           ),
                        ),
                      );
                    },
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Future _getchatUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
       _loading = true;
    });
    final body = {"chat_user_id": prefs.getString('quickid')};
    var response = await http.post(Uri.parse(BASE_URL + chatuserlist),
        body: jsonEncode(body),
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json'
    });
    print(response.body);
    setState((){
      _loading = false;
    });
    if(response.statusCode == 200) {
      var data = json.decode(response.body)['Response'];
      setState(() {
           userlist.addAll(data['items']);
      });
    } else {
      throw Exception('Failed to get data due to ${response.body}');
    }
  }
}
