import 'package:carousel_pro/carousel_pro.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rentit4me/themes/constant.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key key}) : super(key: key);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {

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
              padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
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
            Padding(
                padding: EdgeInsets.only(left: 5, bottom: 10, right: 5),
                child: Container(
                  height: 30,
                  color: kContainerColor,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_on_outlined, color: Colors.deepOrangeAccent),
                      Text("Gaurav Singh - Ghaziabad near lal kuan", style: TextStyle(color: Colors.black, fontSize: 12))
                    ],
                  ),
                ),
            ),
            const Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Text("Product Name", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text("Car is in very Decent Condition, with All Original paint,its A Top Model With Sunroof And Automatic Transaction", style: TextStyle(color: kPrimaryColor, fontSize: 12, fontWeight: FontWeight.w500)),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(left: 15, right: 15, top: 10),
                child: SizedBox(
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
            ),
            Padding(
                padding: EdgeInsets.only(left: 15, top: 10, right: 10),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    height: 40,
                    width: double.infinity,
                    color: kContainerColor,
                    child: ExpandableNotifier(
                        child: ExpandablePanel(
                            header: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  "Product Information",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: kPrimaryColor
                                  )),
                            ),
                            expanded: Text(
                              "Test",
                              textAlign: TextAlign.justify,
                            ))),
                  ),
                ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 15, top: 10, right: 10),
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  height: 40,
                  width: double.infinity,
                  color: kContainerColor,
                  child: ExpandableNotifier(
                      child: ExpandablePanel(
                          header: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                "Additional Information",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: kPrimaryColor
                                )),
                          ),
                          expanded: Text(
                            "Test",
                            textAlign: TextAlign.justify,
                          ))),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 15, top: 10, right: 10),
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  height: 40,
                  width: double.infinity,
                  color: kContainerColor,
                  child: ExpandableNotifier(
                      child: ExpandablePanel(
                          header: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                "Shipping Information",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: kPrimaryColor
                                )),
                          ),
                          expanded: Text(
                            "Test",
                            textAlign: TextAlign.justify,
                          ))),
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     Container(
                       height: 40,
                       decoration: const BoxDecoration(
                           color: kPrimaryColor,
                           borderRadius: BorderRadius.all(Radius.circular(20))
                       ),
                       width: size.width * 0.40,
                       alignment: Alignment.center,
                       child: Text("ADD TO CART", style: TextStyle(color: Colors.white, fontSize: 14)),
                     ),
                     SizedBox(width: 20),
                     Container(
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Colors.deepOrangeAccent,
                        borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      width: size.width * 0.40,
                      alignment: Alignment.center,
                      child: Text("RENT NOW", style: TextStyle(color: Colors.white, fontSize: 14)),
                    ),
                  ],
                ),
            ),

            SizedBox(height: 10),
            Container(
              height: 120,
              width: double.infinity,
              color: kOfferCardColor,
              child: Padding(
                  padding: EdgeInsets.all(6.0),
                  child: Column(
                    children: [
                       Row(
                         children: [
                            Image.asset('assets/images/discount.png', scale: 4, color: Colors.red),
                            SizedBox(width: 7),
                            Text("Offers", style: TextStyle(color: Colors.red))
                         ],
                       ),
                       SizedBox(height: 5.0),
                       Container(
                         height: 80,
                         width: double.infinity,
                         child: ListView.builder(
                             itemCount: 5,
                             shrinkWrap: true,
                             scrollDirection: Axis.horizontal,
                             itemBuilder: (BuildContext context,int index){
                               return Container(
                                 height: 80,
                                 width: 140,
                                 child: Card(
                                   shape: RoundedRectangleBorder(
                                     borderRadius: BorderRadius.circular(5.0),
                                   ),
                                   child: Padding(
                                     padding: const EdgeInsets.only(left: 4.0, top: 4.0),
                                     child: Column(
                                       crossAxisAlignment: CrossAxisAlignment.start,
                                       children: [
                                         Text("Special Discount", style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 12, fontWeight: FontWeight.bold)),
                                         SizedBox(height: 2.0),
                                         Text("Lorem ipsum is placeholder text commonly used in the graphic, print.", style: TextStyle(fontSize: 8.0, color: Colors.black)),
                                         SizedBox(height: 5.0),
                                         Row(
                                           children: [
                                              Text("Explore", style: TextStyle(color: kPrimaryColor, fontSize: 10)),
                                              Icon(Icons.arrow_forward_ios_rounded, size: 10, color: kPrimaryColor)
                                           ],
                                         )
                                       ],
                                     ),
                                   ),
                                 ),
                               );
                             }
                         ),
                       ),
                    ],
                  ),
              ),
            ),
            SizedBox(height: 10),
            Text("YOU MAY ALSO LIKE", style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 14, fontWeight: FontWeight.w500)),
            SizedBox(height: 10),
            Container(
              height: 120,
              width: double.infinity,
              child: ListView.separated(
                  itemCount: 5,
                  separatorBuilder: (BuildContext context, int index) => Divider(color: Colors.white, height: 2),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index){
                     return Column(
                       children: [
                           Container(
                             height: 80,
                             width: 80,
                             child: Image.asset('assets/images/car1.png', fit: BoxFit.fill),
                           ),
                           SizedBox(height: 4.0),
                           Align(
                               alignment : Alignment.topLeft,
                               child: Text("Car", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500))
                           ),
                           SizedBox(height: 4.0),
                           Text("\u20B9 59", style: TextStyle(color: kPrimaryColor, fontSize: 14)),
                       ],
                     );
                  }
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: 300,
              width: double.infinity,
              color: kContainerColor,
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Text("Today's Special Deals", style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 14)),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Container(
                      height: 120,
                      width: double.infinity,
                      child: Image.asset('assets/images/offer.jpg', fit: BoxFit.fitWidth),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Container(
                      height: 120,
                      width: double.infinity,
                      child: Image.asset('assets/images/offer.jpg', fit: BoxFit.fitWidth),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
