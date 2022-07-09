import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rentit4me/themes/constant.dart';
import 'package:timeline_tile/timeline_tile.dart';

class DeliveryStatusScreen extends StatefulWidget {
  const DeliveryStatusScreen({Key key}) : super(key: key);

  @override
  State<DeliveryStatusScreen> createState() => _DeliveryStatusScreenState();
}

class _DeliveryStatusScreenState extends State<DeliveryStatusScreen> {

  bool _loading = false;

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
        title: Text("Delivery Status", style: TextStyle(color: kPrimaryColor)),
        centerTitle: true,
      ),
      body: ModalProgressHUD(
          inAsyncCall: _loading,
          color: kPrimaryColor,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _loading == true ? SizedBox() : Column(
                children: [
                  Card(
                    elevation: 4.0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                               Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                    const Text("Product", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w700)),
                                    const SizedBox(height: 5.0),
                                    SizedBox(
                                       width: size.width * 0.50,
                                       child: Text("Black and white headphone", style: TextStyle(color: Colors.black , fontSize: 16))
                                    )
                                 ],
                               ),
                               Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                     const Text("Order Placed", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w700)),
                                     const SizedBox(height: 5.0),
                                     Text("30/07/2022", style: TextStyle(color: Colors.black , fontSize: 16))
                                   ],
                               )
                            ],
                          ),
                          SizedBox(height: 8.0),
                          Row(
                            children: [
                              SizedBox(
                                width : size.width * 0.60,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Total", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w700)),
                                    const SizedBox(height: 5.0),
                                    Text("Rs. 10,000.00", style: TextStyle(color: Colors.black , fontSize: 16))
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Ship To", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w700)),
                                  const SizedBox(height: 5.0),
                                  Text("Gajendra", style: TextStyle(color: Colors.black , fontSize: 16))
                                ],
                              )
                            ],
                          ),
                          SizedBox(height: 8.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Address", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w700)),
                                  const SizedBox(height: 5.0),
                                  SizedBox(
                                      width: size.width * 0.50,
                                      child: Text("abc, Noida, Uttar Pradesh, India", style: TextStyle(color: Colors.black , fontSize: 16))
                                  )
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Order From", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w700)),
                                  const SizedBox(height: 5.0),
                                  Text("Gagan", style: TextStyle(color: Colors.black , fontSize: 16))
                                ],
                              )
                            ],
                          ),
                          SizedBox(height: 8.0),
                          Align(
                            alignment: Alignment.topRight,
                            child: InkWell(
                              onTap: (){},
                              child: Container(
                                height: 40,
                                width: 80,
                                decoration: BoxDecoration(
                                  color: Colors.deepOrangeAccent,
                                  borderRadius: BorderRadius.circular(8.0)
                                ),
                                alignment: Alignment.center,
                                child: const Text("View", style: TextStyle(color: Colors.white)),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Card(
                    elevation: 4.0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                               Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                    Text("Order ID : 23137845", style: TextStyle(color: Colors.black, fontSize: 14)),
                                    SizedBox(height: 5.0),
                                    Text("Place On : 30/07/2022")
                                 ],
                               ),
                               TextButton(onPressed: (){}, child: Text("View Detail", style: TextStyle(color: Colors.black)))
                            ],
                          ),
                          Divider(color: Colors.black, thickness: 1, height: 15.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                               Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                    Text("Black and white headphone", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400)),
                                    SizedBox(height: 4.0),
                                    Text("Qty : 2"),
                                    SizedBox(height: 8.0),
                                    Text("\u20B9 10,000.00 via (COD)", style: TextStyle(color: Colors.black, fontSize: 14)),
                                    SizedBox(height: 8.0),
                                    SizedBox(
                                        width: size.width * 0.60,
                                        child: Text("Tracking Status on : 16.40PM, Today", style: TextStyle(color: Colors.black, fontSize: 14))
                                    ),
                                    SizedBox(height: 7.0),
                                    InkWell(
                                      onTap: (){},
                                      child: Container(
                                        height: 40,
                                        width: 150,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: Colors.deepOrangeAccent,
                                          borderRadius: BorderRadius.circular(8.0)
                                        ),
                                        child: Text("Reached Hub, delhi", style: TextStyle(color: Colors.white)),
                                      ),
                                    )

                                 ],
                               ),
                               Container(
                                 height: 80,
                                 width: 80,
                                 decoration: BoxDecoration(
                                   borderRadius: BorderRadius.circular(4.0)
                                 ),
                                 child: Image.asset('assets/images/no_image.jpg'),
                               )
                            ],
                          ),
                          SizedBox(height: 20),
                          Container(
                            height: 80,
                            width: size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TimelineTile(
                                  axis: TimelineAxis.horizontal,
                                  alignment: TimelineAlign.start,
                                  hasIndicator: true,
                                  isFirst: true,
                                  endChild: Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: Text("Placed\n20/05/2022", textAlign: TextAlign.center),
                                  ),
                                  beforeLineStyle: LineStyle(thickness: 2),
                                  indicatorStyle: IndicatorStyle(
                                      indicator: Container(
                                        height: 20,
                                        width: 20,
                                       alignment: Alignment.center,
                                       decoration: const BoxDecoration(
                                         color: Colors.deepOrangeAccent,
                                         shape: BoxShape.circle
                                       ),
                                       child: Text("1", style: TextStyle(color: Colors.white)),
                                    )
                                  ),
                                ),
                                TimelineTile(
                                  axis: TimelineAxis.horizontal,
                                  alignment: TimelineAlign.start,
                                  hasIndicator: true,
                                  beforeLineStyle: LineStyle(thickness: 2),
                                  endChild: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 15),
                                      child: Text("Shipped\n20/06/2022", textAlign: TextAlign.center),
                                  ),
                                  indicatorStyle: IndicatorStyle(
                                      drawGap: true,
                                      indicator: Container(
                                        height: 20,
                                        width: 20,
                                        alignment: Alignment.center,
                                        decoration: const BoxDecoration(
                                            color: Colors.deepOrangeAccent,
                                            shape: BoxShape.circle
                                        ),
                                        child: Text("2", style: TextStyle(color: Colors.white)),
                                      )
                                  ),
                                ),
                                TimelineTile(
                                  axis: TimelineAxis.horizontal,
                                  alignment: TimelineAlign.start,
                                  hasIndicator: true,
                                  beforeLineStyle: LineStyle(thickness: 2),
                                  isLast: true,
                                  endChild: Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Text("Delivered\n20/05/2022", textAlign: TextAlign.center),
                                  ),
                                  indicatorStyle: IndicatorStyle(
                                      drawGap: true,
                                      indicator: Container(
                                        height: 20,
                                        width: 20,
                                        alignment: Alignment.center,
                                        decoration: const BoxDecoration(
                                            color: Colors.deepOrangeAccent,
                                            shape: BoxShape.circle
                                        ),
                                        child: Text("3", style: TextStyle(color: Colors.white)),
                                      )
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Card(
                    elevation: 4.0,
                    child: Container(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Need Help With Your Item", style: TextStyle(color: kPrimaryColor, fontSize: 16, fontWeight: FontWeight.w700)),
                            SizedBox(height: 6.0),
                            Text("You can contact us 24*7", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("+123456789", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400)),
                                IconButton(onPressed: (){}, icon: Icon(Icons.phone, color: Colors.black, size: 24))
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
      ),
    );
  }


}
