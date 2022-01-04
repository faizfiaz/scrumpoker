import 'package:SuperNinja/domain/commons/base_navigator.dart';
import 'package:SuperNinja/domain/models/response/response_checkout.dart';

abstract class CartNavigator extends BaseNavigator {
  void successClearCart();
  void successCheckout(Checkout? checkout, int? cartId, List<int> products);
  void doneRefresh();
  void showToastError(int itemId, String? errorMessage);
  void successEdit(int itemId);
}
