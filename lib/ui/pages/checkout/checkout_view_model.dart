// ignore_for_file: invalid_return_type_for_catch_error

import 'package:SuperNinja/domain/commons/base_view_model.dart';
import 'package:SuperNinja/domain/models/response/response_checkout.dart';
import 'package:SuperNinja/domain/models/response/response_list_address.dart';
import 'package:SuperNinja/domain/models/response/response_profile.dart';
import 'package:SuperNinja/domain/repositories/order_repository.dart';
import 'package:SuperNinja/domain/repositories/user_repository.dart';
import 'package:SuperNinja/domain/usecases/order/order_usecase.dart';
import 'package:SuperNinja/domain/usecases/user/user_usecase.dart';
import 'package:SuperNinja/ui/widgets/multilanguage.dart';
import 'package:flutter/cupertino.dart';

import 'checkout_navigator.dart';

class CheckoutViewModel extends BaseViewModel<CheckoutNavigator> {
  TextEditingController controllerNotes = TextEditingController();
  TextEditingController controllerVoucher = TextEditingController();

  Checkout? checkout;
  int? cartId;
  List<int?>? products;

  late OrderUsecase _usecase;
  late UserUsecase _userUsecase;

  bool voucherFailed = false;
  bool voucherRemoved = false;

  String notes = "";
  String? errorVoucherValidation;

  Profile? profile;
  List<UserAddress> addresses = [];
  UserAddress? selectedAddress;

  CheckoutViewModel(this.checkout, this.cartId, this.products) {
    _usecase = OrderUsecase(OrderRepository(dioClient));
    _userUsecase = UserUsecase(UserRepository(dioClient));
    loadDataProfile();
    loadDataAddress();

    controllerNotes.addListener(() {
      checkout!.notes = controllerNotes.text;
      notes = controllerNotes.text;
    });
  }

  Future<void> loadDataAddress() async {
    showLoading(true);
    await _userUsecase.doGetListAddress().then((value) {
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
        if (addresses.isNotEmpty) {
          selectedAddress = addresses.first;
        } else {
          selectedAddress = null;
        }

        notifyListeners();
      }
    }).catchError(print);
  }

  void loadDataProfile() {
    _userUsecase.fetchUserData().then((value) {
      showLoading(false);
      profile = value;
      notifyListeners();
    });
  }

  // ignore: avoid_positional_boolean_parameters
  void applyVoucher(bool isRemoveVoucher) {
    if (profile!.details!.identityNumber == null) {
      getView()!.showNeedIdentity();
      return;
    }
    voucherRemoved = isRemoveVoucher;
    showLoading(true);
    _usecase
        .doCheckout(
            cartId: cartId,
            products: products,
            voucherCode: isRemoveVoucher ? "null" : controllerVoucher.text)
        .then((value) {
      showLoading(false);
      if (value.values.first != null) {
      } else {
        checkout = value.keys.first!.data;
        if (notes.isNotEmpty) {
          checkout!.notes = notes;
        }
        if (checkout!.voucherDetail!.voucher == null) {
          voucherFailed = true;
          errorVoucherValidation = checkout!.voucherDetail!.errValidation;
        } else {
          voucherFailed = false;
        }
        view!.getPotentialDiscount();
        notifyListeners();
      }
    }).catchError(print);
  }

  String? getTextErrorVoucher() {
    if (errorVoucherValidation != null) {
      if (errorVoucherValidation!.contains("not found")) {
        return txt("voucher_not_found");
      } else if (errorVoucherValidation!.contains("out of stock")) {
        return txt("voucher_not_found");
      } else if (errorVoucherValidation!.contains("already max used")) {
        return txt("voucher_used_max");
      } else if (errorVoucherValidation!.contains("already used")) {
        return txt("voucher_used");
      }
    }
    return txt("voucher_not_found");
  }

  Future<void> loadDataProfileAPI() async {
    await _userUsecase.getProfile().then((value) async {
      if (value.values.first != null) {
        getView()!.showError(
            value.values.first!.errors, value.values.first!.httpCode);
      } else {
        profile = value.keys.first!.data;
        notifyListeners();
      }
    }).catchError(print);
  }

  bool checkAddress() {
    if (selectedAddress == null) {
      getView()!.showError(txt("address_not_selected"), 400);
      return false;
    } else {
      if (selectedAddress!.provinceId == null ||
          selectedAddress!.cityId == null ||
          selectedAddress!.latitude == null ||
          selectedAddress!.longitude == null) {
        getView()!.showAddressNotComplete();
        return false;
      } else {
        return true;
      }
    }
  }
}
