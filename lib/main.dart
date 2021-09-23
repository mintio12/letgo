import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:letgo/screen/call.dart';
import 'package:letgo/screen/home.dart';
import 'package:letgo/screen/index.dart';
import 'package:letgo/screen/register.dart';
import 'package:letgo/utility/my_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Map<String, WidgetBuilder> map = {
  '/login': (BuildContext context) => Homescreen(),
  '/register': (BuildContext context) => RegisterScreen(),
  '/home': (BuildContext context) => indexScreen(),
  '/sentLocation': (BuildContext context) => sentLocation(),
};

String? initlaRoute;
Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String? email = preferences.getString('email');

  if (email?.isEmpty ?? true) {
    initlaRoute = MyConstant.routeLogin;
    print('$initlaRoute');
    runApp(MyApp());
  } else {
    print('### email ==> $email');
    initlaRoute = MyConstant.routeIndex;
    runApp(MyApp());
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: MyConstant.appName,
      routes: map,
      initialRoute: initlaRoute,
      theme: ThemeData(
        primaryColor: Colors.orange[500],
        fontFamily: 'supermarket',
      ),
    );
  }
}
