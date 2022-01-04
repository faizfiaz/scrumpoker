// ignore_for_file: avoid_classes_with_only_static_members, deprecated_member_use

import 'package:SuperNinja/constant/color.dart';
import 'package:flutter/material.dart';

class DefaultButton {
  static Widget redButton(
      BuildContext context, String text, VoidCallback callback) {
    return Container(
      width: double.infinity,
      height: 42,
      child: RaisedButton(
          color: primary,
          elevation: 0,
          textColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
              side: const BorderSide(color: Colors.red)),
          disabledTextColor: white,
          child: Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
          ),
          onPressed: () {
            callback.call();
          }),
    );
  }

  static Widget redButtonSmall(
      BuildContext context, String text, VoidCallback? callback) {
    return Container(
      height: 42,
      child: RaisedButton(
          color: primary,
          elevation: 0,
          textColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
              side: const BorderSide(color: Colors.red)),
          disabledTextColor: white,
          child: Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
          ),
          onPressed: () => callback!.call()),
    );
  }

  static Widget redButtonSmallLongWidth(
      BuildContext context, String text, VoidCallback callback) {
    return Container(
      width: 200,
      height: 42,
      child: RaisedButton(
          color: primary,
          elevation: 0,
          textColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
              side: const BorderSide(color: Colors.red)),
          disabledTextColor: white,
          child: Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
          ),
          onPressed: () => callback.call()),
    );
  }

  static Widget redButtonVerySmall(
      BuildContext context, String text, VoidCallback callback) {
    return Container(
      height: 32,
      child: RaisedButton(
          color: primary,
          elevation: 0,
          textColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
              side: const BorderSide(color: Colors.red)),
          disabledTextColor: white,
          child: Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
          ),
          onPressed: () => callback.call()),
    );
  }

  static Widget whiteButtonSmall(
      BuildContext context, String text, VoidCallback callback) {
    return Container(
      height: 30,
      child: RaisedButton(
          color: Colors.white,
          elevation: 0,
          textColor: primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          disabledTextColor: white,
          child: Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 10),
          ),
          onPressed: () => callback.call()),
    );
  }
}
