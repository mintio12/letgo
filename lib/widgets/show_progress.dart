import 'package:flutter/material.dart';

class ShowProgress extends StatelessWidget {
  const ShowProgress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: CircularProgressIndicator(
      strokeWidth: 8,
      backgroundColor: Colors.white12,
      valueColor: new AlwaysStoppedAnimation<Color>(Colors.orange.shade400),
    ));
  }
}
