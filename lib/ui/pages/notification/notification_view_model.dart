// ignore_for_file: invalid_return_type_for_catch_error

import 'package:SuperNinja/domain/commons/base_view_model.dart';
import 'package:SuperNinja/domain/commons/other_utils.dart';
import 'package:SuperNinja/domain/models/entity/notifications.dart';
import 'package:SuperNinja/domain/models/response/response_list_notification.dart';
import 'package:SuperNinja/domain/repositories/user_repository.dart';
import 'package:SuperNinja/domain/usecases/user/user_usecase.dart';
import 'package:SuperNinja/ui/pages/notification/notification_navigator.dart';

class NotificationViewModel extends BaseViewModel<NotificationNavigator> {
  late UserUsecase _usecase;

  int currentPage = 1;

  DataNotification? dataNotification;
  List<Notifications> data = [];
  int? totalPage = 0;

  NotificationViewModel() {
    _usecase = UserUsecase(UserRepository(dioClient));
    getData(true, false);
  }

  // ignore: avoid_positional_boolean_parameters
  Future<void> getData(bool isInit, bool isLoadMore) async {
    if (!isLoadMore) {
      currentPage = 1;
      showLoading(true);
    } else {
      ++currentPage;
    }
    await _usecase.getListNotification(page: currentPage).then((value) {
      showLoading(false);
      if (value.values.first != null) {
        getView()!.showError(
            value.values.first!.errors, value.values.first!.httpCode);
      } else {
        dataNotification = value.keys.first!.data;
        if (!isLoadMore) {
          data.clear();
        }
        data.addAll(dataNotification!.data!);
        totalPage = dataNotification!.totalPage;
        notifyListeners();
      }
    }).catchError(print);
    notifyListeners();
  }

  String getMessage(String message) {
    final text = message.split(" ");
    return text[3];
  }

  String translateStatus(String notificationType) {
    return " ${OtherUtils.translateStatusOrderNotification(notificationType.replaceFirst("order_", ""))!}";
  }

  Future<void> readNotification(Notifications data) async {
    await _usecase.doMarkNotification(id: data.id).then((value) {
      showLoading(false);
      if (value.values.first != null) {
        getView()!.showError(
            value.values.first!.errors, value.values.first!.httpCode);
      } else {
        this.data[this.data.indexOf(data)].isRead = true;
        notifyListeners();
      }
    }).catchError(print);
    if (data.referenceType ==
        NotificationReferenceType.order.toString().split('.').last) {
      getView()!.showOrderDetail(data.referenceId);
    }
  }

  Future<void> markAllNotification() async {
    await _usecase.doMarkAllNotification().then((value) {
      showLoading(false);
      if (value.values.first != null) {
        getView()!.showError(
            value.values.first!.errors, value.values.first!.httpCode);
      } else {
        getData(true, false);
      }
    }).catchError(print);
  }
}
