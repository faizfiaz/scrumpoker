import 'package:SuperNinja/domain/models/error/error_message.dart';

abstract class BaseNavigator {
  // ignore: avoid_positional_boolean_parameters
  void setLoadingPage(bool condition);
  void showError(List<Errors>? error, int? httpCode);
  void showExpired() {}
  void refreshState();
}
