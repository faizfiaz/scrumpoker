import 'dart:async';

import 'package:SuperNinja/domain/commons/base_view_model.dart';
import 'package:SuperNinja/domain/models/response/response_detail_order.dart';
import 'package:SuperNinja/domain/repositories/order_repository.dart';
import 'package:SuperNinja/domain/usecases/order/order_usecase.dart';
import 'package:SuperNinja/ui/pages/virtualAccountScreen/virtual_account_navigator.dart';

class VirtualAccountViewModel extends BaseViewModel<VirtualAccountNavigator> {
  late OrderUsecase _usecase;

  DetailOrder? detailOrder;
  late Timer timer;

  VirtualAccountViewModel(int? orderId) {
    _usecase = OrderUsecase(OrderRepository(dioClient));
    showLoading(true);
    timer = Timer.periodic(const Duration(seconds: 7), (timer) {
      checkStatusOrder(orderId);
    });
    checkStatusOrder(orderId);
  }

  void checkStatusOrder(int? orderId) {
    _usecase.getDetailOrder(orderId: orderId).then((value) {
      showLoading(false);
      if (value.values.first != null) {
      } else {
        detailOrder = value.keys.first!.data;
        checkStatus();
      }
    }).catchError((errorValue) {
      showLoading(false);
    });
  }

  void checkStatus() {
    if (detailOrder!.orderPayment!.latestStatus == "complete") {
      timer.cancel();
      getView()!.showComplete();
    } else if (detailOrder!.orderPayment!.latestStatus == "failed") {
      timer.cancel();
      getView()!.showPaymentError();
    }
  }
}
