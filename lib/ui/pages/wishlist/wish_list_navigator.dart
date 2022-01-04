import 'package:SuperNinja/domain/commons/base_navigator.dart';
import 'package:flutter/material.dart';

abstract class WishListNavigator extends BaseNavigator {
  void doneGet();

  void successAddToCart();

  void showNeedLogin();

  void showErrorMessage(String? message);

  BuildContext getContext();
}
