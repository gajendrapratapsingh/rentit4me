import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:rentit4me/helper/dialog_helper.dart';
import 'package:rentit4me/helper/loader.dart';
import 'package:rentit4me/main.dart';
import 'package:rentit4me/network/api.dart';
import 'package:rentit4me/themes/constant.dart';
import 'package:rentit4me/views/all_category_screen.dart';
import 'package:rentit4me/views/login_screen.dart';
import 'package:rentit4me/views/product_detail_screen.dart';
import 'package:rentit4me/views/user_finder_data_screen.dart';
import 'package:rentit4me/widgets/navigation_drawer_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Initial Selected Value

  final TextEditingController typeAheadController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String locationvalue;
  String categoryvalue;

  String selectedCity = "Location";

  final List<dynamic> myProducts = [];
  final List<dynamic> mytopcategories = [];
  List mytopcategorieslistData = [];
  final List<dynamic> featuredname = [];
  final List<dynamic> mytopcategoriesname = [];
  final List<dynamic> myfeaturedcategories = [];
  final List<dynamic> mysubfeaturedcategories = [];

  List<dynamic> location = [];
  List<dynamic> category = [];
  List<dynamic> categorylistData = [];
  List<dynamic> categoryslug = [];
  String categoryslugname;
  List<dynamic> images = [];

  List<dynamic> likedadproductlist = [];

  String todaydealsimage1;
  String todaydealsimage2;
  String todaydealsimage3;
  String todaydealsimage4;

  String bottomimage1;
  String bottomimage2;
  String bottomimage3;
  String bottomimage4;
  String bottomsingleimage;

  bool _check = false;

  int _counter = 1;
  void showNotification() {
    setState(() {
      _counter++;
    });
    flutterLocalNotificationsPlugin.show(0,
        "Testing $_counter",
        "How you doing?", NotificationDetails(android: AndroidNotificationDetails(channel.id, channel.name,
                importance: Importance.high,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher')));
  }

  TextEditingController searchController = TextEditingController();
  List searchResult = [];

  bool sharedpref = false;

  @override
  void initState() {
    super.initState();
    _getData();
    _getprofileData();

    // FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    //   RemoteNotification notification = message.notification;
    //   AndroidNotification android = message.notification?.android;
    //   if (notification != null && android != null) {
    //     flutterLocalNotificationsPlugin.show(
    //         notification.hashCode,
    //         notification.title.toString(),
    //         notification.body.toString(),
    //         NotificationDetails(
    //           android: AndroidNotificationDetails(
    //             channel.id,
    //             channel.name,
    //             color: Colors.blue,
    //             playSound: true,
    //             icon: '@mipmap/ic_launcher',
    //             fullScreenIntent: true,
    //           ),
    //         ),
    //         payload: "");
    //   }
    // });

    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    //   print("onMessageOpenedApp");
    //   RemoteNotification notification = message.notification;
    //   AndroidNotification android = message.notification?.android;
    //   if (notification != null && android != null) {
    //     flutterLocalNotificationsPlugin.show(
    //         notification.hashCode,
    //         notification.title,
    //         notification.body,
    //         NotificationDetails(
    //           android: AndroidNotificationDetails(
    //             channel.id,
    //             channel.name,
    //             color: Colors.blue,
    //             playSound: true,
    //             icon: '@mipmap/ic_launcher',
    //             fullScreenIntent: true,
    //           ),
    //         ),
    //         payload: "");
    //   }
    // });

    _getlocationbyUserlocation();
  }

    @override
    Widget build(BuildContext context) {
       Size size = MediaQuery.of(context).size;
       return WillPopScope(
         onWillPop: () {
         return showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  backgroundColor: Colors.white,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Close this app?",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                      Image.asset(
                        "assets/images/logo.png",
                        scale: 25,
                      )
                    ],
                  ),
                  content: const Text("Are you sure you want to exit.",
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
                  actionsAlignment: MainAxisAlignment.spaceAround,
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Cancel")),
                    ElevatedButton(
                        onPressed: () {
                          SystemNavigator.pop();
                        },
                        child: const Text("Confirm"))
                  ],
                ));
      },
      child: Scaffold(
        key: _scaffoldKey,
        drawer: NavigationDrawerWidget(),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 2.0,
          title: Image.asset('assets/images/logo.png', scale: 25),
          leading: Padding(
              padding: EdgeInsets.only(left: 0),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () async {
                        _scaffoldKey.currentState.openDrawer();
                      },
                      icon: const Icon(Icons.menu, color: kPrimaryColor)),
                  //SizedBox(width: 2),
                  //Image.asset('assets/images/logo.png', scale: 45),
                ],
              )),
          actions: [
            IconButton(
                onPressed:() async {
                  if(!sharedpref){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                   }
                  else{
                    DialogHelper.logout(context);
                  }
                },
                icon: !sharedpref ? Image.asset('assets/images/enter.png', color: kPrimaryColor, scale: 1.2) : Image.asset('assets/images/power.png', color: kPrimaryColor, scale: 1.2)),
          ],
        ),
        body: SingleChildScrollView(
          child: _check == false
              ? Container(
                  height: size.height,
                  width: size.width,
                  child: const Center(child: CircularProgressIndicator()))
              : Column(
                  children: [
                    Padding(padding: EdgeInsets.all(7.0),
                      child: Container(
                          margin: const EdgeInsets.only(top: 5),
                          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.indigo.shade50,
                            borderRadius: const BorderRadius.all(Radius.circular(5)),
                          ),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: TextFormField(
                                  controller: searchController,
                                  decoration: const InputDecoration(
                                    hintText: "Search Rentit4me",
                                    hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed:() async {
                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                  if(searchController.text.length == 0) {
                                     showToast("Please enter your search");
                                  } else {
                                    showLaoding(context);
                                    FocusScope.of(context).unfocus();
                                    var response = await http.post(Uri.parse(BASE_URL + filterUrl),
                                        body: jsonEncode({
                                          "search": "",
                                          "country" : prefs.getString('country'),
                                          "state" : prefs.getString('state'),
                                          "city" : prefs.getString('city'),
                                          "q" : searchController.text.toString(),
                                        }),
                                        headers: {
                                          "Accept": "application/json",
                                          'Content-Type': 'application/json'
                                    });
                                    Navigator.of(context, rootNavigator: true).pop();
                                    if(jsonDecode(response.body)['ErrorCode'] == 0) {
                                       if(jsonDecode(response.body)['ErrorMessage'].toString() == "success"){
                                         List temp = [];
                                         temp.clear();
                                         temp.addAll(jsonDecode(response.body)['Response']['leads']);
                                         setState((){
                                            searchController.text = "";
                                         });
                                         print(response.body);
                                         await showDialog(
                                             context: context,
                                             builder: (context) => AlertDialog(
                                               title: const Text("Search Result"),
                                               content: SizedBox(
                                                 height: MediaQuery.of(context).size.height / 3.0,
                                                 child: ListView(
                                                   children: temp.map((e) => ListTile(
                                                     dense: true,
                                                     title: Text(e['title'].toString()),
                                                     onTap: () {
                                                       Navigator.push(context, MaterialPageRoute(builder: (context) => UserfinderDataScreen(getlocation: locationvalue, getcategory: categoryvalue, getcategoryslug: categoryslugname, data: temp)));
                                                       //Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailScreen(productid: e['id'].toString()))).then((value) => Navigator.of(context).pop());
                                                     },
                                                   )).toList(),
                                                 ),
                                               ),
                                             ));
                                       }
                                       else{
                                         setState((){
                                           searchController.text = "";
                                         });
                                         showToast(jsonDecode(response.body)['ErrorMessage'].toString());
                                       }
                                    }
                                    else {
                                      setState((){
                                        searchController.text = "";
                                      });
                                      showToast(jsonDecode(response.body)['ErrorMessage'].toString());
                                    }
                                  }
                                },
                                child: const Text("Search"),
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ))),
                              )
                            ],
                          )),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.22,
                      width: double.infinity,
                      child: images.length == 0 || images.isEmpty
                          ? const Center(child: CircularProgressIndicator())
                          : Carousel(
                              dotSpacing: 15.0,
                              dotSize: 6.0,
                              dotIncreasedColor: kPrimaryColor,
                              dotBgColor: Colors.transparent,
                              indicatorBgPadding: 10.0,
                              dotPosition: DotPosition.bottomCenter,
                              images: images.map((item) => Container(child: CachedNetworkImage(imageUrl: item, fit: BoxFit.fill))).toList(),
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 35,
                            width: size.width * 0.38,
                            alignment: Alignment.center,
                            child: TypeAheadField(
                              //hideOnLoading: false,
                              textFieldConfiguration: TextFieldConfiguration(
                                  //autofocus: false,
                                  controller: typeAheadController,
                                  decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.only(left: 5.0, top: 5.0),
                                      hintText: locationvalue == null ? "Search City" : locationvalue,
                                      border: const OutlineInputBorder()
                                  ),
                              ),
                              suggestionsCallback: (pattern) async {
                                return await _getAllCity(pattern);
                              },
                              itemBuilder: (context, suggestion) {
                                return ListTile(
                                  title: Text(suggestion),
                                );
                              },
                              onSuggestionSelected: (suggestion) {
                                typeAheadController.text = suggestion;
                                setState((){
                                   locationvalue = suggestion;
                                });
                              },
                            ),
                          ),
                          Container(
                            height: 35,
                            width: size.width * 0.32,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.indigo.shade100,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: DropdownButton(
                                hint: const Text("Category", style: TextStyle(color: kPrimaryColor, fontSize: 12)),
                                value: categoryvalue,
                                isExpanded: true,
                                underline: Container(
                                  color: Colors.deepPurpleAccent,
                                ),
                                icon: const Visibility(visible: true, child: Icon(Icons.arrow_drop_down_sharp, size: 20, color: kPrimaryColor)),
                                items: category.map((items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text(items,
                                        maxLines: 2,
                                        style: const TextStyle(color: kPrimaryColor, fontSize: 12)),
                                  );
                                }).toList(),
                                // After selecting the desired option,it will
                                // change button value to selected value
                                onChanged: (newValue) {
                                  setState(() {
                                    categoryvalue = newValue;
                                    categorylistData.forEach((element) {
                                        if(element['title'].toString() == categoryvalue){
                                           categoryslugname = element['slug'].toString();
                                        }
                                    });
                                  });
                                },
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                               if(locationvalue == null && categoryvalue != null){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => UserfinderDataScreen(getlocation: locationvalue, getcategory: categoryvalue, getcategoryslug: categoryslugname, data: [])));
                               }
                               else if(locationvalue != null && categoryvalue == null){
                                 Navigator.push(context, MaterialPageRoute(builder: (context) => UserfinderDataScreen(getlocation: locationvalue, getcategory: categoryvalue, getcategoryslug: categoryslugname, data: [])));
                               }
                               else if(locationvalue != null && categoryvalue != null){
                                 Navigator.push(context, MaterialPageRoute(builder: (context) => UserfinderDataScreen(getlocation: locationvalue, getcategory: categoryvalue, getcategoryslug: categoryslugname, data: [])));
                               }
                               else{
                                 showToast("Please select location or category");
                               }
                            },
                            child: Container(
                              height: 35,
                              width: size.width * 0.20,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                  color: Colors.deepOrangeAccent,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              child: const Text("Let's Start!",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12)),
                            ),
                          )
                        ],
                      ),
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text("Rent From Our Wide Range Of Categories",
                            style: TextStyle(
                                color: Colors.deepOrangeAccent, fontSize: 14)),
                      ),
                    ),
                    Padding(padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: myProducts.length == 0 || myProducts.isEmpty
                          ? Center(child: CircularProgressIndicator())
                          : GridView.builder(
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 8.0, mainAxisSpacing: 8.0),
                              itemCount: 6,
                              itemBuilder: (BuildContext ctx, index) {
                                return InkWell(
                                  onTap:() async {
                                    showLaoding(context);
                                    categorylistData.forEach((element) {
                                        if(element['title'].toString() == category[index].toString()){
                                           setState((){
                                             categoryslugname = element['slug'].toString();
                                           });
                                        }
                                    });
                                    print(jsonEncode({
                                      "city_name": locationvalue,
                                      "category": categoryslugname,
                                      "exclude": "1",
                                      "search" : ""
                                    }));
                                    var response = await http.post(Uri.parse(BASE_URL + filterUrl),
                                        body: jsonEncode({
                                               "city_name": locationvalue,
                                               "category": categoryslugname,
                                               "exclude": "1",
                                               "search" : ""
                                        }),
                                        headers: {
                                          "Accept": "application/json",
                                          'Content-Type': 'application/json'
                                    });
                                    Navigator.of(context, rootNavigator: true).pop();
                                    if(jsonDecode(response.body)['ErrorCode'] == 0) {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => UserfinderDataScreen(getlocation: locationvalue, getcategory: category[index].toString(), getcategoryslug: categoryslugname, data: jsonDecode(response.body)['Response']['leads'])));
                                    } else {
                                      Fluttertoast.showToast(msg: "No result found", gravity: ToastGravity.CENTER);
                                    }
                                  },
                                  child: Card(
                                    elevation: 8.0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(12.0)),
                                    child: GridTile(
                                      footer: Container(
                                        decoration: const BoxDecoration(
                                            color: Color(0xFFFCFBFD),
                                            borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(12),
                                                bottomRight:
                                                Radius.circular(12))),
                                        child: Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Text(category[index],
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(color: Colors.black, fontSize: 12)),
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(12)),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: kPrimaryColor,
                                              borderRadius:
                                              BorderRadius.circular(15)),
                                          child: CachedNetworkImage(
                                            fit: BoxFit.cover,
                                            imageUrl: myProducts[index],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                    ),
                    Padding(padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Align(
                        alignment: Alignment.center,
                        child: InkWell(
                          onTap: (){
                             Navigator.of(context).push(MaterialPageRoute(builder: (context) => AllCategoryScreen()));
                          },
                          child: Container(
                            width: size.width * 0.18,
                            height: 30,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                                color: Colors.deepOrangeAccent,
                                borderRadius: BorderRadius.all(Radius.circular(4.0))),
                            child: const Text("See All", style: TextStyle(color: Colors.white, fontSize: 10)),
                          ),
                        ),
                      ),
                    ),
                    Container(
                       width: double.infinity,
                       color: kContainerColor,
                       child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Container(
                               height: MediaQuery.of(context).size.height * 0.40,
                               width: MediaQuery.of(context).size.width,
                               child: Padding(
                                 padding: const EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0, bottom: 0.0),
                                 child: ClipRRect(borderRadius: const BorderRadius.all(Radius.circular(0.0)),
                                   child: CachedNetworkImage(
                                     imageUrl: todaydealsimage1,
                                     fit: BoxFit.fill,
                                   ),
                                 ),
                               ),
                             ),
                             Container(
                              height: MediaQuery.of(context).size.height * 0.23,
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0, bottom: 5.0),
                                child: ClipRRect(borderRadius: const BorderRadius.all(Radius.circular(0.0)),
                                  child: CachedNetworkImage(
                                    imageUrl: todaydealsimage2,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                             Container(
                               height: MediaQuery.of(context).size.height * 0.23,
                               width: MediaQuery.of(context).size.width,
                               padding: const EdgeInsets.only(left: 10.0, top: 5.0, right: 10.0, bottom: 10.0),
                               child: Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: [
                                    Container(
                                      height: MediaQuery.of(context).size.height * 0.21,
                                      width: MediaQuery.of(context).size.width * 0.45,
                                      child: CachedNetworkImage(
                                        imageUrl: todaydealsimage3,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    Container(
                                     height: MediaQuery.of(context).size.height * 0.21,
                                     width: MediaQuery.of(context).size.width * 0.45,
                                     child: CachedNetworkImage(
                                       imageUrl: todaydealsimage4,
                                       fit: BoxFit.fill,
                                     ),
                                   ),
                                 ],
                               ),
                             )
                          ],
                       ),
                    ),
                    likedadproductlist.isEmpty || likedadproductlist.length == 0 ? SizedBox() : const Padding(
                      padding: EdgeInsets.only(left: 15, top: 10),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text("You May Also Like",
                            style: TextStyle(
                                color: Colors.deepOrangeAccent,
                                fontSize: 14,
                                fontWeight: FontWeight.w700)),
                      ),
                    ),
                        likedadproductlist.isEmpty || likedadproductlist.length == 0 ? SizedBox() : Padding(padding: EdgeInsets.only(left: 15, top: 10, right: 15),
                        child: likedadproductlist.length == 0 ? SizedBox(height: 0) : GridView.builder(
                            shrinkWrap: true,
                            itemCount: likedadproductlist.length,
                            physics: ClampingScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 4.0,
                                mainAxisSpacing: 4.0,
                                childAspectRatio: 1.0),
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailScreen(productid: likedadproductlist[index]['id'].toString())));
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
                                        imageUrl: sliderpath+ likedadproductlist[index]['upload_base_path'].toString() + likedadproductlist[index]['file_name'].toString(),
                                      ),
                                      const SizedBox(height: 5.0),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5.0, right: 15.0),
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                              likedadproductlist[index]['title'].toString(),
                                              maxLines: 2,
                                              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 14)),
                                        ),
                                      ),
                                      const SizedBox(height: 5.0),
                                        Padding(padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: size.width * 0.23,
                                              child: Text("Starting from ${likedadproductlist[index]['currency'].toString()} ${likedadproductlist[index]['prices'][0]['price'].toString()}", style: const TextStyle(color: kPrimaryColor, fontSize: 12)),
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
                    mytopcategories.length == 0 || mytopcategories.isEmpty ? SizedBox() : const Padding(
                      padding: EdgeInsets.only(left: 15, top: 10),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text("Top Selling Categories",
                            style: TextStyle(
                                color: Colors.deepOrangeAccent,
                                fontSize: 14,
                                fontWeight: FontWeight.w700)),
                      ),
                    ),
                    mytopcategories.length == 0 || mytopcategories.isEmpty ? SizedBox() :  Padding(
                      padding: EdgeInsets.only(left: 15, top: 10, right: 15),
                      child: mytopcategories.length == 0 || mytopcategories.isEmpty
                          ? Center(child: CircularProgressIndicator())
                          : GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 8.0,
                                      mainAxisSpacing: 8.0),
                              itemCount: mytopcategories.length,
                              itemBuilder: (BuildContext ctx, index) {
                                return InkWell(
                                  onTap:() async {
                                    showLaoding(context);
                                    mytopcategorieslistData.forEach((element) {
                                      if(element['title'].toString() == mytopcategoriesname[index].toString()){
                                         setState((){
                                           categoryslugname = element['slug'].toString();
                                         });
                                      }
                                    });
                                    print(jsonEncode({
                                      "city_name": locationvalue,
                                      "category": categoryslugname,
                                      "exclude": "1",
                                      "search" : ""
                                    }));
                                    var response = await http.post(Uri.parse(BASE_URL + filterUrl),
                                        body: jsonEncode({
                                          "city_name": locationvalue,
                                          "category": categoryslugname,
                                          "exclude": "1",
                                          "search" : ""
                                        }),
                                        headers: {
                                          "Accept": "application/json",
                                          'Content-Type': 'application/json'
                                    });
                                    Navigator.of(context, rootNavigator: true).pop();
                                    if(jsonDecode(response.body)['ErrorCode'] == 0) {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => UserfinderDataScreen(getlocation: locationvalue, getcategory: mytopcategoriesname[index].toString(), getcategoryslug: categoryslugname, data: jsonDecode(response.body)['Response']['leads'])));
                                    } else {
                                      Fluttertoast.showToast(msg: "No result found", gravity: ToastGravity.CENTER);
                                    }
                                  },
                                  child: Card(
                                    elevation: 8.0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0)),
                                    child: GridTile(
                                      footer: Container(
                                        decoration: const BoxDecoration(
                                            color: Color(0xFFFCFBFD),
                                            borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(12),
                                                bottomRight:
                                                    Radius.circular(12))),
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Text(mytopcategoriesname[index],
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(color: Colors.black, fontSize: 12)),
                                        ),
                                      ),
                                      child: ClipRRect(borderRadius: const BorderRadius.all(Radius.circular(12)),
                                        child: Container(
                                          decoration: BoxDecoration(color: kPrimaryColor, borderRadius: BorderRadius.circular(15)),
                                          child: CachedNetworkImage(fit: BoxFit.cover, imageUrl: mytopcategories[index]),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.only(bottom: 5),
                      width: double.infinity,
                      color: kContainerColor,
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          const Text("Today's Special Deals", style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 14)),
                          const SizedBox(height: 5),
                          Container(
                            width: double.infinity,
                            color: kContainerColor,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: MediaQuery.of(context).size.height * 0.40,
                                  width: MediaQuery.of(context).size.width,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0, bottom: 0.0),
                                    child: ClipRRect(borderRadius: const BorderRadius.all(Radius.circular(0.0)),
                                      child: CachedNetworkImage(
                                        imageUrl: bottomimage1,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: MediaQuery.of(context).size.height * 0.23,
                                  width: MediaQuery.of(context).size.width,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0, bottom: 5.0),
                                    child: ClipRRect(borderRadius: const BorderRadius.all(Radius.circular(0.0)),
                                      child: CachedNetworkImage(
                                        imageUrl: bottomimage2,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: MediaQuery.of(context).size.height * 0.23,
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.only(left: 10.0, top: 5.0, right: 10.0, bottom: 10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        height: MediaQuery.of(context).size.height * 0.21,
                                        width: MediaQuery.of(context).size.width * 0.45,
                                        child: CachedNetworkImage(
                                          imageUrl: bottomimage3,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      Container(
                                        height: MediaQuery.of(context).size.height * 0.21,
                                        width: MediaQuery.of(context).size.width * 0.45,
                                        child: CachedNetworkImage(
                                          imageUrl: bottomimage4,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: myfeaturedcategories.map((e) =>  e['ads'].length != 0 ? Column(
                         children: [
                           Padding(
                             padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                             child: Align(
                                 alignment: Alignment.topLeft,
                                 child: Text(e['title'].toString(), style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500))
                             ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                              child: GridView.builder(
                                  shrinkWrap: true,
                                  physics: ClampingScrollPhysics(),
                                  itemCount: e['ads'].length,
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 4.0,
                                      mainAxisSpacing: 4.0,
                                      childAspectRatio: 1.0
                                  ),
                                  itemBuilder: (context, gridindex){
                                    return InkWell(
                                      onTap: () {
                                         Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailScreen(productid: e['ads'][gridindex]['id'].toString())));
                                      },
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(4.0),
                                        ),
                                        child: Column(
                                          children: [
                                            CachedNetworkImage(
                                              height: 80,
                                              width: double.infinity,
                                              errorWidget: (context, url, error) => Image.asset('assets/images/no_image.jpg'),
                                              fit: BoxFit.cover,
                                              imageUrl: sliderpath + e['ads'][gridindex]['images'][0]['upload_base_path'].toString() + e['ads'][gridindex]['images'][0]['file_name'].toString(),
                                            ),
                                            const SizedBox(height: 5.0),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 5.0, right: 15.0),
                                              child: Align(
                                                alignment: Alignment.topLeft,
                                                child: Text(e['ads'][gridindex]['title'].toString(),
                                                    maxLines: 2,
                                                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 16)),
                                              ),
                                            ),
                                            e['ads'].length != 0 ? const SizedBox(height: 5.0) : SizedBox(),
                                            Padding(
                                              padding:
                                              const EdgeInsets.only(
                                                  left: 4.0,
                                                  right: 4.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  SizedBox(
                                                    width:
                                                    size.width * 0.28,
                                                    child: Text(
                                                        "Starting from ${e['ads'][gridindex]['currency'].toString()} ${e['ads'][gridindex]['prices'][0]['price'].toString()}",
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
                                  }
                              ),
                            )
                         ],
                      ) : const SizedBox()).toList(),
                    ),
                    Column(
                      children: mysubfeaturedcategories.map((e) => e['ads'].length != 0 ? Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(e['title'].toString(), style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500))
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                            child: GridView.builder(
                                shrinkWrap: true,
                                itemCount: e['ads'].length,
                                physics: ClampingScrollPhysics(),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 4.0,
                                    mainAxisSpacing: 4.0,
                                    childAspectRatio: 1.0),
                                itemBuilder: (context, gindex) {
                                  return Card(
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
                                          imageUrl: sliderpath+ e['ads'][gindex]['images'][0]['upload_base_path'].toString() + e['ads'][gindex]['images'][0]['file_name'].toString(),
                                        ),
                                        const SizedBox(height: 5.0),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 5.0, right: 15.0),
                                          child: Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(e['ads'][gindex]['title'].toString(),
                                                maxLines: 1,
                                                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 14)),
                                          ),
                                        ),
                                        const SizedBox(height: 5.0),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                width: size.width * 0.23,
                                                child: Text(
                                                    "Starting from ${e['ads'][gindex]['currency']
                                                        .toString()} ${e['ads'][gindex]['prices'][0]['price']
                                                        .toString()}",
                                                    style: const TextStyle(color: kPrimaryColor, fontSize: 12)),
                                              ),
                                              IconButton(
                                                  iconSize: 28,
                                                  onPressed: () {
                                                    Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailScreen(productid: e['id'].toString())));
                                                  },
                                                  icon: const Icon(Icons.add_box_rounded, color: kPrimaryColor))
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }),
                          )
                        ],
                      ) : SizedBox()).toList(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left : 10.0, top: 5.0, bottom: 5.0, right: 10.0),
                      child: Container(
                         height: 200,
                         width: double.infinity,
                         child: Container(
                           child: CachedNetworkImage(fit: BoxFit.cover, imageUrl: bottomsingleimage),
                           decoration: BoxDecoration(
                               color: Colors.amber,
                               borderRadius: BorderRadius.circular(15)),
                         ),
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }

    Future _getData() async {
       SharedPreferences prefs = await SharedPreferences.getInstance();
       if(prefs.getString('userid') == null || prefs.getString('userid') == ""){
          setState((){
              sharedpref = false;
          });
       }
       else{
         setState((){
           sharedpref = true;
         });
       }
       final body = {
         "country": prefs.getString('country'),
         "state": prefs.getString('state'),
         "city": prefs.getString('city'),
       };
       var response = await http.post(Uri.parse(BASE_URL + homeUrl),
           body: jsonEncode(body),
           headers: {
             "Accept": "application/json",
             'Content-Type': 'application/json'
           }
       );
       if(response.statusCode == 200) {
         setState(() {
          images.clear();
          location.clear();
          category.clear();
          myProducts.clear();
          mytopcategories.clear();

          jsonDecode(response.body)['Response']['slider'].forEach((element){
              images.add(sliderpath+element['value'].toString());
          });

          jsonDecode(response.body)['Response']['cities'].forEach((element){
            location.add(element['name'].toString());
          });

          categorylistData.addAll(jsonDecode(response.body)['Response']['categories']);

          jsonDecode(response.body)['Response']['categories'].forEach((element){
             categoryslug.add(element['slug'].toString());
             category.add(element['title'].toString());
             myProducts.add(imagepath + element['image'].toString());
          });

          mytopcategorieslistData.addAll(jsonDecode(response.body)['Response']['top_selling_categories']);
          jsonDecode(response.body)['Response']['top_selling_categories'].forEach((element){
             mytopcategoriesname.add(element['title'].toString());
             mytopcategories.add(imagepath + element['image'].toString());
          });

          myfeaturedcategories.addAll(jsonDecode(response.body)['Response']['featured_categories']);
          mysubfeaturedcategories.addAll(jsonDecode(response.body)['Response']['featured_subcategories']);
          // jsonDecode(response.body)['Response']['featured_categories'].forEach((element){
          //     featuredname.add(element['title'].toString());
          //     myfeaturedcategories.add(imagepath + element['image'].toString());
          // });

          likedadproductlist.addAll(jsonDecode(response.body)['Response']['You_may_also_like']);

          todaydealsimage1 = sliderpath + jsonDecode(response.body)['Response']['Today’s Special Deals']['mid_banner_1']['value'].toString();
          todaydealsimage2 = sliderpath + jsonDecode(response.body)['Response']['Today’s Special Deals']['mid_banner_2']['value'].toString();
          todaydealsimage3 = sliderpath + jsonDecode(response.body)['Response']['Today’s Special Deals']['mid_banner_3']['value'].toString();
          todaydealsimage4 = sliderpath + jsonDecode(response.body)['Response']['Today’s Special Deals']['mid_banner_4']['value'].toString();


          bottomimage1 = sliderpath + jsonDecode(response.body)['Response']['Today’s Special Deals']['bottom_banner_1']['value'].toString();
          bottomimage2 = sliderpath + jsonDecode(response.body)['Response']['Today’s Special Deals']['bottom_banner_2']['value'].toString();
          bottomimage3 = sliderpath + jsonDecode(response.body)['Response']['Today’s Special Deals']['bottom_banner_3']['value'].toString();
          bottomimage4 = sliderpath + jsonDecode(response.body)['Response']['Today’s Special Deals']['bottom_banner_4']['value'].toString();

          bottomsingleimage = sliderpath + jsonDecode(response.body)['Response']['Today’s Special Deals']['bottom_banner_single']['value'].toString();

          _check = true;
      });
    }
  }

    Future _getprofileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final body = {
      "id": prefs.getString('userid'),
    };
    var response = await http.post(Uri.parse(BASE_URL + profileUrl),
        body: jsonEncode(body),
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json'
    });
    if (response.statusCode == 200) {
      var data = json.decode(response.body)['Response'];
      if(json.decode(response.body)['Response'] != null){
        prefs.setString('profile', sliderpath + data['User']['avatar_path'].toString());
        prefs.setString('name', data['User']['name'].toString());
        prefs.setString('email', data['User']['email'].toString());
        prefs.setString('mobile', data['User']['mobile'].toString());
        prefs.setString('userquickid', data['User']['quickblox_id'].toString());
        prefs.setString('quicklogin', data['User']['quickblox_email'].toString());
        prefs.setString('quickpassword', data['User']['quickblox_password'].toString());
      }

    } else {
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

   _getlocationbyUserlocation() async{
     SharedPreferences prefs = await SharedPreferences.getInstance();
     if(prefs.getString('city') != null || prefs.getString('city') != ""){
        setState((){
           locationvalue = prefs.getString('city');
        });
     }
  }

   Future<List> _getAllCity(String pattern) async{
     SharedPreferences prefs = await SharedPreferences.getInstance();
     final body = {
       "country": prefs.getString('country'),
       "search_city" : pattern
     };
     var response = await http.post(Uri.parse(BASE_URL + citiesUrl),
         body: jsonEncode(body),
         headers: {
           "Accept": "application/json",
           'Content-Type': 'application/json'
     });
     
     List temp=jsonDecode(response.body)['Response'];
     
     List temp2=[];
     temp.forEach((element) { 
       temp2.add(element['name']);
     });
     return temp2;
   }
}
