import 'package:SuperNinja/data/remote/dio_client.dart';
import 'package:SuperNinja/ui/widgets/multilanguage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'base_navigator.dart';

abstract class BaseViewModel<NV extends BaseNavigator> extends ChangeNotifier {
  NV? view;
  DioClient? dioClient;

  bool isLoading = false;

  BaseViewModel() {
    dioClient = DioClient(Dio());
  }

  // ignore: avoid_returning_this
  BaseViewModel setView(NV view) {
    this.view = view;
    return this;
  }

  NV? getView() {
    return view;
  }

  // ignore: avoid_positional_boolean_parameters
  void showLoading(bool isLoading) {
    this.isLoading = isLoading;
    notifyListeners();
  }

  void checkExpired(int httpCode) {
    // if (httpCode == 400) {
    //   getView().showExpired();
    // }
  }

  Future<void> changeLanguage(BuildContext context) async {
    var languages = Languages.en;
    final prefs = await SharedPreferences.getInstance();
    final currentLanguage = prefs.getString(langKey);
    if (currentLanguage != null) {
      if (currentLanguage == Languages.en) {
        languages = Languages.id;
      } else {
        languages = Languages.en;
      }
    }
    await MultiLanguage()
        .setLanguage(path: languages, context: context)
        .then((value) {
      getView()!.refreshState();
      notifyListeners();
    });
  }

  @override
  void dispose();
}
