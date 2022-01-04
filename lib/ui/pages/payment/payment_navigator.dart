import 'package:SuperNinja/domain/commons/base_navigator.dart';

abstract class PaymentNavigator extends BaseNavigator {
  void successOrder(String? url, int? orderId);

  void storeClosed();

  void doneRefresh();

  void addressOutOfRange();
}
