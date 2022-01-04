// ignore_for_file: always_declare_return_types, type_annotate_public_apis

import 'dart:developer';
import 'dart:io';

import 'package:SuperNinja/data/sharedpreference/user_preferences.dart';
import 'package:SuperNinja/domain/models/entity/no_content.dart';
import 'package:SuperNinja/domain/models/error/error_message.dart';
import 'package:SuperNinja/domain/models/response/response_count_notification.dart';
import 'package:SuperNinja/domain/models/response/response_forgot_password_check.dart';
import 'package:SuperNinja/domain/models/response/response_list_address.dart';
import 'package:SuperNinja/domain/models/response/response_list_notification.dart';
import 'package:SuperNinja/domain/models/response/response_login.dart';
import 'package:SuperNinja/domain/models/response/response_profile.dart';
import 'package:SuperNinja/domain/models/response/response_upload_file.dart';
import 'package:SuperNinja/domain/models/response/response_version.dart';
import 'package:SuperNinja/domain/repositories/user_repository.dart';
import 'package:smartech_flutter_plugin/smartech_plugin.dart';

import 'i_user_usecase.dart';

class UserUsecase extends IUserUsecase {
  final userSp = UserPreferences();

  UserUsecase(UserRepository repository) : super(repository);

  UserUsecase.empty() : super(null);

  @override
  Future<Map<ResponseLogin?, ErrorMessage?>> login(
      String email, String password) async {
    disposeVariable();
    ResponseLogin? responseLogin;
    final firebaseToken = await userSp.getFirebaseToken() ?? '';
    await repository
        ?.authenticate(
            email: email, password: password, firebaseToken: firebaseToken)
        .then((val) {
      responseLogin = val;
      userSp.setToken(responseLogin!.data!.token!);
    }).catchError((e) async {
      await mappingError(error, e).then((value) => error = value);
    });
    return Future.value({responseLogin: error});
  }

  Future<String> getFirebaseToken() async {
    final token = await userSp.getFirebaseToken() ?? '';
    if (token.isNotEmpty) {
      return token;
    }
    return "";
  }

  hasToken() async {
    final token = await userSp.getToken();
    if (token != null) {
      return true;
    }
    return false;
  }

  setAlreadySeenIntro() async {
    await userSp.setAlreadySeenIntro();
  }

  hasSeenIntro() async {
    return await userSp.hasSeenIntro();
  }

  setAlreadyLoginNetcore() async {
    await userSp.setAlreadyLoginNetcore();
  }

  hasLoginNetcore() async {
    return await userSp.hasLoginNetcore();
  }

  setCheckVersionPrompt() async {
    await userSp.setCheckVersionPrompt();
  }

  Future<int> getCheckVersionPrompt() async {
    return userSp.getCheckVersionPrompt();
  }

  @override
  Future<Profile?> fetchUserData() async {
    return userSp.getDataUser();
  }

  Future<bool> logout() async {
    return userSp.clearData();
  }

  @override
  Future<Map<ResponseLogin?, ErrorMessage?>> register(
      {Map<String, dynamic>? registerPayload}) async {
    disposeVariable();
    ResponseLogin? user;
    await repository?.register(registerPayload: registerPayload).then((val) {
      user = val;
      userSp.setToken(val.data!.token!);
    }).catchError((e) async {
      await mappingError(error, e).then((value) => error = value);
    });
    return Future.value({user: error});
  }

  @override
  Future<Map<ResponseLogin?, ErrorMessage?>> loginSocial(
      {String? email, String? token, String? type}) async {
    disposeVariable();
    ResponseLogin? responseLogin;
    final firebaseToken = await userSp.getFirebaseToken() ?? '';
    await repository
        ?.loginSocial(
            email: email,
            token: token,
            type: type,
            firebaseToken: firebaseToken)
        .then((val) {
      responseLogin = val;
      userSp.setToken(responseLogin!.data!.token!);
    }).catchError((e) async {
      await mappingError(error, e).then((value) => error = value);
    });
    return Future.value({responseLogin: error});
  }

  @override
  Future<Map<ResponseProfile?, ErrorMessage?>> getProfile() async {
    disposeVariable();
    ResponseProfile? responseProfile;
    await repository?.profile().then((val) async {
      responseProfile = val;
      await userSp.setDataUser(val.data!);
      // ignore: unawaited_futures
      SmartechPlugin().setUserIdentity(val.data!.id.toString());
      if (await hasLoginNetcore() == false) {
        // ignore: unawaited_futures
        SmartechPlugin().login(val.data!.id.toString());
        setAlreadyLoginNetcore();
      }
      final payload = {
        "name": responseProfile!.data!.name,
        "display_name": responseProfile!.data!.displayName,
        "email": responseProfile!.data!.email,
        "mobile": responseProfile!.data!.phoneNumber,
        "address": responseProfile!.data!.details!.address,
        "birthDate": responseProfile!.data!.details!.birthdate,
        "placeOfBirth": responseProfile!.data!.details!.placeOfBirth,
      };
      // ignore: unawaited_futures
      SmartechPlugin().updateUserProfile(payload);
    }).catchError((e) async {
      await mappingError(error, e).then((value) => error = value);
    });
    return Future.value({responseProfile: error});
  }

  @override
  Future<Map<ResponseUploadFile?, ErrorMessage?>> uploadFile(
      File image, String type) async {
    disposeVariable();
    ResponseUploadFile? responseUploadFile;
    await repository?.uploadFileImage(image, type).then((val) {
      responseUploadFile = val;
    }).catchError((e) async {
      await mappingError(error, e).then((value) => error = value);
    });
    return Future.value({responseUploadFile: error});
  }

  @override
  Future<Map<NoContent?, ErrorMessage?>> requestVerificationCode(
      {String? value, required String? registerVerificationMethod}) async {
    disposeVariable();
    NoContent? response;
    await repository
        ?.requestCodeVerification(
            value: value,
            registerVerificationMethod: registerVerificationMethod)
        .then((val) {
      response = val;
    }).catchError((e) async {
      log(e.toString());
      await mappingError(error, e).then((value) => error = value);
    });
    return Future.value({response: error});
  }

  @override
  Future<Map<NoContent?, ErrorMessage?>> changePassword(
      {Map<String, dynamic>? changePasswordPayload}) async {
    disposeVariable();
    NoContent? response;
    await repository
        ?.changePassword(changePasswordPayload: changePasswordPayload)
        .then((val) {
      response = val;
    }).catchError((e) async {
      await mappingError(error, e).then((value) => error = value);
    });
    return Future.value({response: error});
  }

  @override
  Future<Map<NoContent?, ErrorMessage?>> forgotPassword(
      {String? email, String? phoneNumber, String? type}) async {
    disposeVariable();
    NoContent? response;
    await repository
        ?.forgotPassword(email: email, phoneNumber: phoneNumber, type: type)
        .then((val) {
      response = val;
    }).catchError((e) async {
      await mappingError(error, e).then((value) => error = value);
    });
    return Future.value({response: error});
  }

  @override
  Future<Map<ResponseForgotPasswordCheck?, ErrorMessage?>> forgotPasswordCheck(
      {String? email,
      String? phoneNumber,
      String? type,
      String? requestCode}) async {
    disposeVariable();
    ResponseForgotPasswordCheck? response;
    await repository
        ?.forgotPasswordCheck(
            email: email,
            phoneNumber: phoneNumber,
            type: type,
            requestCode: requestCode)
        .then((val) {
      response = val;
    }).catchError((e) async {
      await mappingError(error, e).then((value) => error = value);
    });
    return Future.value({response: error});
  }

  @override
  Future<Map<NoContent?, ErrorMessage?>> newPassword(
      {String? identity, String? newPassword, String? codeId}) async {
    disposeVariable();
    NoContent? response;
    await repository
        ?.newPassword(
            identity: identity, newPassword: newPassword, codeId: codeId)
        .then((val) {
      response = val;
    }).catchError((e) async {
      await mappingError(error, e).then((value) => error = value);
    });
    return Future.value({response: error});
  }

  @override
  Future<Map<NoContent?, ErrorMessage?>> doChangeCL({int? userCLId}) async {
    disposeVariable();
    NoContent? response;
    await repository?.changeCL(userCLId: userCLId).then((val) {
      response = val;
    }).catchError((e) async {
      await mappingError(error, e).then((value) => error = value);
    });
    return Future.value({response: error});
  }

  @override
  Future<Map<NoContent?, ErrorMessage?>> doChangeProfile(
      {Map<String, dynamic>? changeProfilePayload}) async {
    disposeVariable();
    NoContent? response;
    await repository
        ?.changeProfile(changeProfilePayload: changeProfilePayload)
        .then((val) {
      response = val;
    }).catchError((e) async {
      await mappingError(error, e).then((value) => error = value);
    });
    return Future.value({response: error});
  }

  @override
  Future<Map<ResponseListNotification?, ErrorMessage?>> getListNotification(
      {int? page, int perPage = 20}) async {
    disposeVariable();
    ResponseListNotification? response;
    await repository
        ?.getListNotification(page: page, perPage: perPage)
        .then((val) {
      response = val;
    }).catchError((e) async {
      await mappingError(error, e).then((value) => error = value);
    });
    return Future.value({response: error});
  }

  @override
  Future<Map<NoContent?, ErrorMessage?>> doMarkAllNotification() async {
    disposeVariable();
    NoContent? response;
    await repository?.markAllNotification().then((val) {
      response = val;
    }).catchError((e) async {
      await mappingError(error, e).then((value) => error = value);
    });
    return Future.value({response: error});
  }

  @override
  Future<Map<NoContent?, ErrorMessage?>> doMarkNotification({int? id}) async {
    disposeVariable();
    NoContent? response;
    await repository?.markNotification(id).then((val) {
      response = val;
    }).catchError((e) async {
      await mappingError(error, e).then((value) => error = value);
    });
    return Future.value({response: error});
  }

  @override
  Future<Map<NoContent?, ErrorMessage?>> doLogout() async {
    disposeVariable();
    NoContent? response;
    await repository?.doLogout().then((val) {
      response = val;
    }).catchError((e) async {
      await mappingError(error, e).then((value) => error = value);
    });
    return Future.value({response: error});
  }

  @override
  Future<Map<ResponseCountNotification?, ErrorMessage?>>
      countUnreadNotification() async {
    disposeVariable();
    ResponseCountNotification? response;
    await repository?.countUnreadNotification().then((val) {
      response = val;
    }).catchError((e) async {
      await mappingError(error, e).then((value) => error = value);
    });
    return Future.value({response: error});
  }

  @override
  Future<Map<ResponseVersion?, ErrorMessage?>> checkVersion() async {
    disposeVariable();
    ResponseVersion? response;
    await repository?.checkVersion().then((val) {
      response = val;
    }).catchError((e) async {
      await mappingError(error, e).then((value) => error = value);
    });
    return Future.value({response: error});
  }

  @override
  Future<Map<NoContent?, ErrorMessage?>> doChangeStore(
      {required int id}) async {
    disposeVariable();
    NoContent? response;
    await repository?.doChangeStore(id).then((val) {
      response = val;
    }).catchError((e) async {
      await mappingError(error, e).then((value) => error = value);
    });
    return Future.value({response: error});
  }

  @override
  Future<Map<ResponseListAddress?, ErrorMessage?>> doGetListAddress() async {
    disposeVariable();
    ResponseListAddress? response;
    await repository?.doGetListAddress().then((val) {
      response = val;
    }).catchError((e) async {
      await mappingError(error, e).then((value) => error = value);
    });
    return Future.value({response: error});
  }

  @override
  Future<Map<NoContent?, ErrorMessage?>> doActionAddress(
      Map<String, dynamic>? value,
      {int? addressId}) async {
    disposeVariable();
    NoContent? response;
    await repository?.doActionAddress(value, addressId: addressId).then((val) {
      response = val;
    }).catchError((e) async {
      await mappingError(error, e).then((value) => error = value);
    });
    return Future.value({response: error});
  }
}
