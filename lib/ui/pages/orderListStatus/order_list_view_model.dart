// ignore_for_file: invalid_return_type_for_catch_error

import 'package:SuperNinja/domain/commons/base_view_model.dart';
import 'package:SuperNinja/domain/models/response/response_count_order.dart';
import 'package:SuperNinja/domain/models/response/response_list_order.dart';
import 'package:SuperNinja/domain/repositories/order_repository.dart';
import 'package:SuperNinja/domain/usecases/order/order_usecase.dart';
import 'package:SuperNinja/ui/pages/orderListStatus/order_list_navigator.dart';

class OrderListViewModel extends BaseViewModel<OrderListNavigator> {
  late OrderUsecase _usecase;
  int position = 0;

  CountOrder? countOrder;
  int page = 0;
  List<Order>? orderList = [];
  int? totalPage = 0;

  OrderListViewModel(this.position, this.countOrder) {
    _usecase = OrderUsecase(OrderRepository(dioClient));
    loadDataApi(true, false);
  }

  // ignore: avoid_positional_boolean_parameters
  void loadDataApi(bool isInit, bool isLoadMore) {
    if (isInit) {
      page = 0;
    }
    if (isLoadMore) {
      ++page;
    } else {
      showLoading(true);
    }
    _usecase.listOrder(page: page, status: getStatus()).then((value) {
      showLoading(false);
      if (value.values.first != null) {
      } else {
        final dataOrder = value.keys.first!.data!;
        if (!isLoadMore) {
          orderList = dataOrder.data;
        } else {
          orderList!.addAll(dataOrder.data!);
        }
        totalPage = dataOrder.totalPage;
        checkIsRefresh();
        notifyListeners();
      }
    }).catchError(print);
  }

  void loadCountData() {
    _usecase.getCountOrder().then((value) {
      showLoading(false);
      if (value.values.first != null) {
      } else {
        countOrder = value.keys.first!.data;
        notifyListeners();
      }
    }).catchError(print);
  }

  // ignore: slash_for_doc_comments
  /**
   * 0 = "waiting_payment"
   * 1 = "inprogress"
   * 2 = "delivery"
   * 3 = "arrived"
   * 5 = "all"/""
   * */
  String getStatus() {
    switch (position) {
      case 0:
        return "waiting_payment";
      case 1:
        return "inprogress";
      case 2:
        return "delivery";
      case 3:
        return "arrived";
      default:
        return "";
    }
  }

  void checkIsRefresh() {
    getView()!.refreshDone();
  }
}
