// ignore_for_file: invalid_return_type_for_catch_error

import 'package:SuperNinja/domain/commons/base_view_model.dart';
import 'package:SuperNinja/domain/models/response/response_count_order.dart';
import 'package:SuperNinja/domain/models/response/response_profile.dart';
import 'package:SuperNinja/domain/repositories/order_repository.dart';
import 'package:SuperNinja/domain/repositories/user_repository.dart';
import 'package:SuperNinja/domain/usecases/order/order_usecase.dart';
import 'package:SuperNinja/domain/usecases/user/user_usecase.dart';
import 'package:SuperNinja/ui/pages/profile/profile_navigator.dart';

class ProfileViewModel extends BaseViewModel<ProfileNavigator> {
  late UserUsecase _usecase;
  late OrderUsecase _orderUsecase;
  Profile? profile;
  CountOrder? countOrder;

  ProfileViewModel() {
    showLoading(true);
    _usecase = UserUsecase(UserRepository(dioClient));
    _orderUsecase = OrderUsecase(OrderRepository(dioClient));
    loadDataAPI();
  }

  Future<void> getProfile() async {
    showLoading(true);
    notifyListeners();
    await _usecase.getProfile().then((value) {
      showLoading(false);
      if (value.values.first != null) {
        getView()!.showError(
            value.values.first!.errors, value.values.first!.httpCode);
      } else {
        profile = value.keys.first!.data;
      }
    }).catchError(print);
    notifyListeners();
  }

  void loadDataAPI() {
    _usecase.fetchUserData().then((value) {
      showLoading(false);
      profile = value;
      notifyListeners();
    });

    loadCountData();
  }

  void loadCountData() {
    _orderUsecase.getCountOrder().then((value) {
      showLoading(false);
      if (value.values.first != null) {
      } else {
        countOrder = value.keys.first!.data;
        notifyListeners();
      }
    }).catchError(print);
  }

  Future<void> changeStore(int id) async {
    showLoading(true);
    await _usecase.doChangeStore(id: id).then((value) {
      showLoading(false);
      if (value.values.first != null) {
        getView()!.showError(
            value.values.first!.errors, value.values.first!.httpCode);
      } else {
        getProfile();
      }
    }).catchError(print);
  }
}
