import 'dart:convert';

import 'package:SuperNinja/data/remote/endpoints/commons_endpoints.dart';
import 'package:SuperNinja/domain/commons/base_view_model.dart';
import 'package:SuperNinja/domain/commons/other_utils.dart';
import 'package:SuperNinja/domain/models/entity/cart.dart';
import 'package:SuperNinja/domain/models/response/response_checkout.dart';
import 'package:SuperNinja/domain/models/response/response_detail_order.dart';
import 'package:SuperNinja/domain/models/response/response_driver_mr_speedy.dart';
import 'package:SuperNinja/domain/models/response/response_profile.dart';
import 'package:SuperNinja/domain/repositories/order_repository.dart';
import 'package:SuperNinja/domain/usecases/order/order_usecase.dart';
import 'package:SuperNinja/domain/usecases/user/user_usecase.dart';
import 'package:SuperNinja/ui/pages/detailOrder/detail_order_navigator.dart';
import 'package:SuperNinja/ui/widgets/multilanguage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DetailOrderViewModel extends BaseViewModel<DetailOrderNavigator> {
  late OrderUsecase _usecase;
  late UserUsecase _userUsecase;

  late Profile profile;
  DetailOrder? detailOrder;
  int? orderId;
  List<ResponseDriverMrSpeedy> responseDriverMrSpeedy = [];
  List<Courier?> couriers = [];
  String codeBankRefund = "";

  DetailOrderViewModel(this.orderId) {
    _userUsecase = UserUsecase.empty();
    _usecase = OrderUsecase(OrderRepository(dioClient));
    loadDataAPI();
    loadDataUser();
  }

  void loadDataAPI() {
    showLoading(true);
    _usecase.getDetailOrder(orderId: orderId).then((value) {
      showLoading(false);
      if (value.values.first != null) {
      } else {
        detailOrder = value.keys.first!.data;
        if (detailOrder != null) {
          if (detailOrder!.status!.toLowerCase() ==
                  OtherUtils.delivery.toLowerCase() &&
              detailOrder!.deliveryReference != null &&
              detailOrder!.deliveryReference!.isNotEmpty) {
            getDriverMrSpeedy(detailOrder!.deliveryReference!);
          }
          if (detailOrder!.orderPayment!.latestStatus!.toLowerCase() ==
              "failed") {
            detailOrder!.status = "expired";
          }
        }
        getView()!.doneRefresh();
        notifyListeners();
      }
      // ignore: invalid_return_type_for_catch_error
    }).catchError((errorValue) => getView()!.errorGetOrder());
  }

  String getAddressCL() {
    return "${detailOrder!.userCl!.address}, ${detailOrder!.userCl!.cityName} ${detailOrder!.userCl!.provinceName}";
  }

  void doScanBarcode(String barcodeScanRes) {
    showLoading(true);
    _usecase.doScanOrder(receiptCode: detailOrder!.receiptCode).then((value) {
      showLoading(false);
      if (value.values.first != null) {
        getView()!.showError(value.values.first!.errors, 0);
      } else {
        loadDataAPI();
        detailOrder!.status = "distributed_to_customer";
        getView()!.successScan();
        notifyListeners();
      }
      // ignore: invalid_return_type_for_catch_error
    }).catchError(print);
  }

  /// Step Create New Transaction
  /// Get List Cart
  /// Clear All Cart
  /// Loop Item to Add To Cart
  /// Get List Cart
  /// Go To Checkout Summaries
  /// */
  Cart? cart;
  Checkout? checkout;
  bool successAddToCart = true;

  void createNewTransaction(DetailOrder? detailOrder) {
    showLoading(true);

    _usecase.getListCarts().then((value) {
      if (value.values.first != null) {
      } else {
        cart = value.keys.first!.data;
        if (cart != null) {
          clearCart(cart!.cartId, detailOrder);
        }
      }
    }).catchError((errorValue) {
      addItemCart(detailOrder!);
    });
  }

  void clearCart(int? cartId, DetailOrder? detailOrder) {
    _usecase.clearAllCart(cartId: cart!.cartId).then((value) {
      showLoading(false);
      if (value.values.first != null) {
      } else {
        cart = null;
        addItemCart(detailOrder!);
        notifyListeners();
      }
      // ignore: invalid_return_type_for_catch_error
    }).catchError(print);
  }

  void addItemCart(DetailOrder detailOrder) {
    final products = <int?>[];
    var isError = false;
    for (final element in detailOrder.items!) {
      _usecase
          .addToCart(
              productId: element.product!.id,
              qty: element.qty,
              storeId: detailOrder.userCl!.storeId)
          .then((value) {
        if (value.values.first != null) {
          showLoading(false);
          successAddToCart = false;
          if (!isError) {
            getView()!.failedCreateNewTransaction();
            isError = true;
          }
        } else {
          showLoading(false);
        }
        notifyListeners();
      }).catchError((errorValue) {
        if (!isError) {
          successAddToCart = false;
          getView()!.failedCreateNewTransaction();
          isError = true;
        }
      });
    }
    if (successAddToCart) {
      _usecase.getListCarts().then((value) {
        if (value.values.first != null) {
        } else {
          cart = value.keys.first!.data;
          if (cart != null) {
            for (final element in cart!.items!) {
              products.add(element.id);
            }
            _usecase
                .doCheckout(
                    cartId: cart!.cartId, products: products, voucherCode: null)
                .then((value) {
              showLoading(false);
              if (value.values.first != null) {
              } else {
                checkout = value.keys.first!.data;
                getView()!.successCheckout(checkout, cart!.cartId, products);
              }
              // ignore: invalid_return_type_for_catch_error
            }).catchError((errorValue) => print("errorValue2"));
          }
        }
        // ignore: invalid_return_type_for_catch_error
      }).catchError(print);
    }
  }

  Future<void> getDriverMrSpeedy(String deliveryReference) async {
    final deliveryRefs = deliveryReference.split(",");
    for (final element in deliveryRefs) {
      if (element.isNotEmpty) {
        await requestMrSpeedy(element);
      }
    }
  }

  Future<void> requestMrSpeedy(String mrSpeedyID) async {
    final dio = Dio();
    final customHeaders = {
      'content-type': 'application/json',
      'X-DV-Auth-Token': dotenv.env['CURRENT_ENV'] == "0"
          ? "08E136E509E7CE6674A8234978192467C805D56C"
          : "53201290685078C5E439DD9AEF52FF3933F39075"
    };

    final options = Options();
    options.headers!.addAll(customHeaders);
    try {
      final response = await dio.get(
        CommonsEndpoints.urlDriverMrSpeedy(mrSpeedyID),
        queryParameters: null,
        options: options,
        cancelToken: null,
        onReceiveProgress: null,
      );
      OtherUtils.printWrapped(response.data.toString());
      final responseMrSpeedy = ResponseDriverMrSpeedy.fromJson(response.data);
      responseDriverMrSpeedy.add(responseMrSpeedy);
      if (responseMrSpeedy.courier != null) {
        couriers.add(responseMrSpeedy.courier);
      }
      notifyListeners();
    } on DioError catch (e) {
      print(e);
      OtherUtils.printWrapped(e.response.toString());
      rethrow;
    }
  }

  Future<void> loadDataUser() async {
    await _userUsecase.fetchUserData().then((value) {
      if (value != null) {
        profile = value;
      }
      // ignore: invalid_return_type_for_catch_error
    }).catchError(print);
    notifyListeners();
  }

  void postRefund(String accountName, String accountNumber, String email) {
    showLoading(true);
    _usecase
        .doRefundOrder(
            orderId: detailOrder!.id,
            amount: int.parse(detailOrder!.disburseAmount!),
            bankCode: codeBankRefund,
            bankAccountName: accountName,
            bankAccountNumber: accountNumber,
            description: "Disbursement Order ${detailOrder!.receiptCode}",
            externalId: "${detailOrder!.receiptCode}",
            emailTo: email)
        .then((value) {
      if (value.values.first != null) {
      } else {
        loadDataAPI();
        notifyListeners();
      }
    }).catchError((errorValue) {
      showLoading(false);
      getView()!.errorDisburse();
    });
  }

  String getStatusRefund() {
    if (detailOrder!.disburseData != null) {
      final disburseData = json.decode(detailOrder!.disburseData!);
      if (disburseData['status'] != null) {
        if (disburseData['status'] == "UPLOADING") {
          return txt("refund_inprocess");
        } else if (disburseData['status'] == "COMPLETED") {
          return txt("refund_complete");
        }
      }
      return disburseData['status'] ?? txt("refund_inprocess");
    }
    return "";
  }

  String getRefundFailure() {
    if (detailOrder!.disburseData != null) {
      final disburseData = json.decode(detailOrder!.disburseData!);
      print(disburseData['failure_code']);
      if (disburseData['failure_code'] != null) {
        if (disburseData['failure_code'] == "INSUFFICIENT_BALANCE") {
          return txt("refund_failed_maintenance");
        } else if (disburseData['failure_code'] ==
            "UNKNOWN_BANK_NETWORK_ERROR") {
          return txt("refund_failed_bank_error");
        } else if (disburseData['failure_code'] ==
            "TEMPORARY_BANK_NETWORK_ERROR") {
          return txt("refund_failed_bank_error");
        } else if (disburseData['failure_code'] == "INVALID_DESTINATION") {
          return txt("refund_failed_invalid_account");
        } else if (disburseData['failure_code'] == "SWITCHING_NETWORK_ERROR") {
          return txt("refund_failed_maintenance");
        } else if (disburseData['failure_code'] == "REJECTED_BY_BANK") {
          return txt("refund_failed_bank_error");
        } else if (disburseData['failure_code'] == "TRANSFER_ERROR") {
          return txt("refund_failed_bank_error");
        } else if (disburseData['failure_code'] == "TEMPORARY_TRANSFER_ERROR") {
          return txt("refund_failed_bank_error");
        }
      }
    }
    return "";
  }

  bool shouldShowScanButton() {
    //Means order using direct store
    if (detailOrder!.userCl!.id == null) {
      if (detailOrder!.status == OtherUtils.delivery) {
        return true;
      }
    } else {
      //Means order using Agent
      if (detailOrder!.status == OtherUtils.arrived) {
        return true;
      }
    }
    return false;
  }
}
