import 'dart:convert';

import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:scrumpoker/domain/models/response/response_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static const String userKey = "userData";
  static const String tokenKey = "tokenKey";
  static const String firebaseTokenKey = "firebaseTokenKey";
  static const String introKey = "introKey";
  static const String checkVersionPrompt = "checkVersionPrompt";
  static const String alreadyLoginNetcore = "alreadyLoginNetcore";

  static const String _hk = "Wa!s7fCAQXGJHrVwYTiCoRcKOjnprhav";

  Future<bool> setDataUser(Profile profile) async {
    const secureStorage = FlutterSecureStorage();
    final userData = json.encode(profile.toJson());
    final key = Key.fromUtf8(_hk);
    final iv = IV.fromLength(16);

    final _e = Encrypter(AES(key));
    final _edr = _e.encrypt(userData, iv: iv);
    await secureStorage.write(key: userKey, value: _edr.base64);
    return true;
  }

  Future<Profile?> getDataUser() async {
    const secureStorage = FlutterSecureStorage();
    final data = await secureStorage.read(key: userKey);
    if (data != null) {
      final key = Key.fromUtf8(_hk);
      final iv = IV.fromLength(16);

      final _e = Encrypter(AES(key));
      final _dctr = _e.decrypt64(data, iv: iv);
      final Map userMap = json.decode(_dctr);
      return Profile.fromJson(userMap as Map<String, dynamic>);
    } else {
      return Future.value(null);
    }
  }

  Future<bool> setToken(String token) async {
    final key = Key.fromUtf8(_hk);
    final iv = IV.fromLength(16);

    final _e = Encrypter(AES(key));
    final _edr = _e.encrypt(token, iv: iv);
    const secureStorage = FlutterSecureStorage();
    await secureStorage.write(key: tokenKey, value: _edr.base64);
    return true;
  }

  Future<String?> getToken() async {
    const secureStorage = FlutterSecureStorage();
    final data = await secureStorage.read(key: tokenKey);
    if (data != null) {
      final key = Key.fromUtf8(_hk);
      final iv = IV.fromLength(16);

      final _e = Encrypter(AES(key));
      final _dctr = _e.decrypt64(data, iv: iv);
      return Future.value(_dctr);
    } else {
      return Future.value(null);
    }
  }

  Future<bool> setAlreadySeenIntro() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.setBool(introKey, true);
  }

  Future<bool> hasSeenIntro() async {
    final preferences = await SharedPreferences.getInstance();
    final data = preferences.getBool(introKey);
    if (data == null) {
      return Future.value(false);
    }
    return Future.value(data);
  }

  Future<bool> setAlreadyLoginNetcore() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.setBool(alreadyLoginNetcore, true);
  }

  Future<bool> hasLoginNetcore() async {
    final preferences = await SharedPreferences.getInstance();
    final data = preferences.getBool(alreadyLoginNetcore);
    if (data == null) {
      return Future.value(false);
    }
    return Future.value(data);
  }

  Future<bool> setCheckVersionPrompt() async {
    final preferences = await SharedPreferences.getInstance();
    final versionLast = await getCheckVersionPrompt();
    return preferences.setInt(checkVersionPrompt, versionLast + 1);
  }

  Future<int> getCheckVersionPrompt() async {
    final preferences = await SharedPreferences.getInstance();
    final data = preferences.getInt(checkVersionPrompt);
    if (data == null) {
      return Future.value(0);
    }
    return Future.value(data);
  }

  Future<bool> setFirebaseToken(String token) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.setString(firebaseTokenKey, token);
  }

  Future<String?> getFirebaseToken() async {
    final preferences = await SharedPreferences.getInstance();
    final data = preferences.getString(firebaseTokenKey);
    if (data != null) {
      return Future.value(data);
    } else {
      return Future.value(null);
    }
  }

  Future<bool> clearData() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(userKey);
    await preferences.remove(tokenKey);
    await preferences.remove(alreadyLoginNetcore);

    const secureStorage = FlutterSecureStorage();
    await secureStorage.deleteAll();
    return true;
  }
}
