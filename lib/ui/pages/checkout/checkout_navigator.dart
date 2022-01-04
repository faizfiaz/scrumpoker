import 'package:SuperNinja/domain/commons/base_navigator.dart';

abstract class CheckoutNavigator extends BaseNavigator {
  void getPotentialDiscount();

  void showNeedIdentity();

  void showAddressNotComplete();
}
