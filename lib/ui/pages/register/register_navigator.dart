import 'package:SuperNinja/domain/commons/base_navigator.dart';

abstract class RegisterNavigator extends BaseNavigator {
  void showMainPage();
  // ignore: avoid_positional_boolean_parameters
  void showSuccessSentCode(bool isMethodEmail);
}
