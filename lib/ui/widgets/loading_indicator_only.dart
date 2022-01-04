import 'package:SuperNinja/constant/color.dart';
import 'package:flutter/material.dart';

class LoadingIndicatorOnly extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          CircularProgressIndicator(
            backgroundColor: white,
            valueColor: AlwaysStoppedAnimation<Color>(primary),
          ),
        ],
      )),
    );
  }
}
