import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rentit4me/models/user_profile_data.dart';
import 'package:rentit4me/network/api.dart';
import 'package:rentit4me/themes/constant.dart';
import 'package:http/http.dart' as http;
import 'package:rentit4me/views/home_screen.dart';
import 'package:rentit4me/views/payment_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name, mobile, email, profileimage, address;

  var focusNode = FocusNode();

  bool _loading = false;
  String _profilepath = "";

  String myads = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getprofile();
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
        title: Text("Profile", style: TextStyle(color: kPrimaryColor)),
        centerTitle: true,
        /*actions: [
          IconButton(onPressed:(){}, icon: Icon(Icons.edit, color: kPrimaryColor)),
          IconButton(onPressed:(){}, icon: Icon(Icons.account_circle, color: kPrimaryColor)),
          IconButton(onPressed:(){}, icon: Icon(Icons.menu, color: kPrimaryColor))
        ],*/
      ),
      body: ModalProgressHUD(
        color: Colors.indigo,
        inAsyncCall: _loading,
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: 10),
                Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 120,
                            width: double.infinity,
                            child: Card(
                              elevation: 2.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                     ClipRRect(
                                       borderRadius: BorderRadius.all(Radius.circular(10)),
                                       child: Container(
                                         height: 45,
                                         width: 45,
                                         child: CachedNetworkImage(
                                           imageUrl: ""
                                         ),
                                       ),
                                     ),
                                     SizedBox(width: 10),
                                     Expanded(
                                         child: Column(
                                           crossAxisAlignment: CrossAxisAlignment.start,
                                           mainAxisAlignment: MainAxisAlignment.center,
                                           children: [
                                             Text("Hi! $name", style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 16, fontWeight: FontWeight.w500)),
                                             Text("Membership: Paid", style: TextStyle(color: kPrimaryColor, fontSize: 16))
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
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Align(
                                alignment: Alignment.center,
                                child: InkWell(
                                  onTap: () {
                                    //Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileDetailScreen()));
                                    /*setState(() {
                                        FocusScope.of(context).requestFocus(focusNode);
                                      });*/
                                  },
                                  child: Card(
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Colors.white, width: 1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10.0, horizontal: 15.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: const [
                                            Icon(Icons.edit_outlined,
                                                color: Colors.black, size: 24),
                                            SizedBox(width: 5.0),
                                            Text("Edit Profile",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18.0,
                                                    fontWeight:
                                                    FontWeight.w500))
                                          ],
                                        ),
                                      )),
                                )),
                          ),
                          Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                const Align(
                                  alignment: Alignment.topLeft,
                                  child: Text("Name",
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 14.0)),
                                ),
                                TextField(
                                  keyboardType: TextInputType.text,
                                  //focusNode: focusNode,
                                  decoration: InputDecoration(
                                    hintText:
                                    name == "" || name == null ? "" : name,
                                    enabledBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black),
                                    ),
                                    focusedBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      name = value.toString();
                                    });
                                  },
                                ),
                                const SizedBox(height: 20),
                                const Align(
                                  alignment: Alignment.topLeft,
                                  child: Text("Phone Number",
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 14.0)),
                                ),
                                TextField(
                                    keyboardType: TextInputType.number,
                                    //readOnly: true,
                                    decoration: InputDecoration(
                                      hintText: mobile == "" || mobile == null
                                          ? ""
                                          : mobile,
                                      //suffix: Text("Edit", style: TextStyle(color: Colors.grey, fontSize: 14)),
                                      enabledBorder: const UnderlineInputBorder(
                                        borderSide:
                                        BorderSide(color: Colors.black),
                                      ),
                                      focusedBorder: const UnderlineInputBorder(
                                        borderSide:
                                        BorderSide(color: Colors.black),
                                      ),
                                    )),
                                const SizedBox(height: 20),
                                const Align(
                                  alignment: Alignment.topLeft,
                                  child: Text("Email",
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 14.0)),
                                ),
                                TextField(
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    hintText: email == "" || email == null
                                        ? ""
                                        : email,
                                    enabledBorder: const UnderlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Colors.black),
                                    ),
                                    focusedBorder: const UnderlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Colors.black),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      email = value.toString();
                                    });
                                  },
                                ),
                                const SizedBox(height: 20),
                                const Align(
                                  alignment: Alignment.topLeft,
                                  child: Text("Address",
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 14.0)),
                                ),
                                TextField(
                                  decoration: InputDecoration(
                                    hintText: address == "" || address == null
                                        ? ""
                                        : address,
                                    //suffix: Text("Change", style: TextStyle(fontSize: 14)),
                                    enabledBorder: const UnderlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Colors.black),
                                    ),
                                    focusedBorder: const UnderlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Colors.black),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      address = value.toString();
                                    });
                                  },
                                ),
                                const SizedBox(height: 20),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  width: size.width * 0.9,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(29),
                                    child: newElevatedButton(),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget newElevatedButton() {
    return ElevatedButton(
      child: const Text(
        "Save",
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
      onPressed: () {
        if (_profilepath.toString() == "" || _profilepath.toString() == null) {
          showToast("Please select your profile picture");
        } else {
          //_updateprofile();
        }
      },
      style: ElevatedButton.styleFrom(
          primary: kPrimaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          textStyle: const TextStyle(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
    );
  }

  Future<ProfileResponse> _getprofile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final body = {
      "id": prefs.get('userid'),
    };
    var response = await http.post(Uri.parse(BASE_URL + profileUrl),
        body: jsonEncode(body),
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json'
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
      });

    } else {
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  void _showProfilePicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: const Icon(Icons.photo_library),
                      title: const Text('Gallery'),
                      onTap: () {
                        _profileimgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: const Icon(Icons.photo_camera),
                    title: const Text('Camera'),
                    onTap: () {
                      _profileimgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
  _profileimgFromCamera() async {
    final ImagePicker _picker = ImagePicker();
    final XFile photo =
    await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    setState(() {
      _profilepath = photo.path;
    });
  }
  _profileimgFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    XFile image =
    await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      _profilepath = image.path;
    });
  }

  Future<bool> _willPopCallback() async {
    return Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomeScreen()));
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
                                 //prescriptionList.add({"file": result.path.toString()});
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
                                //prescriptionList.add({"file": result.path.toString()});
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
