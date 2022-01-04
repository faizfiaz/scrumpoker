import 'package:SuperNinja/domain/commons/base_navigator.dart';

abstract class HomeNavigator extends BaseNavigator {
  void logoutSuccess();

  void showNeedUpdate(String? link);

  void showMustUpdate(String? link);
}
