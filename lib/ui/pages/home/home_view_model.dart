// ignore_for_file: invalid_return_type_for_catch_error

import 'dart:io';

import 'package:SuperNinja/domain/commons/base_view_model.dart';
import 'package:SuperNinja/domain/commons/tracking_utils.dart';
import 'package:SuperNinja/domain/models/response/response_count_carts.dart';
import 'package:SuperNinja/domain/models/response/response_profile.dart';
import 'package:SuperNinja/domain/models/response/response_version.dart';
import 'package:SuperNinja/domain/repositories/order_repository.dart';
import 'package:SuperNinja/domain/repositories/user_repository.dart';
import 'package:SuperNinja/domain/usecases/order/order_usecase.dart';
import 'package:SuperNinja/domain/usecases/user/user_usecase.dart';
import 'package:SuperNinja/ui/pages/home/home_navigator.dart';
import 'package:smartech_flutter_plugin/smartech_plugin.dart';

class HomeViewModel extends BaseViewModel<HomeNavigator> {
  static const int versionNotUpdate = 1;
  static const int versionMustUpdate = 2;

  late UserUsecase _usecase;
  late OrderUsecase _orderUsecase;

  Profile? profile;
  CountCarts? countCarts;
  AppVersionInfo? appVersionInfo;

  late bool isAlreadyLogin;
  int? totalUnreadNotification = 0;

  HomeViewModel() {
    _usecase = UserUsecase(UserRepository(dioClient));
    _orderUsecase = OrderUsecase(OrderRepository(dioClient));
    loadDataApi();
    checkVersionFromAPI();
    // _usecase.getCheckVersionPrompt().then((value) {
    //   _usecase.setCheckVersionPrompt();
    //   if (value == 0) {
    //     checkVersionFromAPI();
    //   } else {
    //     if (value % 10 == 0) {
    //       checkVersionFromAPI();
    //     }
    //   }
    // });
  }

  Future<void> getProfile() async {
    showLoading(true);
    await _usecase.getProfile().then((value) {
      showLoading(false);
      if (value.values.first != null) {
        getView()!.showError(
            value.values.first!.errors, value.values.first!.httpCode);
      } else {
        profile = value.keys.first!.data;
        SmartechPlugin().login(profile!.id.toString());
      }
    }).catchError(print);
    notifyListeners();
  }

  Future<void> loadDataApi() async {
    isAlreadyLogin = await _usecase.hasToken();
    if (isAlreadyLogin) {
      await getProfile();
      loadCountCart();
      await loadCountNotification();
    }
  }

  Future<void> checkVersionFromAPI() async {
    await _usecase.checkVersion().then((value) {
      if (value.values.first != null) {
        getView()!.showError(
            value.values.first!.errors, value.values.first!.httpCode);
      } else {
        appVersionInfo = value.keys.first!.data;
        if (appVersionInfo!.statusCode == versionNotUpdate) {
          getView()!.showNeedUpdate(Platform.isAndroid
              ? appVersionInfo!.linkAndroid
              : appVersionInfo!.linkIos);
        } else if (appVersionInfo!.statusCode == versionMustUpdate) {
          getView()!.showMustUpdate(Platform.isAndroid
              ? appVersionInfo!.linkAndroid
              : appVersionInfo!.linkIos);
        }
      }
    }).catchError((errorValue) => print);
  }

  void loadCountCart() {
    _orderUsecase.getCountCarts().then((value) {
      if (value.values.first != null) {
      } else {
        countCarts = value.keys.first!.data;
        notifyListeners();
      }
    }).catchError(print);
  }

  Future<void> doLogout() async {
    showLoading(true);
    await _usecase.doLogout().then((value) {
      showLoading(false);
      if (value.values.first != null) {
        SmartechPlugin()
            .trackEvent(TrackingUtils.LOGOUT, TrackingUtils.getEmptyPayload());
        SmartechPlugin().logoutAndClearUserIdentity(true);
        UserUsecase.empty()
            .logout()
            .then((value) => getView()!.logoutSuccess());
      } else {
        SmartechPlugin()
            .trackEvent(TrackingUtils.LOGOUT, TrackingUtils.getEmptyPayload());
        SmartechPlugin().logoutAndClearUserIdentity(true);
        UserUsecase.empty()
            .logout()
            .then((value) => getView()!.logoutSuccess());
      }
    }).catchError(print);
    notifyListeners();
  }

  Future<void> loadCountNotification() async {
    await _usecase.countUnreadNotification().then((value) {
      if (value.values.first != null) {
        getView()!.showError(
            value.values.first!.errors, value.values.first!.httpCode);
      } else {
        totalUnreadNotification =
            value.keys.first!.data!.totalUnreadNotification;
      }
    }).catchError(print);
    notifyListeners();
  }
}
