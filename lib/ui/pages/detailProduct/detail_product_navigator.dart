import 'package:SuperNinja/domain/commons/base_navigator.dart';
import 'package:flutter/material.dart';

abstract class DetailProductNavigator extends BaseNavigator {
  void successAddToCart();

  void showNeedLogin();

  void dismissPage();

  void showErrorMessage(String? text);

  BuildContext getContext();

  void productNotFound(String text);

}