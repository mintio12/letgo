import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:letgo/utility/my_constant.dart';
import 'package:letgo/widgets/show_image.dart';
import 'package:letgo/widgets/show_title.dart';

class MyDialog {
  Future<Null> showProgressDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => WillPopScope(
        child: Center(
            child: CircularProgressIndicator(
          color: Colors.white,
        )),
        onWillPop: () async {
          return false;
        },
      ),
    );
  }

  Future<Null> alertLocationService(
      BuildContext context, String title, String message) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: ListTile(
          title: ShowTitle(
            title: title,
            textStyle: MyConstant().h1Style(),
          ),
          subtitle:
              ShowTitle(title: message, textStyle: MyConstant().h2Style()),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              // Navigator.pop(context);
              await Geolocator.openLocationSettings();
              exit(0);
            },
            child: Text('OK'),
            style: TextButton.styleFrom(primary: Colors.orange[700]),
          )
        ],
      ),
    );
  }

  Future<Null> normalDialog(
      BuildContext context, String title, String message) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: ListTile(
          title: Center(
              child:
                  ShowTitle(title: title, textStyle: MyConstant().h1Style())),
          subtitle: Center(
              child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: ShowTitle(title: message, textStyle: MyConstant().h2Style()),
          )),
        ),
        children: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
            style: TextButton.styleFrom(
                primary: Colors.orange[700], textStyle: MyConstant().h2Style()),
          )
        ],
      ),
    );
  }
}
