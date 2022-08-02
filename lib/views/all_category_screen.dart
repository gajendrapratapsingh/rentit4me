import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rentit4me/helper/loader.dart';
import 'package:rentit4me/network/api.dart';
import 'package:rentit4me/themes/constant.dart';
import 'package:rentit4me/views/user_finder_data_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllCategoryScreen extends StatefulWidget {
  const AllCategoryScreen({Key key}) : super(key: key);

  @override
  State<AllCategoryScreen> createState() => _AllCategoryScreenState();
}

class _AllCategoryScreenState extends State<AllCategoryScreen> {

  List<dynamic> myProducts = [];
  List<dynamic> category = [];
  List categorylistData = [];
  String categoryslugname;

  bool _check = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
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
        title: const Text("All Categories", style: TextStyle(color: kPrimaryColor)),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: myProducts.length == 0 || myProducts.isEmpty
            ? Center(child: CircularProgressIndicator())
            : GridView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0),
            itemCount: myProducts.length,
            itemBuilder: (BuildContext ctx, index) {
              return InkWell(
                onTap: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  print("......///"+prefs.getString('city'));
                  showLaoding(context);
                  categorylistData.forEach((element) {
                      if(element['title'].toString() == category[index].toString()){
                         setState((){
                            categoryslugname = element['slug'].toString();
                         });
                      }
                  });
                  print(jsonEncode({
                    "city_name": prefs.getString('city'),
                    "category": categoryslugname,
                    "exclude": "1",
                    "search" : ""
                  }));
                  var response = await http.post(Uri.parse(BASE_URL + filterUrl),
                      body: jsonEncode({
                        "city_name": prefs.getString('city'),
                        "category": categoryslugname,
                        "exclude": "1",
                        "search" : ""
                      }),
                      headers: {
                        "Accept": "application/json",
                        'Content-Type': 'application/json'
                      });
                  print("............"+response.body);
                  Navigator.of(context, rootNavigator: true).pop();
                  if (jsonDecode(response.body)['ErrorCode'] == 0) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => UserfinderDataScreen(getlocation: prefs.getString('city'), getcategory: category[index].toString(), getcategoryslug: categoryslugname, data: jsonDecode(response.body)['Response']['leads'])));
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
                            style: TextStyle(color: Colors.black, fontSize: 12)),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(
                          Radius.circular(12)),
                      child: Container(
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: myProducts[index],
                        ),
                        decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius:
                            BorderRadius.circular(15)),
                      ),
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }

  Future _getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
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
        myProducts.clear();
        category.clear();

        categorylistData.addAll(jsonDecode(response.body)['Response']['categories']);
        jsonDecode(response.body)['Response']['categories'].forEach((element){
          category.add(element['title'].toString());
          myProducts.add(imagepath + element['image'].toString());
        });

        print(category.toString());
        print(myProducts.toString());

        _check = true;
      });
    }
  }


}
