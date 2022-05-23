
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rentit4me/themes/constant.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  // Initial Selected Value
  String locationvalue;
  String categoryvalue;

  final List<Map> myProducts =
  List.generate(12, (index) => {"id": index, "name": "Product $index"})
      .toList();

  var location = [
    'Allahabad',
    'Agra',
    'New Delhi',
    'Punjab',
    'Varanasi',
  ];

  var category = [
    'Home Appliance',
    'Vehicles',
    'Electronics',
    'Entertainment',
    'Jewellery',
    'Property'
  ];

  final List<String> images = [
    'https://media.istockphoto.com/photos/young-woman-snorkeling-with-coral-reef-fishes-picture-id939931682?s=612x612',
    'https://media.istockphoto.com/photos/woman-relaxing-in-sleeping-bag-on-red-mat-camping-travel-vacations-in-picture-id1210134412?s=612x612',
    'https://media.istockphoto.com/photos/green-leaf-with-dew-on-dark-nature-background-picture-id1050634172?s=612x612',
    'https://media.istockphoto.com/photos/picturesque-morning-in-plitvice-national-park-colorful-spring-scene-picture-id1093110112?s=612x612',
    'https://media.istockphoto.com/photos/connection-with-nature-picture-id1174472274?s=612x612',
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
       appBar: AppBar(
         backgroundColor: Colors.white,
         elevation: 2.0,
         leading: Padding(
           padding: EdgeInsets.only(left: 10),
           child: Image.asset('assets/images/logo.png'),
         ),
         actions: [
           IconButton(onPressed:(){}, icon: Icon(Icons.edit, color: kPrimaryColor)),
           IconButton(onPressed:(){}, icon: Icon(Icons.account_circle, color: kPrimaryColor)),
           IconButton(onPressed:(){}, icon: Icon(Icons.menu, color: kPrimaryColor))
         ],
       ),
       body: SingleChildScrollView(
         child: Column(
           children: [
              Padding(
                  padding: EdgeInsets.all(7.0),
                  child: Container(
                    margin: EdgeInsets.only(top: 5),
                    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
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
                                fontSize: 14
                              ),
                              border: InputBorder.none,
                            ),
                            onChanged: (String keyword) {},
                          ),
                        ),
                        const Icon(Icons.search, color: kPrimaryColor)
                      ],
                    )),
              ),
              SizedBox(
                height: 160,
                width: double.infinity,
                child: SizedBox(
                  height: 200.0,
                  width: double.infinity,
                  child: Carousel(
                    dotSpacing: 15.0,
                    dotSize: 6.0,
                    dotIncreasedColor: kPrimaryColor,
                    dotBgColor: Colors.transparent,
                    indicatorBgPadding: 10.0,
                    dotPosition: DotPosition.bottomCenter,
                    images: images
                        .map((item) => Container(
                      child: Image.network(
                        item,
                        fit: BoxFit.cover,
                      ),
                    ))
                        .toList(),
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                       Container(
                         height: 35,
                         width: size.width * 0.32,
                         decoration: BoxDecoration(
                             color: Colors.indigo.shade100,
                             borderRadius: BorderRadius.all(Radius.circular(8))
                         ),
                         alignment: Alignment.center,
                         child: Padding(
                             padding: EdgeInsets.symmetric(horizontal: 8.0),
                             child: DropdownButton(
                               value: locationvalue,
                               hint: Text("Location", style: TextStyle(color: kPrimaryColor, fontSize: 12)),
                               isExpanded: true,
                               underline: Container(
                                 height: 0,
                                 color: Colors.deepPurpleAccent,
                               ),
                               icon: Visibility (visible:true, child: Icon(Icons.arrow_drop_down_sharp, size: 20, color: kPrimaryColor)),
                               items: location.map((String items) {
                                 return DropdownMenuItem(
                                   value: items,
                                   child: Text(items, style: TextStyle(color: kPrimaryColor, fontSize: 12)),
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
                            borderRadius: BorderRadius.all(Radius.circular(8))
                        ),
                         child: Padding(
                             padding: EdgeInsets.symmetric(horizontal: 8.0),
                             child: DropdownButton(
                               hint: Text("Category", style: TextStyle(color: kPrimaryColor, fontSize: 12)),
                               value: categoryvalue,
                               isExpanded: true,
                               underline: Container(
                                 height: 0,
                                 color: Colors.deepPurpleAccent,
                               ),
                               icon: Visibility (visible:true, child: Icon(Icons.arrow_drop_down_sharp, size: 20, color: kPrimaryColor)),
                               items: category.map((String items) {
                                 return DropdownMenuItem(
                                   value: items,
                                   child: Text(items, style: TextStyle(color: kPrimaryColor, fontSize: 12)),
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
                       Container(
                         height: 35,
                         width: size.width * 0.20,
                         alignment: Alignment.center,
                         decoration: const BoxDecoration(
                             color: Colors.deepOrangeAccent,
                             borderRadius: BorderRadius.all(Radius.circular(8))
                         ),
                         child: Text("Let's Start!", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12)),
                       )
                    ],
                  ),
              ),
              const Padding(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text("Rent From Our Wide Range Of Categories", style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 12)),
                  ),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0
                      ),
                      itemCount: myProducts.length,
                      itemBuilder: (BuildContext ctx, index) {
                        return Container(
                          alignment: Alignment.center,
                          child: Text(myProducts[index]["name"]),
                          decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(15)),
                        );
                      }),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: size.width * 0.18,
                      height: 30,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Colors.deepOrangeAccent,
                        borderRadius: BorderRadius.all(Radius.circular(4.0))
                      ),
                      child: Text("See All", style: TextStyle(color: Colors.white, fontSize: 10)),
                    ),
                  ),
              ),
              SizedBox(
               height: 160,
               width: double.infinity,
               child: SizedBox(
                 height: 200.0,
                 width: double.infinity,
                 child: Carousel(
                   dotSpacing: 15.0,
                   dotSize: 6.0,
                   dotIncreasedColor: kPrimaryColor,
                   dotBgColor: Colors.transparent,
                   indicatorBgPadding: 10.0,
                   dotPosition: DotPosition.bottomCenter,
                   images: images
                       .map((item) => Container(
                     child: Image.network(
                       item,
                       fit: BoxFit.cover,
                     ),
                   ))
                       .toList(),
                 ),
               ),
             ),
           ],
         ),
       ),
    );
  }
}
