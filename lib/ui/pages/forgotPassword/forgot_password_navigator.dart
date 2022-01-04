import 'package:SuperNinja/domain/commons/base_navigator.dart';

abstract class ForgotPasswordNavigator extends BaseNavigator {
  // ignore: avoid_positional_boolean_parameters
  void showInputCode(bool isEmail);

  void showRecoveryPage(String identity, int? codeId);
}
