import 'package:SuperNinja/domain/commons/base_navigator.dart';

abstract class FormAddressNavigator extends BaseNavigator {
  void showSuccess();

  void showErrorMessage(String message);
}
