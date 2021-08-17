import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:letgo/utility/my_dialog.dart';
import 'package:flutter/src/material/bottom_navigation_bar_theme.dart';

class indexScreen extends StatefulWidget {
  const indexScreen({Key? key}) : super(key: key);

  @override
  _indexScreenState createState() => _indexScreenState();
}

class _indexScreenState extends State<indexScreen> {
  double? lat, lng;
  @override
  void initState() {
    super.initState();
    checkPermission();
  }

  Future<Null> checkPermission() async {
    bool locationService;
    LocationPermission locationPermission;

    locationService = await Geolocator.isLocationServiceEnabled();
    if (locationService) {
      print('service location Open');
      locationPermission = await Geolocator.checkPermission();
      if (locationPermission == LocationPermission.denied) {
        locationPermission = await Geolocator.requestPermission();
        if (locationPermission == LocationPermission.deniedForever) {
          MyDialog().alertLocationService(
              context, 'Location is Close', 'Please open location service');
        } else {
          //Find Lat Lng
          findLatLng();
        }
      } else {
        if (locationPermission == LocationPermission.deniedForever) {
          MyDialog().alertLocationService(
              context, 'Location is Close', 'Please open location service');
        } else {
          //Find Lat Lng
          findLatLng();
        }
      }
    } else {
      print('Service location Close');
      MyDialog().alertLocationService(
          context, 'Location Service', 'You location service is Close');
    }
  }

  Future<Null> findLatLng() async {
    print('findlatlng ==> Work');
    Position? position = await findPosition();
    setState(() {
      lat = position!.latitude;
      lng = position.longitude;
      print('lat =$lat&lng=$lng');
    });
  }

  Future<Position?> findPosition() async {
    Position position;
    try {
      position = await Geolocator.getCurrentPosition();
      return position;
    } catch (e) {
      return null;
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: showBottomNavigationBar(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Column(
          children: <Widget>[
            showMap(),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem goNav() {
    return BottomNavigationBarItem(
        icon: Icon(
          Icons.two_wheeler_outlined,
          color: Colors.white,
        ),
        // ignore: deprecated_member_use
        title: Text('Let go', style: TextStyle(color: Colors.white)));
  }

  BottomNavigationBar showBottomNavigationBar() => BottomNavigationBar(
      backgroundColor: Colors.orange[500],
      items: <BottomNavigationBarItem>[goNav()]);

  Set<Marker> setMarker() => <Marker>[
        Marker(
          markerId: MarkerId('id'),
          position: LatLng(lat!, lng!),
          infoWindow:
              InfoWindow(title: 'You here', snippet: 'lat =$lat lng=$lng'),
        )
      ].toSet();

  Container showMap() {
    LatLng latLng = LatLng(lat!, lng!);
    CameraPosition cameraPosition = CameraPosition(target: latLng, zoom: 18);
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: GoogleMap(
        initialCameraPosition: cameraPosition,
        mapType: MapType.terrain,
        onMapCreated: (controller) {},
        markers: setMarker(),
      ),
    );
  }
}
