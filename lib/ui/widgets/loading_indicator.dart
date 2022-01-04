import 'package:flutter/material.dart';
import 'package:scrumpoker/constant/color.dart';

import 'multilanguage.dart';

class LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: whiteTrans,
      child: Center(
          child: Container(
        width: 240,
        height: 240,
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const CircularProgressIndicator(
              backgroundColor: white,
              valueColor: AlwaysStoppedAnimation<Color>(primary),
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              txt("loading_text"),
              style: const TextStyle(color: primary),
            )
          ],
        ),
      )),
    );
  }
}
