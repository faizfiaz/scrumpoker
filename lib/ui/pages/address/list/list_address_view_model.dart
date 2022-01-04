// ignore_for_file: invalid_return_type_for_catch_error

import 'package:SuperNinja/domain/commons/base_view_model.dart';
import 'package:SuperNinja/domain/models/response/response_list_address.dart';
import 'package:SuperNinja/domain/repositories/user_repository.dart';
import 'package:SuperNinja/domain/usecases/user/user_usecase.dart';
import 'package:SuperNinja/ui/pages/address/list/list_address_navigator.dart';

class ListAddressViewModel extends BaseViewModel<ListAddressNavigator> {
  late UserUsecase _usecase;

  List<UserAddress> addresses = [];
  bool needRefresh = false;

  ListAddressViewModel() {
    _usecase = UserUsecase(UserRepository(dioClient));
    initData();
  }

  Future<void> initData() async {
    showLoading(true);
    await _usecase.doGetListAddress().then((value) {
      showLoading(false);
      if (value.values.first != null) {
        getView()!.showError(
            value.values.first!.errors, value.values.first!.httpCode);
      } else {
        addresses = value.keys.first!.data;
        addresses.sort((a, b) => a.isDefaultAddress == true
            ? -1
            : b.isDefaultAddress == true
                ? 1
                : 0);
        notifyListeners();
      }
    }).catchError(print);
  }

  Future<void> deleteAddress(int? id) async {
    await _usecase.doActionAddress(null, addressId: id!).then((value) {
      showLoading(false);
      if (value.values.first != null) {
        getView()!.showError(
            value.values.first!.errors, value.values.first!.httpCode);
      } else {
        initData();
        getView()!.showSuccess();
        needRefresh = true;
        notifyListeners();
      }
    }).catchError(print);
  }
}
