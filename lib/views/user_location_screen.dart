import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:rentit4me/views/dashboard.dart';
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
  bool _addressvisiility = false;

  @override
  void initState() {
    super.initState();
    _determinePosition().then((value) => _getAddress(value));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: Stack(
         children: [
           Container(
             child: FutureBuilder<Position>(
               future: _determinePosition(),
               builder: (BuildContext context, AsyncSnapshot<dynamic> snapchat) {
                 if(snapchat.hasData) {
                   final Position currentLocation = snapchat.data;
                   return SfMaps(
                     layers: [
                       MapTileLayer(
                         initialFocalLatLng: MapLatLng(currentLocation.latitude, currentLocation.longitude),
                         initialZoomLevel: 5,
                         initialMarkersCount: 1,
                         urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                         markerBuilder: (BuildContext context, int index) {
                           return MapMarker(
                             latitude: currentLocation.latitude,
                             longitude: currentLocation.longitude,
                             child: IconButton(
                               onPressed: (){
                               },
                               icon: Icon(
                                 Icons.location_on,
                                 color: Colors.red[800],
                               ),
                             ),
                             size: Size(25, 25),
                           );
                         },
                       ),
                     ],
                   );
                 }
                 return Center(child: CircularProgressIndicator());
               },
             ),
           ),
           Positioned(
               bottom: 20,
               left: 10,
               right: 10,
               child: InkWell(
                 onTap: (){
                   Navigator.of(context).push(MaterialPageRoute(
                     builder: (context) => SplashScreen(),
                   ));
                 },
                 child: Container(
                   height: 45,
                   width : double.infinity,
                   decoration: BoxDecoration(
                     color: Colors.red,
                     borderRadius: BorderRadius.circular(8.0)
                   ),
                   alignment: Alignment.center,
                   child: const Text("Confirm", style: TextStyle(color: Colors.white, fontSize: 16)),
                 ),
               )
           ),
           Positioned(
             top: 40,
             left: 20,
             right: 20,
             child: Container(
               width: double.infinity,
               alignment: Alignment.center,
               color: Colors.white,
               child: Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: address == null || address == "" ? SizedBox() : Text(address),
               ),
             ),
           )
         ],
       ),
    );
  }

  Future<Position> _determinePosition() async {
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
      else{
        _determinePosition().then((value) => _getAddress(value));
      }
    }
    else{
      //my code here
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<void> _getAddress(value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Placemark> placemarks = await placemarkFromCoordinates(value.latitude, value.longitude);
    prefs.setString('latitude', value.latitude.toString());
    prefs.setString('longitude', value.longitude.toString());
    Placemark place = placemarks[0];
    prefs.setString('country', place.country.toString());
    prefs.setString('state', place.administrativeArea.toString());
    prefs.setString('city', place.locality.toString());
    setState(() {
      address = place.subLocality.toString() +
          "," +
          place.locality.toString() +
          "," +
          place.postalCode.toString() +
          "," +
          place.administrativeArea.toString() +
          "," +
          place.country.toString();
    });
  }

}
