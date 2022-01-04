// ignore_for_file: invalid_return_type_for_catch_error

import 'dart:convert';

import 'package:SuperNinja/domain/commons/base_view_model.dart';
import 'package:SuperNinja/domain/commons/other_utils.dart';
import 'package:SuperNinja/domain/repositories/user_repository.dart';
import 'package:SuperNinja/domain/usecases/user/user_usecase.dart';
import 'package:SuperNinja/ui/pages/changePassword/change_register_navigator.dart';
import 'package:flutter/cupertino.dart';

class ChangePasswordViewModel extends BaseViewModel<ChangePasswordNavigator> {
  TextEditingController controllerPassword = TextEditingController();
  TextEditingController controllerNewPassword = TextEditingController();

  late UserUsecase _usecase;

  bool isNotStrongPassword = false;

  ChangePasswordViewModel() {
    _usecase = UserUsecase(UserRepository(dioClient));

    controllerPassword.addListener(() {
      checkPassword(controllerPassword.text);
    });

    controllerNewPassword.addListener(notifyListeners);
  }

  Future<void> doChangePassword(Map<String, dynamic> value) async {
    showLoading(true);
    notifyListeners();
    print(jsonEncode(value, toEncodable: OtherUtils.myEncode));
    await _usecase.changePassword(changePasswordPayload: value).then((value) {
      showLoading(false);
      if (value.values.first != null) {
        getView()!.showError(
            value.values.first!.errors, value.values.first!.httpCode);
      } else {
        getView()!.successChangePassword();
      }
    }).catchError(print);
  }

  void checkPassword(String text) {
    final exp = RegExp(OtherUtils.getRegexPassword());
    exp.allMatches(text);

    isNotStrongPassword = !exp.hasMatch(text);
    print(exp.hasMatch(text));
    notifyListeners();
  }
}
