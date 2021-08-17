import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:letgo/screen/home.dart';
import 'package:letgo/utility/my_constant.dart';
import 'package:letgo/utility/my_dialog.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  File? file;
  String avatar = '';
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
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
          padding: const EdgeInsets.only(left: 65),
          child: Text(
            'Create Account',
            style: TextStyle(
              color: Colors.black, // 2
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(40, 10, 40, 0),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(child: picprofile()),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: Name()),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: phone()),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: email()),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: password()),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                      child: Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: register(),
                  )),
                ],
              ),
              backLogin(context)
            ],
          ),
        ),
      ),
    );
  }

  Row backLogin(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text('Already a member ?'),
      TextButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Homescreen();
          }));
        },
        child: Text('Login'),
        style: TextButton.styleFrom(primary: Colors.orange[700]),
      )
    ]);
  }

  Row register() {
    return Row(
      children: [
        Container(
          width: 160,
          height: 60,
          child: ElevatedButton(
            onPressed: () {
              print('insert ot database');
              UploadPictureAndInsertData();
              if (formKey.currentState!.validate()) {}
            },
            child: Text('Register'),
            style: MyConstant().myButtonStyle(),
          ),
        )
      ],
    );
  }

  Future<Null> UploadPictureAndInsertData() async {
    String name = nameController.text;
    String phone = phoneController.text;
    String email = emailController.text;
    String password = passwordController.text;
    print('## name =$name,phone =$phone,email=$email,password=$password');
    String path =
        '${MyConstant.domain}/letgo/getUserWhereUser.php?isAdd=true&email=$email';
    await Dio().get(path).then((value) async {
      print('## value ==>> $value');

      if (value.toString() == 'null') {
        print('## user ok');

        if (file == null) {
          processInsertMySQL(
            name: name,
            phone: phone,
            email: email,
            password: password,
          );
        } else {
          print('### process Upload Avatar');
          String apiSaveAvatar = '${MyConstant.domain}/letgo/saveAvatar.php';
          int i = Random().nextInt(100000);
          String nameAvatar = 'avatar$i.jpg';
          Map<String, dynamic> map = Map();
          map['file'] =
              await MultipartFile.fromFile(file!.path, filename: nameAvatar);
          FormData data = FormData.fromMap(
            map,
          );
          await Dio().post(apiSaveAvatar, data: data).then((value) {
            avatar = '/letgo/avatar/$nameAvatar';
            processInsertMySQL(
              name: name,
              phone: phone,
              email: email,
              password: password,
            );
          });
        }
      } else {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text(
              '!!! Alert !!!',
              textAlign: TextAlign.center,
            ),
            content: const Text('This email is a member. Try a new e-mail.'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        emailController.clear();
      }
    });
  }

  Future<Null> processInsertMySQL(
      {String? name, String? phone, String? email, String? password}) async {
    print('### processInsertMySQL Work and avatar ==> $avatar');
    String apiInsertUser =
        '${MyConstant.domain}/letgo/insertUser.php?isAdd=true&name=$name&phone=$phone&email=$email&password=$password&avatar=$avatar';
    await Dio().get(apiInsertUser).then((value) {
      print('## letgo ##');
      if (value.toString() == 'true') {
        Navigator.pop(context);
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text(
              '*** Welcome ***',
              textAlign: TextAlign.center,
            ),
            content:
                const Text('Register is succeed', textAlign: TextAlign.center),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        print('Create New user False !!!');
      }
    });
  }

  Padding Name() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Container(
        width: 250,
        height: 50,
        child: TextFormField(
          controller: nameController,
          validator: (value) {
            if (value!.isEmpty) {
              return 'please insert Name';
            } else {}
          },
          decoration: InputDecoration(
              prefixIcon: Icon(Icons.account_circle_outlined),
              labelText: 'Name',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: Colors.orange),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: Colors.blue),
                borderRadius: BorderRadius.circular(20),
              )),
          keyboardType: TextInputType.name,
        ),
      ),
    );
  }

  Padding phone() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Container(
        width: 250,
        height: 50,
        child: TextFormField(
          controller: phoneController,
          validator: (value) {
            if (value!.isEmpty) {
              return 'please insert Phone number';
            } else {}
          },
          decoration: InputDecoration(
              prefixIcon: Icon(Icons.phone),
              labelText: 'phone',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: Colors.orange),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: Colors.blue),
                borderRadius: BorderRadius.circular(20),
              )),
          keyboardType: TextInputType.number,
        ),
      ),
    );
  }

  Padding email() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Container(
        width: 250,
        height: 50,
        child: TextFormField(
          controller: emailController,
          validator: (value) {
            if (value!.isEmpty) {
              return 'please insert email';
            } else {}
          },
          decoration: InputDecoration(
              prefixIcon: Icon(Icons.email_outlined),
              labelText: 'E-mail',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: Colors.orange),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: Colors.blue),
                borderRadius: BorderRadius.circular(20),
              )),
          keyboardType: TextInputType.name,
        ),
      ),
    );
  }

  Padding password() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Container(
        width: 250,
        height: 50,
        child: TextFormField(
          controller: passwordController,
          validator: (value) {
            if (value!.isEmpty) {
              return 'please insert Password';
            } else {}
          },
          obscureText: true,
          decoration: InputDecoration(
              prefixIcon: Icon(Icons.lock_outline),
              labelText: 'Password',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: Colors.orange),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: Colors.blue),
                borderRadius: BorderRadius.circular(20),
              )),
          keyboardType: TextInputType.visiblePassword,
        ),
      ),
    );
  }

  Future<Null> chooseimage(ImageSource source) async {
    try {
      var result = await ImagePicker().getImage(
        source: source,
        maxWidth: 200,
        maxHeight: 200,
      );
      setState(() {
        file = File(result!.path);
      });
    } catch (e) {}
  }

  Row picprofile() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
            onPressed: () => chooseimage(ImageSource.camera),
            icon: Icon(
              Icons.add_a_photo,
              size: 25,
            )),
        Container(
          child: file == null
              ? Image.asset("assets/images/account.png", width: 150)
              : Image.file(file!),
        ),
        IconButton(
            onPressed: () => chooseimage(ImageSource.gallery),
            icon: Icon(
              Icons.add_photo_alternate,
              size: 25,
            )),
      ],
    );
  }
}
