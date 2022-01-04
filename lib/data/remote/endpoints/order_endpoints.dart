import 'package:scrumpoker/data/remote/endpoints/endpoints.dart';

class OrderEndpoint {
  OrderEndpoint._();

  static String urlAddToCart = '${Endpoints().baseUrl!}/v1/carts';
  static String urlCarts = '${Endpoints().baseUrl!}/v1/carts/summaries';
  static String urlCountCarts = '${Endpoints().baseUrl!}/v1/carts/count-item';

  static String urlClearCart({int? cartId}) {
    return '${Endpoints().baseUrl!}/v1/carts/$cartId';
  }

  static String urlListOrder({int? page, String? status}) {
    return '${Endpoints().baseUrl!}/v1/orders?page=$page&per_page=15&status=$status';
  }

  static String urlCheckoutSummaries =
      '${Endpoints().baseUrl!}/v1/orders/checkout-summaries';
  static String urlPaymentList = '${Endpoints().baseUrl!}/v1/payment-methods';
  static String urlCheckout = '${Endpoints().baseUrl!}/v1/orders/checkout';
  static String urlCountOrder = '${Endpoints().baseUrl!}/v1/orders/count';

  static String urlDetailOrder({int? orderId}) {
    return '${Endpoints().baseUrl!}/v1/orders/detail/$orderId';
  }

  static String urlEditCart({int? itemId}) {
    return '${Endpoints().baseUrl!}/v1/cart-items/$itemId';
  }

  static String urlDeleteItemCart({int? cartItemId}) {
    return '${Endpoints().baseUrl!}/v1/cart-items/$cartItemId';
  }

  static String urlDoScan({String? receiptCode}) {
    return '${Endpoints().baseUrl!}/v1/orders/detail/$receiptCode/update-status';
  }

  static String urlDoRefund({int? orderId}) {
    return '${Endpoints().baseUrl!}/v1/orders/detail/$orderId/disburse';
  }

  static String urlUpdateStatusWaitingXendit({int? orderId}) {
    return '${Endpoints().baseUrl!}/v1/orders/detail/$orderId/waiting-approval-xendit';
  }
}
