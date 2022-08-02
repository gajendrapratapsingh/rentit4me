import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rentit4me/themes/constant.dart';
import 'package:rentit4me/views/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

class UserlocationScreen extends StatefulWidget {
  const UserlocationScreen({Key key}) : super(key: key);

  @override
  State<UserlocationScreen> createState() => _UserlocationScreenState();

}

class _UserlocationScreenState extends State<UserlocationScreen> {

  String address;

  bool _loading = false;

  GoogleMapController googleMapController;

  static const CameraPosition initialCameraPosition = CameraPosition(target: LatLng(37.42796133580664, -122.085749655962), zoom: 14);

  Set<Marker> markers = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getlocation();
  }

  Future<void> _getlocation() async{
    try{
      setState((){
        _loading = true;
      });
      Position position = await _determinePosition();

      _getAddress(position);

      googleMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: 14)));
      markers.clear();
      markers.add(Marker(markerId: const MarkerId('currentLocation'),position: LatLng(position.latitude, position.longitude)));
      setState(() {
        _loading = false;
      });
    }
    catch(e){
      setState(() {
        _loading = false;
      });
      Flushbar(
        message: "$e please enable your phone location.",
        messageColor: Colors.white,
        forwardAnimationCurve: Curves.decelerate,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.all(15),
        titleColor: Colors.white,
        borderRadius: BorderRadius.circular(10),
        reverseAnimationCurve: Curves.easeOut,
        flushbarPosition: FlushbarPosition.TOP,
        positionOffset: 20,
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
        icon: const Icon(Icons.error, size: 28, color: Colors.white),
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
          inAsyncCall: _loading,
          color: kPrimaryColor,
          child : Stack(
            children: [
              Container(
                child: GoogleMap(
                  initialCameraPosition: initialCameraPosition,
                  markers: markers,
                  zoomControlsEnabled: false,
                  mapType: MapType.normal,
                  onMapCreated: (GoogleMapController controller) {
                    googleMapController = controller;
                  },
                ),
              ),
              Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: address == null ? const SizedBox() : Container(
                    height: 130,
                    width: double.infinity,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.65,
                                child: address == null ? const SizedBox() : Text(address, maxLines: 2, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black, fontSize: 16)),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.30,
                                child: address == null ? const SizedBox() : Align(
                                  alignment: Alignment.topRight,
                                  child: InkWell(
                                    onTap : (){
                                      if(address == null){
                                        _getlocation();
                                      }
                                      else{
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          content: Text('Current location: $address'),
                                          backgroundColor: kPrimaryColor,
                                        )
                                        );
                                      }
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20.0),
                                        color: kPrimaryColor,
                                      ),
                                      child: const Icon(Icons.my_location_sharp, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 25),
                          InkWell(
                            onTap: (){
                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SplashScreen()));
                            },
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                  color: kPrimaryColor,
                                  borderRadius: BorderRadius.circular(8.0)
                              ),
                              alignment: Alignment.center,
                              child: const Text("Confirm", style: TextStyle(color: Colors.white, fontSize: 16)),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
              )
            ],
          )
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: address != null ? const SizedBox() : FloatingActionButton(
        backgroundColor: kPrimaryColor,
        onPressed: () {
          _getlocation();
        },
        child: const Icon(Icons.refresh_sharp, color: Colors.white),
      ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Location permission denied");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }
    Position position = await Geolocator.getCurrentPosition();
    return position;
  }

  Future<void> _getAddress(value) async {
    setState(() {
      _loading = false;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Placemark> placemarks = await placemarkFromCoordinates(value.latitude, value.longitude);
    prefs.setString('latitude', value.latitude.toString());
    prefs.setString('longitude', value.longitude.toString());
    Placemark place = placemarks[0];
    prefs.setString('country', place.country.toString());
    prefs.setString('state', place.administrativeArea.toString());
    prefs.setString('city', place.locality.toString());

    setState(() {
      address = "${place.subLocality},${place.locality},${place.postalCode},${place.administrativeArea},${place.country}";
    });
  }

}
