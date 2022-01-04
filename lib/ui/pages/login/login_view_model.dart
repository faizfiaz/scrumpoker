// ignore_for_file: invalid_return_type_for_catch_error

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:scrumpoker/data/remote/endpoints/endpoints.dart';
import 'package:scrumpoker/domain/commons/base_view_model.dart';
import 'package:scrumpoker/domain/commons/email_validator.dart';
import 'package:scrumpoker/domain/models/entity/facebook_data.dart';
import 'package:scrumpoker/ui/pages/login/login_navigator.dart';

class LoginViewModel extends BaseViewModel<LoginNavigator> {
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();

  bool errorEmail = false;
  bool errorPassword = false;

  // late UserUsecase _usecase;

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _currentUser;
  FacebookData? data;

  LoginViewModel() {
    // _usecase = UserUsecase(UserRepository(dioClient));
    controllerEmail.addListener(checkValidEmail);
    controllerPassword.addListener(checkLengthPassword);

    _googleSignIn.onCurrentUserChanged.listen((account) {
      _currentUser = account;
      if (_currentUser != null) {
        _currentUser!.authentication.then((value) {
          doLoginThirdParty(
              _currentUser!.email, value.idToken, Endpoints.googleKey);
        });
      }
    });
  }

  void checkValidEmail() {
    errorEmail = !EmailValidator.validate(controllerEmail.text);
    notifyListeners();
  }

  void checkLengthPassword() {
    // ignore: avoid_bool_literals_in_conditional_expressions
    errorPassword = controllerPassword.text.length < 4 ? true : false;
    notifyListeners();
  }

  Future<void> doLogin() async {
    // showLoading(true);
    // await _usecase
    //     .login(controllerEmail.text.toLowerCase(), controllerPassword.text)
    //     .then((value) {
    //   showLoading(false);
    //   if (value.values.first != null) {
    //     getView()!.showError(
    //         value.values.first!.errors, value.values.first!.httpCode);
    //   } else {
    //     getView()!.showMainPage();
    //   }
    // }).catchError(print);
  }

  Future<void> handleSignInGoogle() async {
    try {
      await _googleSignIn.signOut();
      await _googleSignIn.signIn();
    } catch (error) {
      log(error.toString());
    }
  }

  Future<void> doLoginThirdParty(
      String? email, String? token, String type) async {
    // showLoading(true);
    // await _usecase
    //     .loginSocial(email: email, token: token, type: type)
    //     .then((value) {
    //   showLoading(false);
    //   if (value.values.first != null) {
    //     if (type == Endpoints.googleKey) {
    //       getView()!.showRegisterThirdParty(
    //           _currentUser!.email,
    //           _currentUser!.displayName,
    //           _currentUser!.photoUrl,
    //           Endpoints.googleKey);
    //     } else {
    //       getView()!.showRegisterThirdParty(data!.email, data!.name,
    //           data!.picture!.data!.url, Endpoints.facebookKey);
    //     }
    //   } else {
    //     if (type == Endpoints.facebookKey) {
    //     } else {
    //     }
    //     getView()!.showMainPage();
    //   }
    // }).catchError(print);
  }

  Future<void> handleSignInFacebook() async {
    final result = await FacebookAuth.instance
        .login(); // by default we request the email and the public profile
// or FacebookAuth.i.login()
    if (result.status == LoginStatus.success) {
      // you are logged
      final accessToken = result.accessToken!;
      await fetchUserData(accessToken);
    } else {
      log(result.status.toString());
      log(result.message.toString());
    }
  }

  Future<void> fetchUserData(AccessToken accessToken) async {
    showLoading(true);
    final token = accessToken.token;
    final graphResponse =
        await http.get(Uri.parse(Endpoints.facebookGraph + token));
    final profile = jsonDecode(graphResponse.body);
    data = FacebookData.fromJson(profile);
    if (data != null) {
      await doLoginThirdParty(data!.email, token, Endpoints.facebookKey);
    }
    showLoading(false);
  }
}
