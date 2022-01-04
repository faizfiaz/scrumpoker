import 'package:SuperNinja/domain/commons/base_navigator.dart';
import 'package:flutter/material.dart';

abstract class PromoNavigator extends BaseNavigator {
  void doneGet();

  void showNeedLogin();

  void successAddToCart();

  void showErrorMessage(String? message);

  BuildContext getContext();
}
