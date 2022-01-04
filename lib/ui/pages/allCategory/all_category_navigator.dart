import 'package:SuperNinja/domain/commons/base_navigator.dart';

abstract class AllCategoryNavigator extends BaseNavigator{
  void showNeedLogin();

  void successAddToCart();

  void showErrorMessage(String message);
}