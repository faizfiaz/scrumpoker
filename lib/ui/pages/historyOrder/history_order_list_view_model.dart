// ignore_for_file: invalid_return_type_for_catch_error

import 'package:SuperNinja/domain/commons/base_view_model.dart';
import 'package:SuperNinja/domain/models/response/response_list_order.dart';
import 'package:SuperNinja/domain/repositories/order_repository.dart';
import 'package:SuperNinja/domain/usecases/order/order_usecase.dart';
import 'package:SuperNinja/ui/pages/historyOrder/history_order_list_navigator.dart';

class HistoryOrderListViewModel
    extends BaseViewModel<HistoryOrderListNavigator> {
  late OrderUsecase _usecase;

  int page = 0;
  List<Order>? orderList = [];
  int? totalPage = 0;

  HistoryOrderListViewModel() {
    _usecase = OrderUsecase(OrderRepository(dioClient));
    loadDataApi(true, false);
  }

  // ignore: avoid_positional_boolean_parameters
  void loadDataApi(bool isInit, bool isLoadMore) {
    if (isInit) {
      page = 0;
      showLoading(true);
    }
    _usecase
        .listOrder(page: page++, status: "distributed_to_customer")
        .then((value) {
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
        notifyListeners();
      }
    }).catchError(print);
  }
}
