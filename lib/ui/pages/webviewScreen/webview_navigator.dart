import 'package:SuperNinja/domain/commons/base_navigator.dart';

abstract class WebViewNavigator extends BaseNavigator {
  // ignore: avoid_positional_boolean_parameters
  void showPaymentStatus(bool isSuccess);

  void showPaymentProcess();
}
