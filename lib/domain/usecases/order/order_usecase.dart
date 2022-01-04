import 'package:SuperNinja/data/sharedpreference/user_preferences.dart';
import 'package:SuperNinja/domain/models/entity/no_content.dart';
import 'package:SuperNinja/domain/models/error/error_message.dart';
import 'package:SuperNinja/domain/models/response/response_checkout.dart';
import 'package:SuperNinja/domain/models/response/response_checkout_order.dart';
import 'package:SuperNinja/domain/models/response/response_count_carts.dart';
import 'package:SuperNinja/domain/models/response/response_count_order.dart';
import 'package:SuperNinja/domain/models/response/response_detail_order.dart';
import 'package:SuperNinja/domain/models/response/response_list_carts.dart';
import 'package:SuperNinja/domain/models/response/response_list_order.dart';
import 'package:SuperNinja/domain/models/response/response_list_payment.dart';
import 'package:SuperNinja/domain/repositories/order_repository.dart';

import 'i_order_usecase.dart';

class OrderUsecase extends IOrderUsecase {
  final userSp = UserPreferences();

  OrderUsecase(OrderRepository repository) : super(repository);

  OrderUsecase.empty() : super(null);

  @override
  Future<Map<NoContent?, ErrorMessage?>> addToCart(
      {required int? productId,
      required int? qty,
      required int? storeId}) async {
    disposeVariable();
    NoContent? response;
    await repository
        ?.addToCart(productId: productId, qty: qty, storeId: storeId)
        .then((val) {
      response = val;
    }).catchError((e) async {
      await mappingError(error, e).then((value) => error = value);
      print(error!.errors!.first.error);
    });
    return Future.value({response: error});
  }

  @override
  Future<Map<ResponseListCarts?, ErrorMessage?>> getListCarts() async {
    disposeVariable();
    ResponseListCarts? response;
    await repository?.getListCart().then((val) {
      response = val;
    }).catchError((e) async {
      await mappingError(error, e).then((value) => error = value);
    });
    return Future.value({response: error});
  }

  @override
  Future<Map<ResponseCountCart?, ErrorMessage?>> getCountCarts() async {
    disposeVariable();
    ResponseCountCart? response;
    await repository?.countCartItem().then((val) {
      response = val;
    }).catchError((e) async {
      await mappingError(error, e).then((value) => error = value);
    });
    return Future.value({response: error});
  }

  @override
  Future<Map<NoContent?, ErrorMessage?>> clearAllCart({int? cartId}) async {
    disposeVariable();
    NoContent? response;
    await repository?.clearAllCart(cartId: cartId).then((val) {
      response = val;
    }).catchError((e) async {
      await mappingError(error, e).then((value) => error = value);
    });
    return Future.value({response: error});
  }

  @override
  Future<Map<ResponseCheckout?, ErrorMessage?>> doCheckout(
      {required int? cartId,
      required List<int?>? products,
      required String? voucherCode}) async {
    disposeVariable();
    ResponseCheckout? response;
    await repository
        ?.doCheckout(
            cartId: cartId, products: products, voucherCode: voucherCode)
        .then((val) {
      response = val;
    }).catchError((e) async {
      await mappingError(error, e).then((value) => error = value);
    });
    return Future.value({response: error});
  }

  @override
  Future<Map<ResponseListOrder?, ErrorMessage?>> listOrder(
      {int? page, String? status}) async {
    disposeVariable();
    ResponseListOrder? response;
    await repository?.listOrder(page: page, status: status).then((val) {
      response = val;
    }).catchError((e) async {
      await mappingError(error, e).then((value) => error = value);
    });
    return Future.value({response: error});
  }

  @override
  Future<Map<ResponseListPayment?, ErrorMessage?>> getListPayment() async {
    disposeVariable();
    ResponseListPayment? response;
    await repository?.listPayment().then((val) {
      response = val;
    }).catchError((e) async {
      await mappingError(error, e).then((value) => error = value);
    });
    return Future.value({response: error});
  }

  @override
  Future<Map<ResponseCheckoutOrder?, ErrorMessage?>> checkoutOrder(
      {Map<String, dynamic>? checkoutPayload}) async {
    disposeVariable();
    ResponseCheckoutOrder? response;
    await repository
        ?.checkoutOrder(checkoutPayload: checkoutPayload)
        .then((val) {
      response = val;
    }).catchError((e) async {
      await mappingError(error, e).then((value) => error = value);
    });
    return Future.value({response: error});
  }

  @override
  Future<Map<ResponseCountOrder?, ErrorMessage?>> getCountOrder() async {
    disposeVariable();
    ResponseCountOrder? response;
    await repository?.countOrder().then((val) {
      response = val;
    }).catchError((e) async {
      await mappingError(error, e).then((value) => error = value);
    });
    return Future.value({response: error});
  }

  @override
  Future<Map<ResponseDetailOrder?, ErrorMessage?>> getDetailOrder(
      {int? orderId}) async {
    disposeVariable();
    ResponseDetailOrder? response;
    await repository?.getDetailOrder(orderId: orderId).then((val) {
      response = val;
    }).catchError((e) async {
      await mappingError(error, e).then((value) => error = value);
    });
    return Future.value({response: error});
  }

  @override
  Future<Map<NoContent?, ErrorMessage?>> editQtyCard(
      {int? itemId, int? qty}) async {
    disposeVariable();
    NoContent? response;
    await repository?.editCart(itemId: itemId, qty: qty).then((val) {
      response = val;
    }).catchError((e) async {
      await mappingError(error, e).then((value) => error = value);
    });
    return Future.value({response: error});
  }

  @override
  Future<Map<NoContent?, ErrorMessage?>> removeItemCart({int? itemId}) async {
    disposeVariable();
    NoContent? response;
    await repository?.removeItemCart(itemId: itemId).then((val) {
      response = val;
    }).catchError((e) async {
      await mappingError(error, e).then((value) => error = value);
    });
    return Future.value({response: error});
  }

  @override
  Future<Map<NoContent?, ErrorMessage?>> doScanOrder(
      {String? receiptCode}) async {
    disposeVariable();
    NoContent? response;
    await repository?.doScanOrder(receiptCode: receiptCode).then((val) {
      response = val;
    }).catchError((e) async {
      await mappingError(error, e).then((value) => error = value);
    });
    return Future.value({response: error});
  }

  @override
  Future<Map<NoContent?, ErrorMessage?>> doRefundOrder(
      {int? orderId,
      int? amount,
      String? bankCode,
      String? bankAccountName,
      String? bankAccountNumber,
      String? description,
      String? externalId,
      String? emailTo}) async {
    disposeVariable();
    NoContent? response;
    await repository
        ?.doRefundOrder(
            orderId: orderId,
            amount: amount,
            bankCode: bankCode,
            bankAccountName: bankAccountName,
            bankAccountNumber: bankAccountNumber,
            description: description,
            externalId: externalId,
            emailTo: emailTo)
        .then((val) {
      response = val;
    }).catchError((e) async {
      await mappingError(error, e).then((value) => error = value);
    });
    return Future.value({response: error});
  }

  @override
  Future<Map<NoContent?, ErrorMessage?>> doUpdateStatusWaitingXendit(
      {int? orderId}) async {
    disposeVariable();
    NoContent? response;
    await repository?.doUpdateStatusWaitingXendit(orderId: orderId).then((val) {
      response = val;
    }).catchError((e) async {
      await mappingError(error, e).then((value) => error = value);
    });
    return Future.value({response: error});
  }
}
