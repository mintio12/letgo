import 'dart:convert';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:letgo/models/user_model.dart';
import 'package:letgo/screen/index.dart';
import 'package:letgo/screen/register.dart';
import 'package:letgo/utility/my_constant.dart';
import 'package:letgo/utility/my_dialog.dart';
import 'package:letgo/widgets/custom_pageRpte.dart';
import 'package:letgo/widgets/show_image.dart';
import 'package:letgo/widgets/show_title.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({Key? key}) : super(key: key);

  @override
  _HomescreenState createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  bool statusRedEye = true;
  final formKry = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
        body: SafeArea(
      child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 80),
            child: Form(
              key: formKry,
              child: ListView(children: [
                buildImage(size),
                buildAppName(),
                buildEmail(size),
                buildPassword(size),
                buildLogin(size),
                buildCreate(context),
              ]),
            ),
          )),
    ));
  }

  Row buildCreate(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text('ไม่ได้เป็นสมาชิกหรอ ?'),
      TextButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return RegisterScreen();
          }));
        },
        child: Text('สมัครสมาชิก'),
        style: TextButton.styleFrom(primary: Colors.orange[700]),
      )
    ]);
  }

  Row buildLogin(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 15),
          width: size * 0.4,
          height: size * 0.12,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Colors.orange[500],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13))),
            onPressed: () {
              if (formKry.currentState!.validate()) {
                String email = emailController.text;
                String password = passwordController.text;
                print('## email =$email, password = $password');
                checkLogin(email: email, password: password);
              }
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
              child: Text(
                'เข้าสู่ระบบ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<Null> checkLogin({String? email, String? password}) async {
    String apiCheckLogin =
        '${MyConstant.domain}/letgo/getUserWhereUser.php?isAdd=true&email=$email';
    await Dio().get(apiCheckLogin).then((value) async {
      print('## value for API ==>> $value');
      if (value.toString() == 'null') {
        MyDialog()
            .normalDialog(context, '!! เตือน !!', '$email ไม่ได้เป็นสมาชิก');
      } else {
        for (var item in json.decode(value.data)) {
          UserModel model = UserModel.fromMap(item);
          if (password == model.password) {
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            preferences.setString('email', model.email);
            preferences.setString('name', model.name);

            Navigator.push(
                context,
                CustomPageRoute(
                  child: indexScreen(),
                ));
            emailController.clear();
            passwordController.clear();
          } else {
            MyDialog()
                .normalDialog(context, '!! เตือน !!', 'รหัสผ่านไม่ถูกต้อง');
          }
        }
      }
    });
  }

  Row buildEmail(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            margin: EdgeInsets.only(top: 18),
            width: size * 0.6,
            child: TextFormField(
              controller: emailController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'กรุณากรอก อีเมล';
                } else {
                  return null;
                }
              },
              cursorColor: Colors.orange[300],
              decoration: InputDecoration(
                labelStyle: TextStyle(color: Colors.black),
                labelText: 'อีเมล',
                prefixIcon: Icon(
                  Icons.account_box_outlined,
                  color: Colors.black,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.orange),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(width: 3, color: Colors.orange.shade700),
                    borderRadius: BorderRadius.circular(25)),
              ),
            )),
      ],
    );
  }

  Row buildPassword(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            margin: EdgeInsets.only(top: 18),
            width: size * 0.6,
            child: TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'กรุณากรอก รหัสผ่าน';
                } else {
                  return null;
                }
              },
              controller: passwordController,
              cursorColor: Colors.orange[300],
              obscureText: statusRedEye,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        statusRedEye = !statusRedEye;
                      });
                    },
                    icon: statusRedEye
                        ? Icon(Icons.remove_red_eye, color: Colors.black)
                        : Icon(Icons.remove_red_eye_outlined,
                            color: Colors.red)),
                labelStyle: TextStyle(color: Colors.black),
                labelText: 'รหัสผ่าน',
                prefixIcon: Icon(
                  Icons.lock_outlined,
                  color: Colors.black,
                ),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Colors.orange),
                    borderRadius: BorderRadius.circular(10)),
                focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(width: 3, color: Colors.orange.shade700),
                    borderRadius: BorderRadius.circular(25)),
              ),
            )),
      ],
    );
  }

  Row buildAppName() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: ShowTitle(
              title: MyConstant.appName, textStyle: MyConstant().h1Style()),
        ),
      ],
    );
  }

  Row buildImage(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(width: size * 0.5, child: ShowImage(path: MyConstant.image1)),
      ],
    );
  }
}
