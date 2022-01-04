// ignore_for_file: invalid_return_type_for_catch_error

import 'package:SuperNinja/domain/commons/base_view_model.dart';
import 'package:SuperNinja/domain/models/response/response_detail_order.dart';
import 'package:SuperNinja/domain/repositories/order_repository.dart';
import 'package:SuperNinja/domain/usecases/order/order_usecase.dart';
import 'package:SuperNinja/ui/pages/webviewScreen/webview_navigator.dart';

class WebviewViewModel extends BaseViewModel<WebViewNavigator> {
  late OrderUsecase _usecase;

  DetailOrder? detailOrder;

  WebviewViewModel() {
    _usecase = OrderUsecase(OrderRepository(dioClient));
  }

  void checkStatusOrder(int? orderId) {
    _usecase.getDetailOrder(orderId: orderId).then((value) {
      if (value.values.first != null) {
      } else {
        detailOrder = value.keys.first!.data;
        checkStatus();
      }
    }).catchError(print);
  }

  void checkStatus() {
    if (detailOrder!.orderPayment!.paymentType == "credit_card") {
      if (detailOrder!.orderPayment!.latestStatus == "complete") {
        getView()!.showPaymentStatus(true);
      } else {
        getView()!.showPaymentStatus(false);
      }
    } else {
      showLoading(true);
      _usecase
          .doUpdateStatusWaitingXendit(orderId: detailOrder!.id)
          .then((value) {
        getView()!.showPaymentProcess();
      });
    }
  }
}
