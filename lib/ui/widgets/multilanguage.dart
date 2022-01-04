import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Languages {
  static const String en = 'assets/json/en.json';
  static const String es = 'assets/json/es.json';
  static const String id = 'assets/json/id.json';
}

String langKey = 'lang';

class MultiLanguage {
  static final MultiLanguage _singleton = MultiLanguage._internal();
  Map<String, dynamic>? phrases;

  factory MultiLanguage() {
    return _singleton;
  }

  MultiLanguage._internal();

  Future<bool> setLanguage(
      {required String path, required BuildContext context}) async {
    final prefs = await SharedPreferences.getInstance();
    final file = await DefaultAssetBundle.of(context).loadString(path);
    await prefs.setString(langKey, path);
    phrases = jsonDecode(file);
    return Future.value(true);
  }

  String? get(String key) {
    return phrases != null ? phrases![key] : key;
  }
}

Function(String key) get txt => MultiLanguage().get;

Function(String key) get uptxt =>
    (key) => MultiLanguage().get(key)!.toUpperCase();
