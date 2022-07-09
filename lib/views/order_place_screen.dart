import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rentit4me/themes/constant.dart';

class OrderPlaceScreen extends StatefulWidget {
  const OrderPlaceScreen({Key key}) : super(key: key);

  @override
  State<OrderPlaceScreen> createState() => _OrderPlaceScreenState();
}

class _OrderPlaceScreenState extends State<OrderPlaceScreen> {

  bool _loading = false;

  //shipping address
  String pickuplocation;
  String shippingaddress;
  String paymentmethod = "Cash On Delivery";

  //item detail
  String subtotal;
  String itemlength;
  String itemwidth;
  String itemheight;
  String itemweight;

  List<String> paymentmethodlist = ['Cash On Delivery', 'Prepaid'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
        title: Text("Order Place", style: TextStyle(color: kPrimaryColor)),
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
                          const Text("Enter details for shipping address*", style: TextStyle(color: kPrimaryColor, fontSize: 18, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 10),
                          const Text("Pickup location*", style: TextStyle(color: kPrimaryColor, fontSize: 18)),
                          const SizedBox(height: 5.0),
                          Padding(
                            padding: const EdgeInsets.only(left: 0.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.deepOrangeAccent)
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.deepOrangeAccent,)
                                ),
                                contentPadding: EdgeInsets.only(left: 5),
                                hintText: pickuplocation,
                                border: InputBorder.none,
                              ),
                              onChanged: (value){
                                setState((){
                                   pickuplocation = value;
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text("Shipping Address*", style: TextStyle(color: kPrimaryColor, fontSize: 18)),
                          const SizedBox(height: 5.0),
                          Padding(
                            padding: const EdgeInsets.only(left: 0.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.deepOrangeAccent)
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.deepOrangeAccent,)
                                ),
                                suffixIcon: IconButton(
                                  onPressed: (){
                                    if(shippingaddress == null || shippingaddress == ""){
                                      _determinePosition().then((value) => _getAddress(value));
                                    }
                                  },
                                  icon: Icon(Icons.my_location_sharp, size: 24, color: shippingaddress == null ? Colors.deepOrangeAccent : Colors.grey),
                                ),
                                contentPadding: EdgeInsets.only(left: 5),
                                hintText: shippingaddress,
                                border: InputBorder.none,
                              ),
                              onChanged: (value){
                                setState((){
                                   shippingaddress = value;
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text("Payment Method*", style: TextStyle(color: kPrimaryColor, fontSize: 18)),
                          const SizedBox(height: 5.0),
                          Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1,
                                      color: Colors.deepOrangeAccent
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(12))
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    hint: const Text("Select Payment Method"),
                                    isExpanded: true,
                                    value: paymentmethod,
                                    icon: const Icon(Icons.arrow_drop_down_sharp),
                                    items: paymentmethodlist.map((String items) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: Text(items),
                                      );
                                    }).toList(),
                                    onChanged: (String changevalue) {
                                      setState(() {
                                          paymentmethod = changevalue;
                                      });
                                    },
                                  ),
                                ),
                              )
                          ),
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
                          const Text("Enter details for Item*", style: TextStyle(color: kPrimaryColor, fontSize: 18, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 10.0),
                          const Text("Sub Total*", style: TextStyle(color: kPrimaryColor, fontSize: 18)),
                          const SizedBox(height: 5.0),
                          Padding(
                            padding: const EdgeInsets.only(left: 0.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.deepOrangeAccent)
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.deepOrangeAccent,)
                                ),
                                contentPadding: EdgeInsets.only(left: 5),
                                hintText: pickuplocation,
                                border: InputBorder.none,
                              ),
                              onChanged: (value){
                                setState((){
                                  pickuplocation = value;
                                });
                              },
                            ),
                          ),
                          SizedBox(height: 10),
                          const Text("Length*", style: TextStyle(color: kPrimaryColor, fontSize: 18)),
                          const SizedBox(height: 5.0),
                          Padding(
                            padding: const EdgeInsets.only(left: 0.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.deepOrangeAccent)
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.deepOrangeAccent,)
                                ),
                                contentPadding: EdgeInsets.only(left: 5),
                                hintText: "Enter length of the item in cms. Must be more than 0.5",
                                border: InputBorder.none,
                              ),
                              onChanged: (value){
                                 itemlength = value;
                              },
                            ),
                          ),
                          SizedBox(height: 10),
                          const Text("Width*", style: TextStyle(color: kPrimaryColor, fontSize: 18)),
                          const SizedBox(height: 5.0),
                          Padding(
                            padding: const EdgeInsets.only(left: 0.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.deepOrangeAccent)
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.deepOrangeAccent,)
                                ),
                                contentPadding: EdgeInsets.only(left: 5),
                                hintText: "Enter width of the item in cms. Must be more than 0.5",
                                border: InputBorder.none,
                              ),
                              onChanged: (value){
                                itemwidth = value;
                              },
                            ),
                          ),
                          SizedBox(height: 10),
                          const Text("Height*", style: TextStyle(color: kPrimaryColor, fontSize: 18)),
                          const SizedBox(height: 5.0),
                          Padding(
                            padding: const EdgeInsets.only(left: 0.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.deepOrangeAccent)
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.deepOrangeAccent,)
                                ),
                                contentPadding: EdgeInsets.only(left: 5),
                                hintText: "Enter height of the item in cms. Must be more than 0.5",
                                border: InputBorder.none,
                              ),
                              onChanged: (value){
                                itemheight = value;
                              },
                            ),
                          ),
                          SizedBox(height: 10),
                          const Text("Weight*", style: TextStyle(color: kPrimaryColor, fontSize: 18)),
                          const SizedBox(height: 5.0),
                          Padding(
                            padding: const EdgeInsets.only(left: 0.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.deepOrangeAccent)
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.deepOrangeAccent,)
                                ),
                                contentPadding: EdgeInsets.only(left: 5),
                                hintText: "Enter weight in KG",
                                border: InputBorder.none,
                              ),
                              onChanged: (value){
                                 itemweight = value;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  InkWell(
                    onTap: () {
                      /*if(title.trim().length == 0 || title.trim().isEmpty || title == "Title"){
                        showToast("Please enter your title");
                      }
                      else if(message == "Message"){
                        showToast("Please enter your message");
                      }
                      else{
                        _generateticket();
                      }*/

                    },
                    child: Card(
                      elevation: 8.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Container(
                        height: 45,
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                            color: Colors.deepOrangeAccent,
                            borderRadius: BorderRadius.all(Radius.circular(8.0))
                        ),
                        child: Text("Submit", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
      ),
    );
  }

  Future<Position> _determinePosition() async {
    setState((){
       _loading = true;
    });
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<void> _getAddress(value) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(value.latitude, value.longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    setState(() {
      _loading = false;
      shippingaddress = place.subLocality.toString() +
         "," +
         place.locality.toString() +
         "," +
         place.postalCode.toString() +
         "," +
         place.country.toString();
    });
  }
}
