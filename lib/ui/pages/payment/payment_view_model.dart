// ignore_for_file: invalid_return_type_for_catch_error

import 'package:SuperNinja/domain/commons/base_view_model.dart';
import 'package:SuperNinja/domain/models/response/response_checkout.dart';
import 'package:SuperNinja/domain/models/response/response_list_address.dart';
import 'package:SuperNinja/domain/models/response/response_list_payment.dart';
import 'package:SuperNinja/domain/repositories/order_repository.dart';
import 'package:SuperNinja/domain/usecases/order/order_usecase.dart';
import 'package:SuperNinja/ui/pages/payment/payment_navigator.dart';

class PaymentViewModel extends BaseViewModel<PaymentNavigator> {
  late OrderUsecase _usecase;

  List<Payment>? paymentList = [];
  Checkout? checkout;
  Voucher? voucher;
  Payment? paymentSelected;
  UserAddress? address;

  PaymentViewModel(this.checkout, this.voucher, this.address) {
    _usecase = OrderUsecase(OrderRepository(dioClient));
    loadListPayment();
  }

  void loadListPayment() {
    showLoading(true);
    _usecase.getListPayment().then((value) {
      showLoading(false);
      getView()!.doneRefresh();
      if (value.values.first != null) {
      } else {
        paymentList = value.keys.first!.data;
        notifyListeners();
      }
    }).catchError(print);
  }

  void selectPayment(String? paymentValue) {
    for (final element in paymentList!) {
      if (paymentValue == element.code) {
        paymentSelected = element;
      }
    }
    notifyListeners();
  }

  void checkoutOrder(String? paymentValue) {
    showLoading(true);
    _usecase
        .checkoutOrder(checkoutPayload: _buildRequest(paymentValue))
        .then((value) {
      showLoading(false);
      if (value.values.first != null) {
        if (value.values.first!.errors!.isNotEmpty &&
            value.values.first!.errors![0].error != null) {
          if (value.values.first!.errors![0].error!
              .toLowerCase()
              .contains("closed")) {
            getView()!.storeClosed();
          } else {
            if (value.values.first!.errors!.first.error!
                .contains("User address is out of range")) {
              getView()!.addressOutOfRange();
            } else {
              getView()!.showError(value.values.first!.errors, 0);
            }
          }
        }
      } else {
        final url = value.keys.first!.data!.redirectUrl;
        final orderId = value.keys.first!.data!.orderId;
        getView()!.successOrder(url, orderId);
      }
    }).catchError(print);
  }

  Map<String, dynamic> _buildRequest(String? paymentValue) {
    final listProduct = <int?>[];
    for (final element in checkout!.items!) {
      listProduct.add(element.id);
    }
    if (voucher != null) {
      return {
        "cart_id": checkout!.cartId,
        "cart_items": listProduct,
        "user_address_id": address?.id,
        "delivery_fee": checkout!.deliveryFee,
        "payment_method_id": int.parse(paymentValue!),
        "notes": checkout!.notes ?? "",
        "voucher_code": voucher!.code
      };
    }
    return {
      "cart_id": checkout!.cartId,
      "cart_items": listProduct,
      "user_address_id": address?.id,
      "delivery_fee": checkout!.deliveryFee,
      "payment_method_id": int.parse(paymentValue!),
      "notes": checkout!.notes ?? ""
    };
  }
}
