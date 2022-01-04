import 'package:SuperNinja/domain/commons/base_view_model.dart';
import 'package:SuperNinja/domain/commons/other_utils.dart';
import 'package:SuperNinja/domain/repositories/user_repository.dart';
import 'package:SuperNinja/domain/usecases/user/user_usecase.dart';
import 'package:SuperNinja/ui/pages/recovery/recovery_navigator.dart';
import 'package:flutter/material.dart';

class RecoveryViewModel extends BaseViewModel<RecoveryNavigator> {
  TextEditingController controllerPassword = TextEditingController();
  TextEditingController controllerConfirmPassword = TextEditingController();

  bool errorPassword = false;
  bool errorConfirmPassword = false;

  late UserUsecase _usecase;
  String? identity;
  int? codeId;
  bool isNotStrongPassword = false;

  RecoveryViewModel(this.identity, this.codeId) {
    _usecase = UserUsecase(UserRepository(dioClient));
    controllerPassword.addListener(checkLengthPassword);
    controllerConfirmPassword.addListener(checkConfirmPassword);
  }

  void checkLengthPassword() {
    checkPassword(controllerPassword.text);
  }

  void checkConfirmPassword() {
    errorConfirmPassword =
        controllerConfirmPassword.text != controllerPassword.text;
    notifyListeners();
  }

  Future<void> doNewPassword() async {
    if (!errorPassword && !errorConfirmPassword) {
      showLoading(true);
      await _usecase
          .newPassword(
              identity: identity,
              newPassword: controllerPassword.text,
              codeId: codeId.toString())
          .then((value) {
        showLoading(false);
        if (value.values.first != null) {
          getView()!.showError(
              value.values.first!.errors, value.values.first!.httpCode);
        } else {
          getView()!.showLoginPage();
        }
        // ignore: invalid_return_type_for_catch_error
      }).catchError(print);
    }
  }

  void checkPassword(String text) {
    final exp = RegExp(OtherUtils.getRegexPassword());
    // ignore: unused_local_variable
    final Iterable<Match> matches = exp.allMatches(text);

    isNotStrongPassword = !exp.hasMatch(text);
    notifyListeners();
  }
}
