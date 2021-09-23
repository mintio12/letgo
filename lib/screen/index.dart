import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:letgo/models/qwin_model.dart';
import 'package:letgo/models/showCountQ_model.dart';
import 'package:letgo/screen/call.dart';
import 'package:letgo/utility/my_constant.dart';
import 'package:letgo/utility/my_dialog.dart';
import 'package:flutter/src/material/bottom_navigation_bar_theme.dart';
import 'package:letgo/widgets/show_image.dart';
import 'package:letgo/widgets/show_progress.dart';
import 'package:letgo/widgets/show_title.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class indexScreen extends StatefulWidget {
  const indexScreen({Key? key}) : super(key: key);

  @override
  _indexScreenState createState() => _indexScreenState();
}

class _indexScreenState extends State<indexScreen> {
  double? lat, lng;
  String? countQwin;
  bool loadq = true;
  bool? haveDataq;
  List<showqwinModel> qWinModel = [];

  @override
  void initState() {
    super.initState();
    loadValueFromAPIQ();
    checkQSatus();
    checkPermission();
  }

  Future<Null> loadValueFromAPIQ() async {
    if (qWinModel.length != 0) {
      qWinModel.clear();
    } else {}
    String apiGetWinwhereQ =
        '${MyConstant.domain}/letgo/getWinWhereQ.php?isAdd=true&winnum=winnum';
    await Dio().get(apiGetWinwhereQ).then(
      (value) {
        print('valueq  ==> $value');
        print('value ==> ${MyConstant.domain}/letgo/');

        if (value.toString() == 'null') {
          //No Data
          setState(() {
            loadq = false;
            haveDataq = false;
          });
        } else {
          for (var item in json.decode(value.data)) {
            showqwinModel modelq = showqwinModel.fromMap(item);
            print('winnumq ==> ${modelq.winnum}');
            print('nameq ==> ${modelq.name}');
            setState(() {
              loadq = false;
              haveDataq = true;
              qWinModel.add(modelq);
            });
          }
        }
      },
    );
  }

  Future<Null> checkQSatus() async {
    String apiCheckQsatatus =
        '${MyConstant.domain}/letgo/getCountQ.php?isAdd=true';
    await Dio().get(apiCheckQsatatus).then((value) {
      print('valueq  ==> $value');
      countQwin = '$value';
      print('countQwwin == $countQwin');
    });
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
    checkQSatus();
  }

  Future<Null> findLatLng() async {
    print('findlatlng ==> Work');
    Position? position = await findPosition();
    setState(() {
      lat = position!.latitude;
      lng = position.longitude;
      print('lat =$lat&lng=$lng');
    });
    if (LatLng == Null) {
      ShowImage(path: MyConstant.image1);
    }
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
      appBar: AppBar(
        backgroundColor: Colors.orange[500],
        title: Padding(
          padding: const EdgeInsets.only(left: 250),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Let's Go",
                style: TextStyle(fontSize: 25, color: Colors.white),
              ),
              Text(
                'ให้ วิน ไป ส่ง',
                style: TextStyle(fontSize: 15, color: Colors.white),
              )
            ],
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        child: Stack(
          children: [
            showLogOut(),
            Column(
              children: [
                ListTile(
                  leading: Icon(Icons.dns),
                  title: Text(
                    'คิววินมอเตอร์ไซค์',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Container(
                  height: 600,
                  width: 300,
                  child: Card(
                    color: Colors.orange,
                    child: SingleChildScrollView(
                        child: loadq
                            ? ShowProgress()
                            : haveDataq!
                                ? SingleChildScrollView(
                                    child: LayoutBuilder(
                                      builder: (context, constraints) =>
                                          buildQWin(constraints),
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(top: 160),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Card(
                                          child: ListTile(
                                            title: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'ไม่มีคิววิน',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      // bottomNavigationBar: showBottomNavigationBar(),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: lat == null
              ? ShowProgress()
              : Column(
                  children: <Widget>[
                    showMap(),
                    // showBottomNavigationBar(),
                  ],
                ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: IconTheme(
          data: IconThemeData(color: Colors.orange),
          child: Row(
            children: <Widget>[
              IconButton(
                tooltip: 'Open navigation menu',
                icon: const Icon(Icons.motorcycle_outlined),
                onPressed: () {},
              ),
              Row(
                children: [Text('สถานะ :: '), showQStatus()],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        height: 80.0,
        width: 80.0,
        child: FloatingActionButton(
          backgroundColor: Colors.orange[500],
          onPressed: () {
            Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.topToBottom,
                    child: sentLocation()));
          },
          tooltip: 'Increment Counter',
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
            child: Text(
              'เรียกวิน',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // floatingActionButton: Center(
      //   child: FloatingActionButton(
      //     onPressed: () {
      //       Navigator.push(context, MaterialPageRoute(builder: (context) {
      //         return sentLocation();
      //       }));
      //     },
      //     child: Text('Let go'),
      //   ),
      // ),
    );
  }

  String createUrlq(String stringq) {
    String urlq = '${MyConstant.domain}${stringq}';
    return urlq;
  }

  SizedBox buildQWin(BoxConstraints constraints) {
    return SizedBox(
      height: 600,
      width: 100,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 150, mainAxisExtent: 190),
          itemCount: qWinModel.length,
          itemBuilder: (context, index) => Card(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 130,
                      width: 100,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          height: constraints.maxHeight * 0.4,
                          width: constraints.maxWidth * 0.15,
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: createUrlq(qWinModel[index].avatar),
                            placeholder: (context, urlq) => ShowProgress(),
                            errorWidget: (context, urlq, error) =>
                                ShowImage(path: MyConstant.image1),
                          ),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          qWinModel[index].winnum,
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Container(
                        width: 100,
                        child: Column(
                          children: [
                            Text(qWinModel[index].name),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container showQStatus() {
    checkQSatus();
    if (countQwin == '0') {
      print('check ==>> $countQwin');
      return Container(
        width: 50,
        height: 30,
        child: Card(
          color: Colors.red,
          child: Center(child: Text('ไม่มีวิน')),
        ),
      );
    } else {
      if (countQwin == null) {
        checkQSatus();
        return Container(
          width: 50,
          height: 30,
          child: Card(
            color: Colors.yellow,
            child: Center(child: Text('$countQwin')),
          ),
        );
      } else {
        print('check ==>> $countQwin');
        return Container(
          width: 50,
          height: 30,
          child: Card(
            color: Colors.green,
            child: Center(child: Text('$countQwin')),
          ),
        );
      }
    }
  }

  Column showLogOut() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ListTile(
          onTap: () async {
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            preferences.clear().then(
                  (value) => Navigator.pushNamedAndRemoveUntil(
                      context, MyConstant.routeLogin, (route) => false),
                );
          },
          tileColor: Colors.red,
          leading: Icon(
            Icons.exit_to_app,
            color: Colors.white,
          ),
          title: Text(
            "ออกจากระบบ",
            style: MyConstant().h2WhiteStyle(),
          ),
        ),
      ],
    );
  }

  // BottomNavigationBarItem goNav() {
  //   return BottomNavigationBarItem(
  //       icon: Icon(
  //         Icons.two_wheeler_outlined,
  //         color: Colors.white,
  //       ),
  //       // ignore: deprecated_member_use
  //       title: Text('Let go', style: TextStyle(color: Colors.white)));
  // }

  // BottomNavigationBar showBottomNavigationBar() => BottomNavigationBar(
  //     backgroundColor: Colors.orange[500],
  //     items: <BottomNavigationBarItem>[goNav()]);

  Set<Marker> setMarker() => <Marker>[
        Marker(
          markerId: MarkerId('id'),
          position: LatLng(lat!, lng!),
          infoWindow:
              InfoWindow(title: 'You here', snippet: 'lat =$lat lng=$lng'),
        )
      ].toSet();

  Container showMap() {
    checkQSatus();
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
