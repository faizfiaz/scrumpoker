// ignore_for_file: prefer_mixin

import 'package:SuperNinja/domain/commons/screen_utils.dart';
import 'package:SuperNinja/domain/models/error/error_message.dart';
import 'package:SuperNinja/ui/widgets/multilanguage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:need_resume/need_resume.dart';

import 'base_navigator.dart';

class BaseStateWidget<S extends StatefulWidget> extends ResumableState<S>
    with BaseNavigator {
  bool isLoading = true;

  @override
  void initState() {
    // if (Platform.isAndroid) {
    //   secureScreen();
    // }
    super.initState();
  }

  Future<void> secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  void changeLanguage(String languages) {
    MultiLanguage().setLanguage(path: languages, context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  // ignore: avoid_positional_boolean_parameters
  void setLoading(bool condition) {
    isLoading = condition;
  }

  @override
  void setLoadingPage(bool condition) {
    setLoading(condition);
  }

  @override
  void showError(List<Errors>? error, int? httpCode) {
    checkExpired(error, httpCode);
  }

  void checkExpired(List<Errors>? error, int? httpCode) {
    // if (httpCode == 400) {
    //   showExpired();
    // } else {
    ScreenUtils.showAlertMessage(context, error, httpCode);
    // }
  }

  @override
  void showExpired() {
    ScreenUtils.showExpiredMessage(context);
  }

  @override
  void refreshState() {
    setState(() {});
  }
}
