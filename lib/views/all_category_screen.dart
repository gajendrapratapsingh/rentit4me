import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rentit4me/helper/loader.dart';
import 'package:rentit4me/network/api.dart';
import 'package:rentit4me/themes/constant.dart';
import 'package:rentit4me/views/user_finder_data_screen.dart';

class AllCategoryScreen extends StatefulWidget {
  const AllCategoryScreen({Key key}) : super(key: key);

  @override
  State<AllCategoryScreen> createState() => _AllCategoryScreenState();
}

class _AllCategoryScreenState extends State<AllCategoryScreen> {

  List<dynamic> myProducts = [];
  List<dynamic> category = [];

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
        title: Text("All Categories", style: TextStyle(color: kPrimaryColor)),
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
                  showLaoding(context);
                  var response = await http.post(Uri.parse(BASE_URL + categoryclick),
                      body: jsonEncode({"category": category[index].toLowerCase()
                      }),
                      headers: {
                        "Accept": "application/json",
                        'Content-Type': 'application/json'
                      });
                  Navigator.of(context, rootNavigator: true).pop();
                  if (jsonDecode(response.body)['ErrorCode'] == 0) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => UserfinderDataScreen(data: jsonDecode(response.body)['Response'])));
                  } else {
                     showToast("No result found");
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
    var response = await http.get(Uri.parse(BASE_URL + homeUrl));
    if (response.statusCode == 200) {
      setState(() {
        myProducts.clear();
        category.clear();

        for (int i = 0; i < jsonDecode(response.body)['Response']['categories'].length; i++) {
          category.add(jsonDecode(response.body)['Response']['categories'][i]['title'].toString());
          myProducts.add(imagepath + jsonDecode(response.body)['Response']['categories'][i]['image'].toString());
        }

        _check = true;
      });
    }
  }
}
