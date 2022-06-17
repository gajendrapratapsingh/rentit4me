import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rentit4me/network/api.dart';
import 'package:rentit4me/themes/constant.dart';
import 'package:http/http.dart' as http;
import 'package:rentit4me/views/product_detail_screen.dart';

class UserfinderDataScreen extends StatefulWidget {
  String getlocation;
  String getcategory;
  List data = [];
  UserfinderDataScreen({this.getlocation, this.getcategory, this.data});

  @override
  _UserfinderDataScreenState createState() =>
      _UserfinderDataScreenState(getlocation, getcategory);
}

class _UserfinderDataScreenState extends State<UserfinderDataScreen> {
  String getlocation;
  String getcategory;
  _UserfinderDataScreenState(this.getlocation, this.getcategory);

  int skipvalue = 0;

  String locationvalue;
  String categoryvalue;

  var location = [''];
  var category = [''];

  List<dynamic> _searchlist = [];
  List<dynamic> _productdata = [];
  bool isLoading = true;

  bool isListing = true;
  final controller = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    /*setState(() {
        locationvalue = getlocation;
        categoryvalue = getcategory;
    });*/
    if (widget.data.length > 0) {
      setState(() {
        _productdata.clear();
        _searchlist.clear();
        _productdata.addAll(widget.data);
        _searchlist.addAll(widget.data);
        isLoading = false;
        listEnd = true;
      });
    } else {
      _getData(getlocation, getcategory);

      controller.addListener(() {
        if (controller.position.pixels == controller.position.maxScrollExtent &&
            isListing) {
          _getData(getlocation, getcategory);
        }
      });
    }
    _getlocationandcategoryData();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2.0,
        leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        title: Text("Rentit4me", style: TextStyle(color: kPrimaryColor)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 35,
                  width: size.width * 0.32,
                  decoration: BoxDecoration(
                      color: Colors.indigo.shade100,
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: DropdownButton(
                      value: locationvalue,
                      hint: Text("Location",
                          style: TextStyle(color: kPrimaryColor, fontSize: 12)),
                      isExpanded: true,
                      underline: Container(
                        height: 0,
                        color: Colors.deepPurpleAccent,
                      ),
                      icon: Visibility(
                          visible: true,
                          child: Icon(Icons.arrow_drop_down_sharp,
                              size: 20, color: kPrimaryColor)),
                      items: location.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items,
                              style: TextStyle(
                                  color: kPrimaryColor, fontSize: 12)),
                        );
                      }).toList(),
                      // After selecting the desired option,it will
                      // change button value to selected value
                      onChanged: (String newValue) {
                        setState(() {
                          locationvalue = newValue;
                        });
                      },
                    ),
                  ),
                ),
                Container(
                  height: 35,
                  width: size.width * 0.32,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.indigo.shade100,
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: DropdownButton(
                      hint: Text("Category",
                          style: TextStyle(color: kPrimaryColor, fontSize: 12)),
                      value: categoryvalue,
                      isExpanded: true,
                      underline: Container(
                        height: 0,
                        color: Colors.deepPurpleAccent,
                      ),
                      icon: Visibility(
                          visible: true,
                          child: Icon(Icons.arrow_drop_down_sharp,
                              size: 20, color: kPrimaryColor)),
                      items: category.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items,
                              maxLines: 2,
                              style: TextStyle(
                                  color: kPrimaryColor, fontSize: 12)),
                        );
                      }).toList(),
                      // After selecting the desired option,it will
                      // change button value to selected value
                      onChanged: (String newValue) {
                        setState(() {
                          categoryvalue = newValue;
                        });
                      },
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      skipvalue = 0;
                      _searchlist.clear();
                      _productdata.clear();
                    });
                    _getData(locationvalue, categoryvalue);
                  },
                  child: Container(
                    height: 35,
                    width: size.width * 0.20,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                        color: Colors.deepOrangeAccent,
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: Text("Let's Start!",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 12)),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(7.0),
            child: Container(
                margin: EdgeInsets.only(top: 5),
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.indigo.shade50,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: "Search Rentit4me",
                          hintStyle: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 14),
                          border: InputBorder.none,
                        ),
                        onChanged: (String text) {
                          setState(() {
                            _searchlist = _productdata.where((post) {
                              var title = post['title'].toLowerCase();
                              if (title
                                  .toLowerCase()
                                  .trim()
                                  .contains(text.toLowerCase().trim())) {
                                return title.contains(text);
                              } else {
                                return title.contains(text);
                              }
                            }).toList();
                          });
                        },
                      ),
                    ),
                    const Icon(Icons.search, color: kPrimaryColor)
                  ],
                )),
          ),
          Expanded(
              child: isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : _productdata.length == 0
                      ? Center(
                          child: Text("No data Found"),
                        )
                      : Padding(
                          padding: EdgeInsets.all(7.0),
                          child: SingleChildScrollView(
                            controller: controller,
                            child: Column(
                              children: [
                                GridView.builder(
                                    shrinkWrap: true,
                                    itemCount: _searchlist.length + 1,
                                    physics: ClampingScrollPhysics(),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 4.0,
                                            mainAxisSpacing: 4.0,
                                            childAspectRatio: 0.90),
                                    itemBuilder: (context, index) {
                                      if (index == _searchlist.length) {
                                        return Container(
                                            height: 32,
                                            width: double.infinity,
                                            child: SizedBox());
                                      } else {
                                        return InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ProductDetailScreen(
                                                            productid: _searchlist[
                                                                    index]['id']
                                                                .toString())));
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
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      Image.asset(
                                                          'assets/images/no_image.jpg'),
                                                  fit: BoxFit.cover,
                                                  imageUrl:
                                                      "${bannerpath + _searchlist[index]['upload_base_path'].toString() + _searchlist[index]['file_name'].toString()}",
                                                ),
                                                SizedBox(height: 5.0),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 5.0, right: 15.0),
                                                  child: Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Text(
                                                        _searchlist[index]
                                                                ['title']
                                                            .toString(),
                                                        maxLines: 2,
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 16)),
                                                  ),
                                                ),
                                                SizedBox(height: 5.0),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 4.0,
                                                          right: 4.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      SizedBox(
                                                        width:
                                                            size.width * 0.28,
                                                        child: Text(
                                                            "Starting from ${_searchlist[index]['currency'].toString()} ${_searchlist[index]['price'].toString()}",
                                                            style: TextStyle(
                                                                color:
                                                                    kPrimaryColor,
                                                                fontSize: 12)),
                                                      ),
                                                      Icon(
                                                          Icons.add_box_rounded,
                                                          color: kPrimaryColor)
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      }
                                    }),
                                SizedBox(height: 20),
                                listEnd
                                    ? SizedBox()
                                    : Center(
                                        child: CircularProgressIndicator(),
                                      ),
                              ],
                            ),
                          ),
                        ))
        ],
      ),
    );
  }

  bool listEnd = false;
  Future _getData(String location, String category) async {
    final body = {
      "city_name": location,
      "category": category,
      "limit": "10",
      "skip": skipvalue
    };
    var response = await http.post(Uri.parse(BASE_URL + searchingdata),
        body: jsonEncode(body),
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json'
        });
    setState(() {
      isLoading = false;
    });
    if (response.statusCode == 200) {
      var data = json.decode(response.body)['Response'];
      if (data.length > 0) {
        setState(() {
          skipvalue = skipvalue + 10;
        });
      } else {
        setState(() {
          listEnd = true;
        });
      }
      setState(() {
        _productdata.addAll(data);
        _searchlist.addAll(data);
      });
    } else {
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  Future _getlocationandcategoryData() async {
    var response = await http.get(Uri.parse(BASE_URL + homeUrl));
    if (response.statusCode == 200) {
      setState(() {
        location.clear();
        category.clear();
        for (int j = 0;
            j < jsonDecode(response.body)['Response']['cities'].length;
            j++) {
          location.add(jsonDecode(response.body)['Response']['cities'][j]
                  ['name']
              .toString());
        }
        for (int i = 0;
            i < jsonDecode(response.body)['Response']['categories'].length;
            i++) {
          category.add(jsonDecode(response.body)['Response']['categories'][i]
                  ['title']
              .toString());
        }
      });
    }
  }
}
