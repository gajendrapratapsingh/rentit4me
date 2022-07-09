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
import 'package:rentit4me/views/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDetailScreen extends StatefulWidget {
  const UserDetailScreen({Key key}) : super(key: key);

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {

  bool _loading = false;

  List<dynamic> countrylistData = [];
  String initialcountryname;
  String country_id;

  List<dynamic> statelistData = [];
  String initialstatename;
  String state_id;

  List<dynamic> citylistData = [];
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

  List<int> commprefs = [];

  String countryhint = "Select Country";
  String statehint = "Select State";
  String cityhint = "Select City";

  bool profilepicbool = false;


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
        leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Icon(
              Icons.arrow_back,
              color: kPrimaryColor,
            )),
        title: Text("Profile", style: TextStyle(color: kPrimaryColor)),
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
                   elevation: 2.0,
                   shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(25.0),
                   ),
                   child: Padding(
                     padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 8.0),
                     child: Row(
                       children: [
                         profileimage == null || profileimage == "" ? ClipRRect(
                           borderRadius: BorderRadius.circular(20),
                           child: Container(
                            height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)
                            ),
                            child: CircleAvatar(child: Image.asset('assets/images/no_image.jpg'))),
                         ) : ClipRRect(
                             borderRadius: BorderRadius.circular(22),
                            child: Container(
                              height: 45,
                              width: 45,
                             decoration: BoxDecoration(
                                 borderRadius: BorderRadius.circular(22)
                             ),
                              child: CachedNetworkImage(
                                  imageUrl: profileimage,
                                  placeholder: (context, url) => CircularProgressIndicator(),
                                  errorWidget: (context, url, error) => Image.asset('assets/images/no_image.jpg'),
                              ),
                            )),
                         SizedBox(width: 10),
                         Expanded(
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [
                                 name == null || name == "" ? Text("Hi! Guest", style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 16, fontWeight: FontWeight.w500)) : Text("Hi! $name", style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 16, fontWeight: FontWeight.w500)),
                                 membership == "" || membership == null || membership == "null" ? SizedBox() : Text("Membership: $membership", style: TextStyle(color: kPrimaryColor, fontSize: 16))
                               ],
                             )
                         ),
                         Row(
                           children: [
                             Column(
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [
                                 myads == null || myads == "" ? SizedBox() : Text("$myads", style: TextStyle(color: kPrimaryColor, fontSize: 16, fontWeight: FontWeight.w500)),
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
                              Checkbox(value: _hidemob, onChanged:(value){
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
                         const Align(
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
                                 onChanged:(value){
                                     name = value;
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
                         const Align(
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
                                   fburl = value;
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
                                   twitterurl = value;
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
                                 onChanged: (value){
                                    setState((){
                                       linkdinurl = value;
                                    });
                                 },
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
                         const Align(alignment: Alignment.center, child: Text("Setting", style: TextStyle(color: kPrimaryColor, fontSize: 21, fontWeight: FontWeight.w700))),
                         const SizedBox(height: 10),
                         const Text("Country*", style: TextStyle(color: kPrimaryColor, fontSize: 16, fontWeight: FontWeight.w500)),
                         const SizedBox(height: 8.0),
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
                                   hint: Text(countryhint, style: TextStyle(color: Colors.black)),
                                   value: initialcountryname,
                                   elevation: 16,
                                   isExpanded: true,
                                   style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
                                   onChanged: (String data) {
                                     setState(() {
                                         initialcountryname = data.toString();
                                         initialstatename = null;
                                         initialcityname = null;
                                         country_id = data.toString();
                                         _getStateData(data);
                                    });
                                   },
                                   items: countrylistData.map((items) {
                                     return DropdownMenuItem<String>(
                                       value: items['id'].toString(),
                                       child: Text(items['name']),
                                     );
                                   }).toList(),
                                 ),
                               ),
                             )
                         ),
                         const SizedBox(height: 10),
                         const Text("State", style: TextStyle(color: kPrimaryColor, fontSize: 16, fontWeight: FontWeight.w500)),
                         const SizedBox(height: 8.0),
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
                                   hint: Text(statehint, style: TextStyle(color: Colors.black, fontSize: 16)),
                                   items: statelistData.map((items) {
                                     return DropdownMenuItem<String>(
                                       value: items['id'].toString(),
                                       child: Text(items['name']),
                                     );
                                   }).toList(),
                                   onChanged: (String data) {
                                     setState(() {
                                       initialstatename = data.toString();
                                       initialcityname = null;
                                       state_id = data.toString();
                                       _getCityData(state_id);
                                     });
                                   },
                                   value: initialstatename,
                                 ),
                               ),
                             )
                         ),
                         const SizedBox(height: 10),
                         const Text("City*", style: TextStyle(color: kPrimaryColor, fontSize: 16, fontWeight: FontWeight.w500)),
                         const SizedBox(height: 8.0),
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
                                   hint: Text(cityhint, style: TextStyle(color: Colors.black)),
                                   value: initialcityname,
                                   elevation: 16,
                                   isExpanded: true,
                                   style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
                                   onChanged: (String data) {
                                     setState(() {
                                       initialcityname = data.toString();
                                       city_id = data.toString();
                                     });
                                   },
                                   items: citylistData.map((items) {
                                     return DropdownMenuItem<String>(
                                       value: items['id'].toString(),
                                       child: Text(items['name']),
                                     );
                                   }).toList(),
                                 ),
                               ),
                             )
                         ),
                         const SizedBox(height: 10),
                         const Text("Address", style: TextStyle(color: kPrimaryColor, fontSize: 16, fontWeight: FontWeight.w500)),
                         const SizedBox(height: 8.0),
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
                         const SizedBox(height: 10),
                         const Text("Pincode", style: TextStyle(color: kPrimaryColor, fontSize: 16, fontWeight: FontWeight.w500)),
                         const SizedBox(height: 8.0),
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
                                 onChanged: (value){
                                    setState((){
                                        pincode = value;
                                    });
                                 },
                                 decoration: InputDecoration(
                                   hintText: pincode == null || pincode == "null" || pincode == "" ? "" : pincode,
                                   border: InputBorder.none,
                                 ),
                               ),
                             )
                         ),
                         const SizedBox(height: 10),
                         const Text("Communication Preferences*", style: TextStyle(color: kPrimaryColor, fontSize: 16, fontWeight: FontWeight.w500)),
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
                         )
                       ],
                     ),
                   ),
                 ),
                 SizedBox(height: 10),
                 InkWell(
                   onTap: (){

                    if(email == null || email == null){
                       showToast("Please enter your email");
                       return;
                    }
                    else if(mobile == "" || mobile == null){
                        showToast("Please enter mobile");
                        return;
                    }
                    else if(name == "" || name == null){
                        showToast("Please enter your name");
                        return;
                    }
                    else if(!profilepicbool && profileimage.length == 0){
                      showToast("Please select your profile picture");
                      return;
                    }
                    else if(country_id == "" || country_id == null){
                      showToast("Please select your country");
                      return;
                    }
                    else if(state_id == "" || state_id == null){
                      showToast("Please select your state");
                      return;
                    }
                    else if(city_id == "" || city_id == null){
                      showToast("Please select your city");
                      return;
                    }
                    else if(address == "" || address == null){
                      showToast("Please enter your address");
                      return;
                    }
                    else if(pincode == "" || pincode == null){
                      showToast("Please enter your pincode");
                      return;
                    }
                    else if(commprefs.length == 0){
                      showToast("Please select almost one communication preference");
                      return;
                    }
                    else{
                      _basicdetailupdate(name, profileimage, fburl, twitterurl, googleplusurl, instragramurl,
                         linkdinurl, youtubeurl, categoryUrl, state_id, city_id, address, pincode);
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
     setState((){
        _loading = true;
     });
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
     print(response.body);
     if(response.statusCode == 200) {
       var data = json.decode(response.body)['Response'];
       setState(() {
         _loading = false;

         profileimage = sliderpath+data['User']['avatar_path'].toString();
         myads = data['My Ads'].toString();
         mobile = data['User']['mobile'].toString();
         name = data['User']['name'].toString();
         email = data['User']['email'].toString();
         address = data['User']['address'].toString();
         fburl = data['User']['facebook_url'].toString();
         twitterurl = data['User']['twitter_url'].toString();
         googleplusurl = data['User']['google_plus_url'].toString();
         instragramurl = data['User']['instagram_url'].toString();
         linkdinurl = data['User']['linkedin_url'].toString();
         youtubeurl = data['User']['youtube_url'].toString();
         pincode = data['User']['pincode'].toString();
         _hidemob = data['User']['mobile_hidden'] == 1 ? true : false;

         country_id = data['User']['country'].toString();
         state_id = data['User']['state'].toString();
         city_id = data['User']['city'].toString();

         countryhint = data['User']['country_name'].toString();
         statehint = data['User']['state_name'].toString();
         cityhint = data['User']['city_name'].toString();


        List selectedList=  data['User']['preferences'].toString().split(",");
selectedList.forEach((element) {
  commprefs.add(int.parse(element));
});
        if(selectedList.contains("1")){
          _emailcheck=true;
        }
         if(selectedList.contains("2")){
           _smscheck=true;
         }



       });

     } else {
       setState((){
          _loading = false;
       });
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
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body)['Response']['countries'];
      setState(() {
        countrylistData.addAll(list);
      });
    } else {
      print(response.body);
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  Future _getStateData(String id) async{
    setState((){
      statelistData.clear();
      _loading = true;
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
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body)['Response']['states'];
      setState(() {
        _loading = false;
        statelistData.addAll(list);
      });
    } else {
      setState(() {
        _loading = false;
      });
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  Future _getCityData(String id) async{
    setState((){
       citylistData.clear();
       _loading = true;
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
    //print(response.body);
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body)['Response']['cities'];
      setState(() {
        _loading = false;
        citylistData.addAll(list);
      });
    } else {
      setState((){
        _loading = false;
      });
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
                                profilepicbool = true;
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
                                 profilepicbool = true;
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
    print("11 "+twitterurl);
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
    requestMulti.fields["com_prefs"] = commprefs.join(",");
    requestMulti.fields["instagram_url"] = instagram;
    requestMulti.fields["mobile_hidden"] = _hidemobile.toString();
    requestMulti.fields["google_plus_url"] = google;
    requestMulti.fields["facebook_url"] = fb;
    requestMulti.fields["twitter_url"] = twitter;
    requestMulti.fields["linkedin_url"] = linkedin;
    requestMulti.fields["youtube_url"] = youtube;

    if(profilepicbool){
      requestMulti.files.add(await http.MultipartFile.fromPath('avatar', picpath));
    }
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
          } else {
            showToast(jsonData['ErrorMessage'].toString());
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen()));
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
