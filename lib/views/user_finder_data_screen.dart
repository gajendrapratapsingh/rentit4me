import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rentit4me/network/api.dart';
import 'package:rentit4me/themes/constant.dart';
import 'package:http/http.dart' as http;
import 'package:rentit4me/views/product_detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserfinderDataScreen extends StatefulWidget {
  String getlocation;
  String getcategory;
  String getcategoryslug;
  List data = [];
  UserfinderDataScreen({this.getlocation, this.getcategory, this.getcategoryslug, this.data});

  @override
  _UserfinderDataScreenState createState() => _UserfinderDataScreenState(getlocation, getcategory, getcategoryslug);
}

class _UserfinderDataScreenState extends State<UserfinderDataScreen> {
  String getlocation;
  String getcategory;
  String getcategoryslug;
  _UserfinderDataScreenState(this.getlocation, this.getcategory, this.getcategoryslug);

  int skipvalue = 0;
  int pricesorting;
  int renttyping;

  String locationvalue;
  String categoryvalue;

  List location = [];
  List category = [];
  List categorylistData = [];
  String categoryslugname;

  List<dynamic> _searchlist = [];
  List<dynamic> _productdata = [];
  bool isLoading = false;

  bool isListing = true;
  final controller = ScrollController();
  final TextEditingController typeAheadController = TextEditingController();
  final searchController = TextEditingController();

  bool isSearching = false;

  String _priceGroupValue;
  String _rentGroupValue;

  String usercity;
  String userstate;
  String usercountry;

  @override
  void initState() {
    super.initState();
    _getlocationandcategoryData();
    if(widget.data.length > 0) {
      setState(() {
        _productdata.clear();
        _searchlist.clear();
        _productdata.addAll(widget.data);
        _searchlist.addAll(widget.data);
         isLoading = false;
         listEnd = true;
      });
    } else {
      _getData(getlocation, getcategoryslug);
      controller.addListener(() {
        if(controller.position.pixels == controller.position.maxScrollExtent && isListing) {
          _getData(getlocation, getcategoryslug);
        }
      });
    }

    _getuserlocation();
  }

  _getuserlocation() async{
     SharedPreferences prefs = await SharedPreferences.getInstance();
     usercity = prefs.getString('city');
     userstate = prefs.getString('state');
     usercountry = prefs.getString('country');
  }

  Future<void> _setlocationorcategory(String lc, String cat) async{
    setState(() {
      locationvalue = lc != null || lc != "" ? lc : "";
      categoryvalue = cat != null || cat != "" ? cat : "";
    });
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
            child: const Icon(
              Icons.arrow_back,
              color: kPrimaryColor,
            )),
        title: !isSearching
      ? const Text("Rentit4me", style: TextStyle(color: kPrimaryColor))
        : Container(
            margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
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
                InkWell(
                  onTap: (){
                    FocusScope.of(context).unfocus();
                    setState((){
                       searchController.text = "";
                       _searchlist.clear();
                       _searchlist.addAll(_productdata);
                       isSearching = !isSearching;
                    });
                  },
                  child: const Icon(Icons.clear, color: kPrimaryColor),
                )
              ],
            )),
        centerTitle: true,
        actions: [
          isSearching == true ? SizedBox() : IconButton(onPressed: (){
             setState((){
               isSearching = !isSearching;
             });
          }, icon: const Icon(Icons.search, color: kPrimaryColor))
        ],
      ),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Container(
                  //   height: 35,
                  //   width: size.width * 0.32,
                  //   decoration: BoxDecoration(
                  //       color: Colors.indigo.shade100,
                  //       borderRadius: BorderRadius.all(Radius.circular(8))),
                  //   alignment: Alignment.center,
                  //   child: Padding(
                  //     padding: EdgeInsets.symmetric(horizontal: 8.0),
                  //     child: DropdownButton(
                  //       value: locationvalue,
                  //       hint: const Text("Location", style: TextStyle(color: kPrimaryColor, fontSize: 12)),
                  //       isExpanded: true,
                  //       underline: Container(
                  //         height: 0,
                  //         color: Colors.deepPurpleAccent,
                  //       ),
                  //       icon: const Visibility(visible: true, child: Icon(Icons.arrow_drop_down_sharp, size: 20, color: kPrimaryColor)),
                  //       items: location.map((items) {
                  //         return DropdownMenuItem(
                  //           value: items,
                  //           child: Text(items, style: TextStyle(color: kPrimaryColor, fontSize: 12)),
                  //         );
                  //       }).toList(),
                  //       // After selecting the desired option,it will
                  //       // change button value to selected value
                  //       onChanged: (newValue) {
                  //         setState(() {
                  //           locationvalue = newValue;
                  //         });
                  //       },
                  //     ),
                  //   ),
                  // ),
                  Container(
                    height: 35,
                    width: size.width * 0.38,
                    alignment: Alignment.center,
                    child: TypeAheadField(
                      //hideOnLoading: false,
                      textFieldConfiguration: TextFieldConfiguration(
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
                        borderRadius: const BorderRadius.all(Radius.circular(8))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: DropdownButton(
                        hint: const Text("Category", style: TextStyle(color: kPrimaryColor, fontSize: 12)),
                        value: categoryvalue,
                        isExpanded: true,
                        underline: Container(
                          height: 0,
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
                        onChanged: (newValue) {
                          setState(() {
                            categoryvalue = newValue;
                          });
                        },
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      categorylistData.forEach((element) {
                          if(element['title'].toString() == categoryvalue){
                             setState((){
                               categoryslugname = element['slug'].toString();
                             });
                          }
                      });
                      setState(() {
                         skipvalue = 0;
                        _searchlist.clear();
                        _productdata.clear();
                      });
                      _getData(locationvalue, categoryslugname);
                    },
                    child: Container(
                      height: 35,
                      width: size.width * 0.20,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                          color: Colors.deepOrangeAccent,
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      child: const Text("Let's Start!", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12)),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(7.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding:EdgeInsets.only(left: 8.0),
                    child: Text("FILTER", style: TextStyle(color: Colors.deepOrangeAccent, fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(height: 6.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                      children: const[
                         Text("SORT BY", style: TextStyle(color: Colors.deepOrangeAccent, fontWeight: FontWeight.w700)),
                         Text("(Price)", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700))
                      ],
                    )
                  ),
                  RadioGroup<String>.builder(
                    horizontalAlignment: MainAxisAlignment.start,
                    groupValue: _priceGroupValue,
                    direction: Axis.horizontal,
                    onChanged: (value) => setState(() {
                      _priceGroupValue = value;
                      if(_priceGroupValue == "Lowest To Highest"){
                        // setState((){
                        //   _productdata.sort((a, b) => a['price'].compareTo(b['price']));
                        //   _searchlist.clear();
                        //   _searchlist.addAll(_productdata);
                        // });
                        // print("......"+_productdata.toString());
                        //_getfilterData(category, location, sortby, search, country, state, city, pattern, renttype)
                        _getfilterData(categoryslugname, locationvalue, "0", "", usercountry, userstate, usercity, searchController.text, _rentGroupValue);
                      }
                      else{
                        // setState((){
                        //   _productdata.sort((a, b) => b['price'].compareTo(a['price']));
                        //   _searchlist.clear();
                        //   _searchlist.addAll(_productdata);
                        // });
                        // // _getfilterData(locationvalue, categoryvalue, "1");
                        _getfilterData(categoryslugname, locationvalue, "1", "", usercountry, userstate, usercity, searchController.text, _rentGroupValue);
                      }
                    }),
                    textStyle: const TextStyle(fontSize: 12),
                    items: const ["Lowest To Highest", "Highest To Lowest"],
                    itemBuilder: (item) => RadioButtonBuilder(item,
                    ),
                    activeColor: Colors.red,
                  ),
                  Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Row(
                        children: const[
                          Text("SORT BY", style: TextStyle(color: Colors.deepOrangeAccent, fontWeight: FontWeight.w700)),
                          Text("(Rent type)", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700))
                        ],
                      )
                  ),
                  Column(
                    children: [
                      Padding(
                          padding: EdgeInsets.only(right: size.width * 0.28),
                          child: RadioGroup<String>.builder(
                            groupValue: _rentGroupValue,
                            direction: Axis.horizontal,
                            onChanged: (value) => setState(() {
                              _rentGroupValue = value;
                              if(_rentGroupValue == "Hourly"){
                                // setState((){
                                //   _productdata.sort((a, b) => a['price'].compareTo(b['price']));
                                //   _searchlist.clear();
                                //   _searchlist.addAll(_productdata);
                                // });
                                _getfilterData(categoryslugname, locationvalue, "0", "", usercountry, userstate, usercity, searchController.text, _rentGroupValue);
                              }
                              else{
                                _getfilterData(categoryslugname, locationvalue, "0", "", usercountry, userstate, usercity, searchController.text, _rentGroupValue);
                              }
                            }),
                            textStyle: const TextStyle(fontSize: 12),
                            items: const ["Hourly", "Weekly"],
                            itemBuilder: (item) => RadioButtonBuilder(item),
                            activeColor: Colors.red,
                          ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: size.width * 0.29),
                        child: RadioGroup<String>.builder(
                          groupValue: _rentGroupValue,
                          direction: Axis.horizontal,
                          onChanged: (value) => setState(() {
                            _rentGroupValue = value;
                            if(_rentGroupValue == "Hourly"){
                              // setState((){
                              //   _productdata.sort((a, b) => a['price'].compareTo(b['price']));
                              //   _searchlist.clear();
                              //   _searchlist.addAll(_productdata);
                              // });
                              _getfilterData(categoryslugname, locationvalue, "0", "", usercountry, userstate, usercity, searchController.text, _rentGroupValue);
                            }
                            else{
                              _getfilterData(categoryslugname, locationvalue, "0", "", usercountry, userstate, usercity, searchController.text, _rentGroupValue);
                            }
                          }),
                          textStyle: const TextStyle(fontSize: 12),
                          items: const ["Monthly", "Yearly"],
                          itemBuilder: (item) => RadioButtonBuilder(item),
                          activeColor: Colors.red,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            /*Padding(
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
            ),*/
            Expanded(
                child: isLoading
                    ? const Center(child: SizedBox())
                    : _productdata.length == 0
                        ? const Center(child: Text("No data found at selected location"))
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
                                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              crossAxisSpacing: 4.0,
                                              mainAxisSpacing: 4.0,
                                              childAspectRatio: 1.0),
                                      itemBuilder: (context, index) {
                                        if (index == _searchlist.length) {
                                          return Container(
                                              height: 32,
                                              width: double.infinity,
                                              child: SizedBox());
                                        } else {
                                          return InkWell(
                                            onTap: () {
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailScreen(productid: _searchlist[index]['id'].toString())));
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
                                                        Image.asset('assets/images/no_image.jpg'),
                                                    fit: BoxFit.cover,
                                                    imageUrl:
                                                        sliderpath + _searchlist[index]['upload_base_path'].toString() + _searchlist[index]['file_name'].toString(),
                                                  ),
                                                  const SizedBox(height: 5.0),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 5.0, right: 15.0),
                                                    child: Align(
                                                      alignment: Alignment.topLeft,
                                                      child: Text(_searchlist[index]['title'].toString(),
                                                          maxLines: 2,
                                                          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 16)),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 5.0),
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
                                                          width: size.width * 0.28,
                                                          child: Text(
                                                              "Starting from ${_searchlist[index]['currency'].toString()} ${_searchlist[index]['price'].toString()}",
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
                                      }),
                                  const SizedBox(height: 20),
                                  //listEnd ? const SizedBox() : const Center(child: CircularProgressIndicator()),
                                ],
                              ),
                            ),
                          ))
          ],
        ),
      ),
    );
  }

  bool listEnd = false;
  Future _getData(String location, String category) async {
    setState((){
       isLoading = true;
    });
    print(jsonEncode({
      "city_name": location,
      "category": category,
      "limit": "10",
      "skip": skipvalue
    }));
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
    print("new data "+response.body);
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      isLoading = true;
    });
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
        isLoading = false;
        location.clear();
        category.clear();
        jsonDecode(response.body)['Response']['cities'].forEach((element){location.add(element['name'].toString());});
        categorylistData.addAll(jsonDecode(response.body)['Response']['categories']);
        jsonDecode(response.body)['Response']['categories'].forEach((element){category.add(element['title'].toString());});
      });
      _setlocationorcategory(getlocation, getcategory);
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

  Future<void> _getfilterData(String category, String location, String sortby, String search, String country, String state, String city, String pattern, String renttype) async{
    _productdata.clear();
    _searchlist.clear();
    setState((){
      isLoading = true;
    });
    print(jsonEncode({
      "category": category,
      "city_name": location,
      "sortby": sortby,
      "search" : search,
      "country" : country,
      "state" : state,
      "city" : city,
      "q" : pattern,
      "tenure" : renttype
    }));
    final body = {
      "category": category,
      "city_name": location,
      "sortby": sortby,
      "search" : search,
      "country" : country,
      "state" : state,
      "city" : city,
      "q" : pattern,
      "tenure" : renttype
    };
    var response = await http.post(Uri.parse(BASE_URL + filterUrl),
        body: jsonEncode(body),
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json'
        });
    setState(() {
      isLoading = false;
    });
    print("response data "+response.body);
    if (response.statusCode == 200) {
      var data = json.decode(response.body)['Response']['leads'];
      setState(() {
        _productdata.addAll(data);
        _searchlist.addAll(data);
      });
    } else {
      throw Exception('Failed to get data due to ${response.body}');
    }
  }
}
