import 'package:flutter/material.dart';

// ignore: avoid_classes_with_only_static_members
class NavKey {
  static final navKey = GlobalKey<NavigatorState>();
  static bool isInLogin = false;
  static String pemKey = "";
}
