import 'package:SuperNinja/domain/commons/base_navigator.dart';

abstract class ShopRoutineNavigator extends BaseNavigator{
  void doneGet();

  void successAddToCart();

  void showNeedLogin();

  void showErrorMessage(String message);
}