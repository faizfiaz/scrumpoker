import 'package:SuperNinja/domain/commons/base_navigator.dart';

abstract class VirtualAccountNavigator extends BaseNavigator {
  void showComplete();

  void showPaymentError();
}
