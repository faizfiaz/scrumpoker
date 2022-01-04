// ignore_for_file: invalid_return_type_for_catch_error

import 'package:SuperNinja/domain/commons/base_view_model.dart';
import 'package:SuperNinja/domain/commons/email_validator.dart';
import 'package:SuperNinja/domain/models/error/error_message.dart';
import 'package:SuperNinja/domain/repositories/user_repository.dart';
import 'package:SuperNinja/domain/usecases/user/user_usecase.dart';
import 'package:SuperNinja/ui/pages/forgotPassword/forgot_password_navigator.dart';
import 'package:SuperNinja/ui/widgets/multilanguage.dart';
import 'package:flutter/cupertino.dart';

class ForgotPasswordViewModel extends BaseViewModel<ForgotPasswordNavigator> {
  TextEditingController controllerIdentity = TextEditingController();
  TextEditingController controllerCode = TextEditingController();

  bool errorIdentity = false;
  bool errorCode = false;

  late UserUsecase _usecase;
  String email = "";
  String phoneNumber = "";
  String type = "phone";

  ForgotPasswordViewModel() {
    _usecase = UserUsecase(UserRepository(dioClient));
    controllerIdentity.addListener(checkValidIdentity);
    controllerCode.addListener(checkValidCode);
  }

  void checkValidIdentity() {
    if (controllerIdentity.text.startsWith("0") ||
        controllerIdentity.text.startsWith("62") ||
        controllerIdentity.text.startsWith("8")) {
      errorIdentity = controllerIdentity.text.length < 7;
    } else {
      errorIdentity = !EmailValidator.validate(controllerIdentity.text);
    }
    notifyListeners();
  }

  Future<void> doForgotPassword() async {
    if (!errorIdentity) {
      if (controllerIdentity.text.startsWith("0")) {
        phoneNumber = controllerIdentity.text.replaceFirst("0", "62");
      } else if (controllerIdentity.text.startsWith("8")) {
        phoneNumber = "62${controllerIdentity.text}";
      } else if (controllerIdentity.text.startsWith("62")) {
        phoneNumber = controllerIdentity.text;
      } else {
        email = controllerIdentity.text;
        type = "email";
      }
      showLoading(true);
      await _usecase
          .forgotPassword(email: email, phoneNumber: phoneNumber, type: type)
          .then((value) {
        showLoading(false);
        if (value.values.first != null) {
          getView()!.showError(
              value.values.first!.errors, value.values.first!.httpCode);
        } else {
          getView()!.showInputCode(type == "email");
        }
      }).catchError(print);
    }
  }

  Future<void> doSubmitCode() async {
    if (!errorCode) {
      showLoading(true);
      notifyListeners();
      await _usecase
          .forgotPasswordCheck(
              email: email,
              phoneNumber: phoneNumber,
              type: type,
              requestCode: controllerCode.text)
          .then((value) {
        showLoading(false);
        if (value.values.first != null) {
          getView()!.showError(
              value.values.first!.errors, value.values.first!.httpCode);
        } else {
          if (value.keys.first != null && value.keys.first!.data != null) {
            var identity = "";
            if (type == "email") {
              identity = email;
            } else {
              identity = phoneNumber;
            }
            getView()!
                .showRecoveryPage(identity, value.keys.first!.data!.codeId);
          } else {
            getView()!.showError([Errors(error: txt("wrong_code"))], 0);
          }
        }
      }).catchError(print);
    }
  }

  void checkValidCode() {
    errorCode = controllerCode.text.length <= 5;
    notifyListeners();
  }
}
