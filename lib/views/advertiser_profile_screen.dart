import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:http/http.dart' as http;
import 'package:rentit4me/network/api.dart';
import 'package:rentit4me/themes/constant.dart';
import 'package:rentit4me/views/product_detail_screen.dart';

class AdvertiserProfileScreen extends StatefulWidget {
  String advertiserid;
  AdvertiserProfileScreen({this.advertiserid});

  @override
  State<AdvertiserProfileScreen> createState() => _AdvertiserProfileScreenState(advertiserid);
}

class _AdvertiserProfileScreenState extends State<AdvertiserProfileScreen> {

  String advertiserid;

  _AdvertiserProfileScreenState(this.advertiserid);

  String name, mobile, email, profileimage, address;

  var focusNode = FocusNode();

  bool _loading = false;
  String _profilepath = "";

  String myads = "";
  String emailverification;
  String mobilehidden;

  //Social Data
  String fb;
  String twitter;
  String youtube;
  String linkedin;
  String googleplus;
  String instragram;

  int stackindex = 0;
  List adviseradslist = [];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getProfile(advertiserid);
    _getAdviserAdProducts(advertiserid);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
        title: const Text("Profile", style: TextStyle(color: kPrimaryColor)),
        centerTitle: true,
      ),
      body: IndexedStack(
        index: stackindex,
        children: [
          Column(
            children: [
              const SizedBox(height: 10),
              Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Card(
                          elevation: 2.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                  child: Container(
                                    height: 45,
                                    width: 45,
                                    child: CachedNetworkImage(
                                      imageUrl: _profilepath,
                                      placeholder: (context, url) => CircularProgressIndicator(),
                                      errorWidget: (context, url, error) => Image.asset('assets/images/no_image.jpg'),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        name == null ? const SizedBox() : Text(name, style: const TextStyle(color: Colors.deepOrangeAccent, fontSize: 16, fontWeight: FontWeight.w500)),
                                      ],
                                    )
                                ),
                                Row(children: [
                                    InkWell(
                                      onTap: (){
                                        setState((){
                                          stackindex = 1;
                                        });
                                      },
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          myads == null ? const SizedBox() : Text(myads, style: const TextStyle(color: kPrimaryColor, fontSize: 16, fontWeight: FontWeight.w500)),
                                          const Text("Total Ads", style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 16))
                                        ],
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Card(
                          elevation: 4.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    const Text("Name", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w700)),
                                    const SizedBox(width: 25.0),
                                    Container(
                                      height: 45,
                                      width: size.width * 0.72,
                                      decoration: BoxDecoration(
                                          border: Border.all(color: Colors.deepOrangeAccent, width: 1),
                                          borderRadius: BorderRadius.circular(4.0)
                                      ),
                                      child: Row(
                                        children: [
                                          name == null ? const SizedBox() : Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 5.0),
                                              child: Text(name, style: TextStyle(color: Colors.black, fontSize: 16)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    const Text("Email", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w700)),
                                    const SizedBox(width: 25.0),
                                    Container(
                                      height: 45,
                                      width: size.width * 0.72,
                                      decoration: BoxDecoration(
                                          border: Border.all(color: Colors.deepOrangeAccent, width: 1),
                                          borderRadius: BorderRadius.circular(4.0)
                                      ),
                                      child: Row(
                                        children: [
                                          email == null ? const SizedBox() : Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 5.0),
                                              child: Text(email, style: TextStyle(color: Colors.black, fontSize: 16)),
                                            ),
                                          ),
                                          Container(
                                            height: 45,
                                            width: 120,
                                            alignment: Alignment.center,
                                            decoration: const BoxDecoration(color: Colors.deepOrangeAccent, borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0), bottomLeft: Radius.circular(8.0))),
                                            child: emailverification == null ? const Text("Not Verified", style: TextStyle(color: Colors.white, fontSize: 14)) : const Text("Verified", style: TextStyle(color: Colors.white, fontSize: 14)),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              mobilehidden == "1" ? const SizedBox() : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    const Text("Mobile", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w700)),
                                    const SizedBox(width: 20.0),
                                    Container(
                                      height: 45,
                                      width: size.width * 0.72,
                                      decoration: BoxDecoration(
                                          border: Border.all(color: Colors.deepOrangeAccent, width: 1),
                                          borderRadius: BorderRadius.circular(4.0)
                                      ),
                                      child: Row(
                                        children: [
                                          mobile == null ? const SizedBox() : Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 5.0),
                                              child: Text(mobile, style: const TextStyle(color: Colors.black, fontSize: 16)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    const Text("Address", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w700)),
                                    const SizedBox(width: 15.0),
                                    Container(
                                      height: 45,
                                      width: size.width * 0.72,
                                      decoration: BoxDecoration(
                                          border: Border.all(color: Colors.deepOrangeAccent, width: 1),
                                          borderRadius: BorderRadius.circular(4.0)
                                      ),
                                      child: Row(
                                        children: [
                                          address == null ? const SizedBox() : Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 5.0),
                                              child: Text(address, style: const TextStyle(color: Colors.black, fontSize: 16)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              //Social Data
                              // fb == null || fb == "null" ? const SizedBox() : Padding(
                              //   padding: const EdgeInsets.all(8.0),
                              //   child: Row(
                              //     children: [
                              //       const Text("Facebook", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w700)),
                              //       const SizedBox(width: 8.0),
                              //       Container(
                              //         height: 45,
                              //         width: size.width * 0.72,
                              //         decoration: BoxDecoration(
                              //             border: Border.all(color: Colors.deepOrangeAccent, width: 1),
                              //             borderRadius: BorderRadius.circular(4.0)
                              //         ),
                              //         child: Row(
                              //           children: [
                              //             fb == null ? SizedBox() : Expanded(
                              //               child: Padding(
                              //                 padding: const EdgeInsets.only(left: 5.0),
                              //                 child: Text(fb, style: TextStyle(color: Colors.black, fontSize: 16)),
                              //               ),
                              //             ),
                              //           ],
                              //         ),
                              //       )
                              //     ],
                              //   ),
                              // ),
                              // twitter == null || twitter == "null" ? const SizedBox() : Padding(padding: const EdgeInsets.all(8.0), child: Row(
                              //     children: [
                              //       const Text("Twitter", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w700)),
                              //       const SizedBox(width: 25.0),
                              //       Container(
                              //         height: 45,
                              //         width: size.width * 0.72,
                              //         decoration: BoxDecoration(
                              //             border: Border.all(color: Colors.deepOrangeAccent, width: 1),
                              //             borderRadius: BorderRadius.circular(4.0)
                              //         ),
                              //         child: Row(
                              //           children: [
                              //             twitter == null ? SizedBox() : Expanded(
                              //               child: Padding(
                              //                 padding: const EdgeInsets.only(left: 5.0),
                              //                 child: Text(twitter, style: TextStyle(color: Colors.black, fontSize: 16)),
                              //               ),
                              //             ),
                              //           ],
                              //         ),
                              //       )
                              //     ],
                              //   )),
                              // googleplus == null || googleplus == "null" ? const SizedBox() : Padding(
                              //   padding: const EdgeInsets.all(8.0),
                              //   child: Row(
                              //     children: [
                              //       const Text("Google+", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w700)),
                              //       const SizedBox(width: 20.0),
                              //       Container(
                              //         height: 45,
                              //         width: size.width * 0.72,
                              //         decoration: BoxDecoration(
                              //             border: Border.all(color: Colors.deepOrangeAccent, width: 1),
                              //             borderRadius: BorderRadius.circular(4.0)
                              //         ),
                              //         child: Row(
                              //           children: [
                              //             googleplus == null ? SizedBox() : Expanded(
                              //               child: Padding(
                              //                 padding: const EdgeInsets.only(left: 5.0),
                              //                 child: Text(googleplus, style: TextStyle(color: Colors.black, fontSize: 16)),
                              //               ),
                              //             ),
                              //           ],
                              //         ),
                              //       )
                              //     ],
                              //   ),
                              // ),
                              // instragram == null || instragram == "null" ? const SizedBox() : Padding(
                              //   padding: const EdgeInsets.all(8.0),
                              //   child: Row(
                              //     children: [
                              //       const Text("Instagram", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w700)),
                              //       const SizedBox(width: 10.0),
                              //       Container(
                              //         height: 45,
                              //         width: size.width * 0.72,
                              //         decoration: BoxDecoration(
                              //             border: Border.all(color: Colors.deepOrangeAccent, width: 1),
                              //             borderRadius: BorderRadius.circular(4.0)
                              //         ),
                              //         child: Row(
                              //           children: [
                              //             instragram == null ? SizedBox() : Expanded(
                              //               child: Padding(
                              //                 padding: const EdgeInsets.only(left: 5.0),
                              //                 child: Text(instragram, style: TextStyle(color: Colors.black, fontSize: 16)),
                              //               ),
                              //             ),
                              //           ],
                              //         ),
                              //       )
                              //     ],
                              //   ),
                              // ),
                              // linkedin == null || linkedin == "null" ? const SizedBox() : Padding(
                              //   padding: const EdgeInsets.all(8.0),
                              //   child: Row(
                              //     children: [
                              //       const Text("Linkdin", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w700)),
                              //       const SizedBox(width: 27.0),
                              //       Container(
                              //         height: 45,
                              //         width: size.width * 0.72,
                              //         decoration: BoxDecoration(
                              //             border: Border.all(color: Colors.deepOrangeAccent, width: 1),
                              //             borderRadius: BorderRadius.circular(4.0)
                              //         ),
                              //         child: Row(
                              //           children: [
                              //             linkedin == null ? SizedBox() : Expanded(
                              //               child: Padding(
                              //                 padding: const EdgeInsets.only(left: 5.0),
                              //                 child: Text(linkedin, style: TextStyle(color: Colors.black, fontSize: 16)),
                              //               ),
                              //             ),
                              //           ],
                              //         ),
                              //       )
                              //     ],
                              //   ),
                              // ),
                              // youtube == null || youtube == "null" ? const SizedBox() : Padding(
                              //   padding: const EdgeInsets.all(8.0),
                              //   child: Row(
                              //     children: [
                              //       const Text("Youtube", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w700)),
                              //       const SizedBox(width: 20.0),
                              //       Container(
                              //         height: 45,
                              //         width: size.width * 0.72,
                              //         decoration: BoxDecoration(
                              //             border: Border.all(color: Colors.deepOrangeAccent, width: 1),
                              //             borderRadius: BorderRadius.circular(4.0)
                              //         ),
                              //         child: Row(
                              //           children: [
                              //             youtube == null ? SizedBox() : Expanded(
                              //               child: Padding(
                              //                 padding: const EdgeInsets.only(left: 5.0),
                              //                 child: Text(youtube, style: TextStyle(color: Colors.black, fontSize: 16)),
                              //               ),
                              //             ),
                              //           ],
                              //         ),
                              //       )
                              //     ],
                              //   ),
                              // ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
            ],
          ),
          Column(
            children: [
              const SizedBox(height: 10),
              Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Card(
                          elevation: 2.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  child: Container(
                                    height: 45,
                                    width: 45,
                                    child: CachedNetworkImage(
                                      imageUrl: _profilepath,
                                      placeholder: (context, url) => CircularProgressIndicator(),
                                      errorWidget: (context, url, error) => Image.asset('assets/images/no_image.jpg'),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        name == null ? const SizedBox() : Text(name, style: const TextStyle(color: Colors.deepOrangeAccent, fontSize: 16, fontWeight: FontWeight.w500)),
                                      ],
                                    )
                                ),
                                Row(children: [
                                  InkWell(
                                    onTap: (){
                                      setState((){
                                        stackindex = 0;
                                      });
                                    },
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(myads, style: const TextStyle(color: kPrimaryColor, fontSize: 16, fontWeight: FontWeight.w500)),
                                        const Text("Total Ads", style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 16))
                                      ],
                                    ),
                                  )
                                ],
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                            adviseradslist.isEmpty || adviseradslist.length == 0 ? const SizedBox() : Padding(padding: EdgeInsets.only(left: 15, top: 10, right: 15),
                            child: adviseradslist.length == 0 ? const SizedBox(height: 0) : GridView.builder(
                                shrinkWrap: true,
                                itemCount: adviseradslist.length,
                                padding: EdgeInsets.zero,
                                physics: ClampingScrollPhysics(),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 4.0,
                                    mainAxisSpacing: 4.0,
                                    childAspectRatio: 1.0),
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailScreen(productid: adviseradslist[index]['id'].toString())));
                                    },
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4.0),
                                      ),
                                      child: Column(
                                        children: [
                                          CachedNetworkImage(
                                            height: 80,
                                            width: double.infinity,
                                            placeholder: (context, url) =>
                                                Image.asset('assets/images/no_image.jpg'),
                                            errorWidget: (context, url, error) =>
                                                Image.asset('assets/images/no_image.jpg'),
                                            fit: BoxFit.cover,
                                            imageUrl: sliderpath+adviseradslist[index]['upload_base_path'].toString() + adviseradslist[index]['file_name'].toString(),
                                          ),
                                          const SizedBox(height: 5.0),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 5.0, right: 15.0),
                                            child: Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                  adviseradslist[index]['title'].toString(),
                                                  maxLines: 2,
                                                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 14)),
                                            ),
                                          ),
                                          const SizedBox(height: 5.0),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              children: [
                                                SizedBox(
                                                  width: size.width * 0.23,
                                                  child: Text(
                                                      "Starting from ${adviseradslist[index]['currency'].toString()} ${adviseradslist[index]['prices'][0]['price'].toString()}",
                                                      style: const TextStyle(color: kPrimaryColor, fontSize: 12)),
                                                ),
                                                const Icon(Icons.add_box_rounded, color: kPrimaryColor)
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                })),
                      ],
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }


  Future _getProfile(String id) async{
    final body = {
      "id": id,
    };
    var response = await http.post(Uri.parse(BASE_URL + advertiserprofileUrl),
        body: jsonEncode(body),
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json'
    });
    if(response.statusCode == 200) {
      var data = json.decode(response.body)['Response'];
      setState((){
         name = data['user']['name'].toString();
         email = data['user']['email'].toString();
         emailverification = data['user']['email_verified_at'];
         mobilehidden = data['user']['mobile_hidden'].toString();
         mobile =  data['user']['mobile'].toString();
         address = data['user']['address'].toString();

         //Social data
         fb = data['user']['facebook_url'].toString();
         twitter = data['user']['twitter_url'].toString();
         googleplus = data['user']['google_plus_url'].toString();
         instragram = data['user']['instagram_url'].toString();
         linkedin = data['user']['linkedin_url'].toString();
         youtube = data['user']['youtube_url'].toString();

         _profilepath = sliderpath+data['user']['avatar_path'].toString();

         myads = data['my_ads'].toString();
      });
    }
  }

  Future _getAdviserAdProducts(String id) async {
    final body = {
      "id": id,
    };
    var response = await http.post(Uri.parse(BASE_URL + advertiseradsurl),
        body: jsonEncode(body),
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json'
    });
    if(response.statusCode == 200){
      var data = json.decode(response.body)['Response'];
      setState((){
         adviseradslist.addAll(data);
      });
    }
  }
}
