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

import '../base_usecase.dart';

abstract class IOrderUsecase extends BaseUsecase<OrderRepository?> {
  IOrderUsecase(OrderRepository? repository) : super(repository);

  Future<Map<NoContent?, ErrorMessage?>> addToCart(
      {required int productId, required int qty, required int storeId});

  Future<Map<ResponseListCarts?, ErrorMessage?>> getListCarts();

  Future<Map<ResponseCountCart?, ErrorMessage?>> getCountCarts();

  Future<Map<NoContent?, ErrorMessage?>> clearAllCart({required int cartId});

  Future<Map<ResponseCheckout?, ErrorMessage?>> doCheckout(
      {required int cartId,
      required List<int> products,
      required String voucherCode});

  Future<Map<ResponseListOrder?, ErrorMessage?>> listOrder(
      {required int page, required String status});

  Future<Map<ResponseListPayment?, ErrorMessage?>> getListPayment();

  Future<Map<ResponseCheckoutOrder?, ErrorMessage?>> checkoutOrder(
      {required Map<String, dynamic> checkoutPayload});

  Future<Map<ResponseCountOrder?, ErrorMessage?>> getCountOrder();

  Future<Map<ResponseDetailOrder?, ErrorMessage?>> getDetailOrder(
      {required int orderId});

  Future<Map<NoContent?, ErrorMessage?>> editQtyCard(
      {required int itemId, required int qty});

  Future<Map<NoContent?, ErrorMessage?>> removeItemCart({required int itemId});

  Future<Map<NoContent?, ErrorMessage?>> doScanOrder(
      {required String receiptCode});

  Future<Map<NoContent?, ErrorMessage?>> doRefundOrder(
      {required int orderId,
      required int amount,
      required String bankCode,
      required String bankAccountName,
      required String bankAccountNumber,
      required String description,
      required String externalId,
      required String emailTo});

  Future<Map<NoContent?, ErrorMessage?>> doUpdateStatusWaitingXendit(
      {required int orderId});
}
