import 'package:SuperNinja/domain/commons/base_navigator.dart';
import 'package:SuperNinja/domain/models/response/response_checkout.dart';

abstract class DetailOrderNavigator extends BaseNavigator {
  void successScan();

  void failedCreateNewTransaction();

  void successCheckout(Checkout? checkout, int? cartId, List<int?> products);

  void errorGetOrder();

  void doneRefresh();

  void errorDisburse();
}
