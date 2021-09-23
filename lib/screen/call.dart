import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:letgo/screen/index.dart';
import 'package:letgo/utility/my_constant.dart';
import 'package:letgo/utility/my_dialog.dart';
import 'package:letgo/widgets/show_image.dart';
import 'package:letgo/widgets/show_progress.dart';
import 'package:form_field_validator/form_field_validator.dart';

class sentLocation extends StatefulWidget {
  const sentLocation({Key? key}) : super(key: key);

  @override
  _sentLocationState createState() => _sentLocationState();
}

class _sentLocationState extends State<sentLocation> {
  double? lat, lng;
  int cAvatar = 0;
  File? file;
  String avatar = '';
  String listid = '0';
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController desController = TextEditingController();
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
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0, // 1
        title: Padding(
          padding: const EdgeInsets.only(left: 75),
          child: Text(
            'เรียกวินมอเตอร์ไซค์',
            style: TextStyle(
              color: Colors.black, // 2
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: LayoutBuilder(
          builder: (context, constraints) => GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            behavior: HitTestBehavior.opaque,
            child: Center(
              child: Container(
                child: lat == null
                    ? ShowProgress()
                    : Form(
                        key: formKey,
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.orange),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: showMap(constraints),
                              ),
                            ),
                            buildName(constraints),
                            buildPhone(constraints),
                            buildDes(constraints),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 15, 200, 0),
                              child: Text('จุดสังเกตที่คุณอยู่'),
                            ),
                            buildSetPic(constraints),
                          ],
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(height: 50.0),
      ),
      floatingActionButton: Container(
        height: 80.0,
        width: 80.0,
        child: FloatingActionButton(
          backgroundColor: Colors.orange[500],
          onPressed: () {
            if (formKey.currentState!.validate()) {
              print('insert ot database');
              UploadPictureAndInsertData();
            }
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
    );
  }

  Future<Null> UploadPictureAndInsertData() async {
    String name = nameController.text;
    String phone = phoneController.text;
    String des = desController.text;
    print('## listid =$listid,name =$name,phone =$phone,des=$des');
    String path =
        '${MyConstant.domain}/letgo/getNameWhereName.php?isAdd=true&name=$name';
    await Dio().get(path).then((value) async {
      print('## value ==>> $value');

      if (value.toString() == 'null') {
        print('## user ok');

        if (file == null) {
          processInsertMySQL(
            listid: listid,
            name: name,
            phone: phone,
            des: des,
          );
        } else {
          cAvatar = 1;
          print('### process Upload Avatar');
          String apiSaveAvatar = '${MyConstant.domain}/letgo/saveLocation.php';
          int i = Random().nextInt(100000);
          String nameAvatar = 'avatar$i.jpg';
          Map<String, dynamic> map = Map();
          map['file'] =
              await MultipartFile.fromFile(file!.path, filename: nameAvatar);
          FormData data = FormData.fromMap(
            map,
          );
          await Dio().post(apiSaveAvatar, data: data).then((value) {
            avatar = '/letgo/location/$nameAvatar';
            processInsertMySQL(
              listid: listid,
              name: name,
              phone: phone,
              des: des,
            );
          });
        }
      } else {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text(
              '!!! รอสักครู่ !!!',
              textAlign: TextAlign.center,
            ),
            content:
                const Text('ํคุณได้ทำการเรียกวิมอเตอร์ไซค์แล้ว กรุณารอสักครู่'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    });
  }

  Future<Null> processInsertMySQL(
      {String? listid, String? name, String? phone, String? des}) async {
    print('### processInsertMySQL Work and avatar ==> $avatar');

    String apiInsertUser =
        '${MyConstant.domain}/letgo/insertLocation.php?isAdd=true&listid=$listid&avatar=$avatar&name=$name&phone=$phone&des=$des&lat=$lat&lng=$lng';
    await Dio().get(apiInsertUser).then((value) {
      print('## letgo ##');
      if (value.toString() == 'true') {
        Navigator.pop(context);
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text(
              '*** Letgo ***',
              textAlign: TextAlign.center,
            ),
            content: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: const Text('เรียกวินมอเตอร์ไซค์สำเร็จ',
                  style: TextStyle(fontSize: 20), textAlign: TextAlign.center),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                  return indexScreen();
                })),
                child: const Text(
                  'ตกลง',
                  style: TextStyle(color: Colors.orange),
                ),
              ),
            ],
          ),
        );
      } else {
        print('Call False !!!');
      }
    });
  }

  Padding buildSetPic(BoxConstraints constraints) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 50),
      child: Container(
        width: constraints.maxWidth * 0.75,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.orange),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 0, 15),
          child: picprofile(),
        ),
      ),
    );
  }

  Widget buildName(BoxConstraints constraints) {
    return Container(
        width: constraints.maxWidth * 0.75,
        margin: EdgeInsets.only(top: 18),
        child: TextFormField(
          controller: nameController,
          validator: (value) {
            if (value!.isEmpty) {
              return 'กรุณากรอก ชื่อ';
            } else {
              return null;
            }
          },
          cursorColor: Colors.orange[300],
          decoration: InputDecoration(
            labelStyle: TextStyle(color: Colors.black),
            labelText: 'ชื่อ',
            prefixIcon: Icon(
              Icons.account_box_outlined,
              color: Colors.black,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Colors.orange),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 3, color: Colors.orange.shade700),
                borderRadius: BorderRadius.circular(25)),
          ),
        ));
  }

  Widget buildPhone(BoxConstraints constraints) {
    return Container(
        width: constraints.maxWidth * 0.75,
        margin: EdgeInsets.only(top: 18),
        child: TextFormField(
          controller: phoneController,
          validator: (value) {
            if (value!.isEmpty) {
              return 'กรุณากรอก เบอร์โทรศัพท์';
            } else {
              return null;
            }
          },
          cursorColor: Colors.orange[300],
          decoration: InputDecoration(
            labelStyle: TextStyle(color: Colors.black),
            labelText: 'เบอร์โทรศัพท์',
            prefixIcon: Icon(
              Icons.phonelink_ring_outlined,
              color: Colors.black,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Colors.orange),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 3, color: Colors.orange.shade700),
                borderRadius: BorderRadius.circular(25)),
          ),
        ));
  }

  Widget buildDes(BoxConstraints constraints) {
    return Container(
        width: constraints.maxWidth * 0.75,
        margin: EdgeInsets.only(top: 18),
        child: TextFormField(
          controller: desController,
          validator: (value) {
            if (value!.isEmpty) {
              return 'กรุณากรอก รายละเอียด';
            } else {
              return null;
            }
          },
          maxLines: 4,
          cursorColor: Colors.orange[300],
          decoration: InputDecoration(
            hintStyle: TextStyle(color: Colors.black),
            hintText: 'รายละเอียด',
            prefixIcon: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 60),
              child: Icon(
                Icons.description_outlined,
                color: Colors.black,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Colors.orange),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 3, color: Colors.orange.shade700),
                borderRadius: BorderRadius.circular(25)),
          ),
        ));
  }

  Set<Marker> setMarker() => <Marker>[
        Marker(
          markerId: MarkerId('id'),
          position: LatLng(lat!, lng!),
          infoWindow:
              InfoWindow(title: 'You here', snippet: 'lat =$lat lng=$lng'),
        )
      ].toSet();

  Container showMap(BoxConstraints constraints) {
    LatLng latLng = LatLng(lat!, lng!);
    CameraPosition cameraPosition = CameraPosition(target: latLng, zoom: 18);
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 200,
      child: GoogleMap(
        initialCameraPosition: cameraPosition,
        mapType: MapType.terrain,
        onMapCreated: (controller) {},
        markers: setMarker(),
      ),
    );
  }

  Future<Null> chooseimage(ImageSource source) async {
    try {
      var result = await ImagePicker().getImage(
        source: source,
        maxWidth: 150,
        maxHeight: 150,
      );
      setState(() {
        file = File(result!.path);
      });
    } catch (e) {}
  }

  Row picprofile() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(60, 30, 0, 30),
          child: Container(
            child: file == null
                ? Image.asset("assets/images/location.png", width: 100)
                : Image.file(file!),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
          child: IconButton(
              onPressed: () => chooseimage(ImageSource.camera),
              icon: Icon(
                Icons.add_a_photo,
                size: 25,
              )),
        ),
      ],
    );
  }
}
