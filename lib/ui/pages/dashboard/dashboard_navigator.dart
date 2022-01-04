import 'package:SuperNinja/domain/commons/base_navigator.dart';
import 'package:SuperNinja/domain/models/entity/category.dart';
import 'package:flutter/material.dart';

abstract class DashboardNavigator extends BaseNavigator {
  void doneGet();

  void updateListCategory(List<Category> categoryList);

  void showNeedLogin();

  void successAddToCart();

  void successWishList();

  void showErrorMessage(String? message);

  void refreshHome();

  BuildContext getContext();
}
