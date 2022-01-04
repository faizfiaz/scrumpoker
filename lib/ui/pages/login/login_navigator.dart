import 'package:scrumpoker/domain/commons/base_navigator.dart';

abstract class LoginNavigator extends BaseNavigator {
  void showMainPage();

  void showRegisterThirdParty(
      String? email, String? displayName, String? photoUrl, String registerVia);
}
