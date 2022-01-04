import 'package:scrumpoker/data/remote/dio_client.dart';
import 'package:scrumpoker/data/remote/endpoints/order_endpoints.dart';
import 'package:scrumpoker/domain/models/entity/no_content.dart';
import 'package:scrumpoker/domain/models/response/response_checkout.dart';
import 'package:scrumpoker/domain/models/response/response_checkout_order.dart';
import 'package:scrumpoker/domain/models/response/response_count_carts.dart';
import 'package:scrumpoker/domain/models/response/response_count_order.dart';
import 'package:scrumpoker/domain/models/response/response_detail_order.dart';
import 'package:scrumpoker/domain/models/response/response_list_carts.dart';
import 'package:scrumpoker/domain/models/response/response_list_order.dart';
import 'package:scrumpoker/domain/models/response/response_list_payment.dart';
import 'package:scrumpoker/domain/repositories/base_repository.dart';

class OrderRepository extends BaseRepository {
  OrderRepository(DioClient? dioClient) : super(dioClient);

  dynamic data;

  Future<NoContent> addToCart(
      {required int? productId,
      required int? qty,
      required int? storeId}) async {
    await dioClient!.post(OrderEndpoint.urlAddToCart, data: {
      "product_id": productId,
      "qty": qty,
      "store_id": storeId
    }).then((value) {
      data = value;
    });

    return NoContent();
  }

  Future<ResponseListCarts> getListCart() async {
    await dioClient!.get(OrderEndpoint.urlCarts).then((value) {
      data = value;
    });
    return ResponseListCarts.fromJson(data);
  }

  Future<ResponseCountCart> countCartItem() async {
    await dioClient!.get(OrderEndpoint.urlCountCarts).then((value) {
      data = value;
    });
    return ResponseCountCart.fromJson(data);
  }

  Future<ResponseCheckout> doCheckout(
      {int? cartId, List<int?>? products, String? voucherCode}) async {
    var payload = {};
    if (voucherCode != null) {
      payload = {
        "cart_id": cartId,
        "cart_items": products,
        "voucher_code": voucherCode
      };
    } else {
      payload = {"cart_id": cartId, "cart_items": products};
    }

    await dioClient!
        .post(OrderEndpoint.urlCheckoutSummaries, data: payload)
        .then((value) {
      data = value;
    });
    return ResponseCheckout.fromJson(data);
  }

  Future<NoContent> clearAllCart({required int? cartId}) async {
    await dioClient!
        .delete(OrderEndpoint.urlClearCart(cartId: cartId))
        .then((value) {
      data = value;
    });
    return NoContent();
  }

  Future<ResponseListOrder> listOrder(
      {required int? page, required String? status}) async {
    await dioClient!
        .get(OrderEndpoint.urlListOrder(page: page, status: status))
        .then((value) {
      data = value;
    });
    return ResponseListOrder.fromJson(data);
  }

  Future<ResponseListPayment> listPayment() async {
    await dioClient!.get(OrderEndpoint.urlPaymentList).then((value) {
      data = value;
    });
    return ResponseListPayment.fromJson(data);
  }

  Future<ResponseCheckoutOrder> checkoutOrder(
      {required Map<String, dynamic>? checkoutPayload}) async {
    await dioClient!
        .post(OrderEndpoint.urlCheckout, data: checkoutPayload)
        .then((value) {
      data = value;
    });
    return ResponseCheckoutOrder.fromJson(data);
  }

  Future<ResponseCountOrder> countOrder() async {
    await dioClient!.get(OrderEndpoint.urlCountOrder).then((value) {
      data = value;
    });

    return ResponseCountOrder.fromJson(data);
  }

  Future<ResponseDetailOrder> getDetailOrder({required int? orderId}) async {
    await dioClient!
        .get(OrderEndpoint.urlDetailOrder(orderId: orderId))
        .then((value) {
      data = value;
    });

    return ResponseDetailOrder.fromJson(data);
  }

  Future<NoContent> editCart({required int? itemId, required int? qty}) async {
    await dioClient!.put(OrderEndpoint.urlEditCart(itemId: itemId),
        data: {"qty": qty}).then((value) {
      data = value;
    });

    return NoContent();
  }

  Future<NoContent> removeItemCart({required int? itemId}) async {
    await dioClient!
        .delete(OrderEndpoint.urlDeleteItemCart(cartItemId: itemId))
        .then((value) {
      data = value;
    });

    return NoContent();
  }

  Future<NoContent> doScanOrder({required String? receiptCode}) async {
    await dioClient!.put(OrderEndpoint.urlDoScan(receiptCode: receiptCode),
        data: {"status": "distributed_to_customer"}).then((value) {
      data = value;
    });

    return NoContent();
  }

  Future<NoContent> doRefundOrder({
    required int? orderId,
    required int? amount,
    required String? bankCode,
    required String? bankAccountName,
    required String? bankAccountNumber,
    required String? description,
    required String? externalId,
    required String? emailTo,
  }) async {
    await dioClient!.post(OrderEndpoint.urlDoRefund(orderId: orderId), data: {
      "amount": amount,
      "bank_code": bankCode,
      "bank_account_name": bankAccountName,
      "bank_account_number": bankAccountNumber,
      "description": description,
      "external_id": externalId,
      "email_to": [
        emailTo,
      ],
    }).then((value) {
      data = value;
    });

    return NoContent();
  }

  Future<NoContent> doUpdateStatusWaitingXendit({required int? orderId}) async {
    await dioClient!
        .put(OrderEndpoint.urlUpdateStatusWaitingXendit(orderId: orderId))
        .then((value) {
      data = value;
    });

    return NoContent();
  }
}
