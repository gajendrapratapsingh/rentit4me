import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rentit4me/network/api.dart';
import 'package:rentit4me/themes/constant.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserDetailScreen extends StatefulWidget {
  const UserDetailScreen({Key key}) : super(key: key);

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {

  bool _loading = false;
  String productimage = 'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80';

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

  String profileimage;
  String name;
  String email;
  String mobile;
  String myads;
  String address;
  String pincode;
  String membership;

  String fburl;
  String twitterurl;
  String youtubeurl;
  String googleplusurl;
  String instragramurl;
  String linkdinurl;

  bool _emailcheck = false;
  bool _smscheck = false;
  int _hidemobile = 0;
  bool _hidemob = false;

  int emailvalue;
  int smsvalue;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getprofileData();
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
        title: Text("Profile", style: TextStyle(color: kPrimaryColor)),
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
                   elevation: 2.0,
                   shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(25.0),
                   ),
                   child: Padding(
                     padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 8.0),
                     child: Row(
                       children: [
                         CircleAvatar(
                           child: ClipRRect(
                             borderRadius: BorderRadius.all(Radius.circular(8.0)),
                             child: Image.network(productimage, fit: BoxFit.fill),
                           ),
                         ),
                         SizedBox(width: 10),
                         Expanded(
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [
                                 Text("Hi! $name", style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 16, fontWeight: FontWeight.w500)),
                                 membership == "" || membership == null || membership == "null" ? SizedBox() : Text("Membership: $membership", style: TextStyle(color: kPrimaryColor, fontSize: 16))
                               ],
                             )
                         ),
                         Row(
                           children: [
                             Column(
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [
                                 Text("$myads", style: TextStyle(color: kPrimaryColor, fontSize: 16, fontWeight: FontWeight.w500)),
                                 Text("My Ads", style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 16))
                               ],
                             ),

                           ],
                         )
                       ],
                     ),
                   ),
                 ),
                 SizedBox(height: 20),
                 Card(
                   elevation: 4.0,
                   child: Padding(
                     padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8.0),
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text("Email*", style: TextStyle(color: kPrimaryColor, fontSize: 16, fontWeight: FontWeight.w500)),
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
                               padding: EdgeInsets.only(left: 8.0),
                               child: TextField(
                                 readOnly: true,
                                 decoration: InputDecoration(
                                   hintText: email,
                                   border: InputBorder.none,
                                 ),
                               ),
                             )
                         ),
                         SizedBox(height: 10),
                         Text("Phone Number*", style: TextStyle(color: kPrimaryColor, fontSize: 16, fontWeight: FontWeight.w500)),
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
                               padding: EdgeInsets.only(left: 8.0),
                               child: TextField(
                                 readOnly: true,
                                 decoration: InputDecoration(
                                   hintText: mobile,
                                   border: InputBorder.none,
                                 ),
                               ),
                             )
                         ),
                         SizedBox(height: 10.0),
                         Row(
                           children: [
                              Text("Hide Mobile", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold)),
                              SizedBox(width: 10),
                              Checkbox(value: _hidemob, onChanged: (value){
                                if(value){
                                  setState(() {
                                    _hidemob = value;
                                    _hidemobile = 1;
                                  });
                                }
                                else{
                                  setState((){
                                    _hidemob = value;
                                    _hidemobile = 0;
                                  });
                                }
                              })
                           ],
                         )
                       ],
                     ),
                   ),
                 ),
                 SizedBox(height: 20),
                 Card(
                   elevation: 4.0,
                   child: Padding(
                     padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8.0),
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Align(
                           alignment: Alignment.center,
                           child: Text("Basic Detail", style: TextStyle(color: kPrimaryColor, fontSize: 21, fontWeight: FontWeight.w700)),
                         ),
                         SizedBox(height: 10),
                         Text("Full Name", style: TextStyle(color: kPrimaryColor, fontSize: 16, fontWeight: FontWeight.w500)),
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
                               padding: EdgeInsets.only(left: 8.0),
                               child: TextField(
                                 decoration: InputDecoration(
                                   hintText: name,
                                   border: InputBorder.none,
                                 ),
                                 onChanged: (value){
                                   setState(() {
                                     name = value;
                                   });
                                 },
                               ),
                             )
                         ),
                         SizedBox(height: 10),
                         Text("Picture", style: TextStyle(color: kPrimaryColor, fontSize: 16, fontWeight: FontWeight.w500)),
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
                               padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
                               child: Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: [
                                   profileimage.toString() == "" || profileimage.toString() == "null" ? SizedBox() : CircleAvatar(
                                     radius: 25,
                                     backgroundImage: FileImage(File(profileimage)),
                                    ),
                                    /*CircleAvatar(
                                      child: profileimage == null || profileimage == "null" || profileimage == "" ? Image.asset('assets/images/no_image.jpg') : CachedNetworkImage(
                                        imageUrl: profileimage,
                                        errorWidget: (context, url, error) => Icon(Icons.error),
                                      ),
                                    ),*/
                                    InkWell(
                                      onTap: (){
                                        showPhotoCaptureOptions();
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
                 SizedBox(height: 20),
                 Card(
                   elevation: 4.0,
                   child: Padding(
                     padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8.0),
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Align(
                           alignment: Alignment.center,
                           child: Text("Social Network", style: TextStyle(color: kPrimaryColor, fontSize: 21, fontWeight: FontWeight.w700)),
                         ),
                         SizedBox(height: 10),
                         Text("Facebook", style: TextStyle(color: kPrimaryColor, fontSize: 16, fontWeight: FontWeight.w500)),
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
                               padding: EdgeInsets.only(left: 8.0),
                               child: TextField(
                                 decoration: InputDecoration(
                                   hintText: fburl == null || fburl == "null" || fburl == "" ? "" : fburl,
                                   border: InputBorder.none,
                                 ),
                                 onChanged: (value){
                                   setState(() {
                                      fburl = value;
                                   });
                                 },
                               ),
                             )
                         ),
                         SizedBox(height: 10),
                         Text("Twitter", style: TextStyle(color: kPrimaryColor, fontSize: 16, fontWeight: FontWeight.w500)),
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
                               padding: EdgeInsets.only(left: 8.0),
                               child: TextField(
                                 decoration: InputDecoration(
                                   hintText: twitterurl == null || twitterurl == "null" || twitterurl == "" ? "" : twitterurl,
                                   border: InputBorder.none,
                                 ),
                                 onChanged: (value){
                                   setState(() {
                                     twitterurl = value;
                                   });
                                 },
                               ),
                             )
                         ),
                         SizedBox(height: 10),
                         Text("Google+", style: TextStyle(color: kPrimaryColor, fontSize: 16, fontWeight: FontWeight.w500)),
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
                               padding: EdgeInsets.only(left: 8.0),
                               child: TextField(
                                 decoration: InputDecoration(
                                   hintText: googleplusurl == null || googleplusurl == "null" || googleplusurl == "" ? "" : googleplusurl,
                                   border: InputBorder.none,
                                 ),
                                 onChanged: (value){
                                   setState(() {
                                     googleplusurl = value;
                                   });
                                 },
                               ),
                             )
                         ),
                         SizedBox(height: 10),
                         Text("Instagram", style: TextStyle(color: kPrimaryColor, fontSize: 16, fontWeight: FontWeight.w500)),
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
                               padding: EdgeInsets.only(left: 8.0),
                               child: TextField(
                                 decoration: InputDecoration(
                                   hintText: instragramurl == null || instragramurl == "null" || instragramurl == "" ? "" : instragramurl,
                                   border: InputBorder.none,
                                 ),
                                 onChanged: (value){
                                   setState(() {
                                     instragramurl = value;
                                   });
                                 },
                               ),
                             )
                         ),
                         SizedBox(height: 10),
                         Text("Linkedin", style: TextStyle(color: kPrimaryColor, fontSize: 16, fontWeight: FontWeight.w500)),
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
                               padding: EdgeInsets.only(left: 8.0),
                               child: TextField(
                                 decoration: InputDecoration(
                                   hintText: linkdinurl == null || linkdinurl == "null" || linkdinurl == "" ? "" : linkdinurl,
                                   border: InputBorder.none,
                                 ),
                               ),
                             )
                         ),
                         SizedBox(height: 10),
                         Text("Youtube", style: TextStyle(color: kPrimaryColor, fontSize: 16, fontWeight: FontWeight.w500)),
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
                               padding: EdgeInsets.only(left: 8.0),
                               child: TextField(
                                 decoration: InputDecoration(
                                   hintText: youtubeurl == null || youtubeurl == "null" || youtubeurl == "" ? "" : youtubeurl,
                                   border: InputBorder.none,
                                 ),
                                 onChanged: (value){
                                   setState(() {
                                     youtubeurl = value;
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
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Align(
                           alignment: Alignment.center,
                           child: Text("Setting", style: TextStyle(color: kPrimaryColor, fontSize: 21, fontWeight: FontWeight.w700)),
                         ),
                         SizedBox(height: 10),
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
                         Text("State", style: TextStyle(color: kPrimaryColor, fontSize: 16, fontWeight: FontWeight.w500)),
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
                         Text("Address", style: TextStyle(color: kPrimaryColor, fontSize: 16, fontWeight: FontWeight.w500)),
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
                               ),
                             )
                         ),
                         SizedBox(height: 10),
                         Text("Pincode", style: TextStyle(color: kPrimaryColor, fontSize: 16, fontWeight: FontWeight.w500)),
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
                                   hintText: pincode == null || pincode == "null" || pincode == "" ? "" : pincode,
                                   border: InputBorder.none,
                                 ),
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
                                     }
                                   });
                                 }),
                                 Text("SMS", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w700))
                               ],
                             ),
                           ],
                         )
                       ],
                     ),
                   ),
                 ),
                 SizedBox(height: 10),
                 InkWell(
                   onTap: (){
                     _basicdetailupdate(name, profileimage, fburl, twitterurl, googleplusurl, instragramurl,
                         linkdinurl, youtubeurl, categoryUrl, state_id, city_id, address, pincode);
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
                         child: Text("UPDATE", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 16)),
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

  Widget textField(TextEditingController controller) => Column(
    children: [
      TextFormField(
        validator: (value) {
          if (value.isEmpty)
            return "Required Field";
          else
            return null;
        },
        maxLines: 3,
        controller: controller,
        textCapitalization: TextCapitalization.words,
        decoration: const InputDecoration(
            contentPadding: EdgeInsets.all(12),
            border: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffD0D5DD))),
            fillColor: Colors.white,
            isDense: true,
            filled: true
        ),
      ),
      SizedBox(
        height: 10,
      )
    ],
  );

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
       setState(() {
         profileimage = data['User']['avatar_base_url'].toString()+data['User']['avatar_path'].toString();
         myads = data['My Ads'].toString();
         mobile = data['User']['mobile'].toString();
         name = data['User']['name'].toString();
         email = data['User']['email'].toString();
         address = data['User']['address'].toString();
         fburl = data['User']['facebook_url'].toString();
         googleplusurl = data['User']['google_plus_url'].toString();
         instragramurl = data['User']['instagram_url'].toString();
         linkdinurl = data['User']['linkedin_url'].toString();
         youtubeurl = data['User']['youtube_url'].toString();
         pincode = data['User']['pincode'].toString();
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

  Future<void> showPhotoCaptureOptions() async {
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
                                profileimage = result.path.toString();
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
                                 profileimage = result.path.toString();
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

  Future _basicdetailupdate(String fullname, String picpath, String fb, String twitter, String google, String instagram, String linkedin, String youtube, String country, String state, String city, String address, String pincode) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      _loading = true;
    });
    print("0 "+prefs.getString('userid'));
    print("1 "+fullname);
    print("2 "+picpath);
    print("3 "+fb);
    print("4 "+twitter);
    print("5 "+address);
    print("6 "+google);
    print("7 "+instagram);
    print("8 "+linkedin);
    print("9 "+youtube);
    print("10 "+pincode);
    print("country id "+country_id);
    print("state id "+state_id);
    print("city id "+city_id);

    var requestMulti = http.MultipartRequest('POST', Uri.parse(BASE_URL+basicupdate));
    requestMulti.fields["id"] = prefs.getString('userid');
    requestMulti.fields["name"] = fullname;
    requestMulti.fields["address"] = address;
    requestMulti.fields["country"] = country_id;
    requestMulti.fields["state"] = state_id;
    requestMulti.fields["city"] = city_id;
    requestMulti.fields["pincode"] = pincode;
    requestMulti.fields["com_prefs"] = smsvalue.toString()+","+emailvalue.toString();
    requestMulti.fields["instagram_url"] = instagram;
    requestMulti.fields["mobile_hidden"] = _hidemobile.toString();
    requestMulti.fields["google_plus_url"] = google;
    requestMulti.fields["facebook_url"] = fb;
    requestMulti.fields["twitter_url"] = twitter;
    requestMulti.fields["linkedin_url"] = linkedin;
    requestMulti.fields["youtube_url"] = youtube;

    requestMulti.files.add(await http.MultipartFile.fromPath('avatar', picpath));

    requestMulti.send().then((response) {
      response.stream.toBytes().then((value) {
        try {
          var responseString = String.fromCharCodes(value);
          print(responseString);
          setState((){
            _loading = false;
          });
          var jsonData = jsonDecode(responseString);
          if (jsonData['ErrorCode'].toString() != "0") {
            //_personaldetailupdate()
            //showToast(jsonData['Response'].toString());
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
}
