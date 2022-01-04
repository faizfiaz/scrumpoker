import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:scrumpoker/data/remote/dio_client.dart';
import 'package:scrumpoker/data/remote/endpoints/user_endpoints.dart';
import 'package:scrumpoker/domain/models/entity/no_content.dart';
import 'package:scrumpoker/domain/models/response/response_count_notification.dart';
import 'package:scrumpoker/domain/models/response/response_forgot_password_check.dart';
import 'package:scrumpoker/domain/models/response/response_list_address.dart';
import 'package:scrumpoker/domain/models/response/response_list_notification.dart';
import 'package:scrumpoker/domain/models/response/response_login.dart';
import 'package:scrumpoker/domain/models/response/response_profile.dart';
import 'package:scrumpoker/domain/models/response/response_upload_file.dart';
import 'package:scrumpoker/domain/models/response/response_version.dart';

import 'base_repository.dart';

class UserRepository extends BaseRepository {
  UserRepository(DioClient? dioClient) : super(dioClient);

  dynamic data;

  Future<ResponseLogin> authenticate(
      {required String email,
      required String password,
      required String firebaseToken}) async {
    await dioClient!.post(UserEndpoint.urlLogin, data: {
      "identity": email,
      "password": password,
      "firebase_token": firebaseToken
    }).then((value) {
      data = value;
    });
    return ResponseLogin.fromJson(data);
  }

  Future<NoContent> requestCodeVerification(
      {String? value, required String? registerVerificationMethod}) async {
    var datas = {};
    if (registerVerificationMethod == "wa") {
      datas = {
        "phone_number": value,
        "register_verification_method": registerVerificationMethod
      };
    } else {
      datas = {
        "email": value,
        "register_verification_method": registerVerificationMethod
      };
    }
    await dioClient!
        .post(UserEndpoint.urlRequestVerificationCode, data: datas)
        .then((value) {
      data = value;
    });
    return NoContent();
  }

  Future<ResponseLogin> loginSocial(
      {required String? email,
      required String? token,
      required String? type,
      required String firebaseToken}) async {
    final options = Options();
    await dioClient!
        .post(UserEndpoint.urlLoginSocial,
            data: {
              "email": email,
              "token": token,
              "type": type,
              "firebase_token": firebaseToken
            },
            options: options)
        .then((value) {
      data = value;
    });
    return ResponseLogin.fromJson(data);
  }

  Future<ResponseLogin> register(
      {required Map<String, dynamic>? registerPayload}) async {
    await dioClient!
        .post(UserEndpoint.urlRegister,
            data: jsonEncode(registerPayload, toEncodable: myEncode))
        .then((value) {
      data = value;
    });
    return ResponseLogin.fromJson(data);
  }

  dynamic myEncode(dynamic item) {
    if (item is DateTime) {
      return item.toIso8601String();
    }
    if (item is File) {
      return "";
    }
    return item;
  }

  Future<ResponseProfile> profile() async {
    await dioClient!.get(UserEndpoint.urlProfile).then((value) {
      data = value;
    });
    return ResponseProfile.fromJson(data);
  }

  Future<NoContent> changePassword(
      {Map<String, dynamic>? changePasswordPayload}) async {
    await dioClient!
        .put(UserEndpoint.urlChangePassword, data: changePasswordPayload)
        .then((value) {
      data = value;
    });
    return NoContent();
  }

  Future<ResponseUploadFile> uploadFileImage(File image, String type) async {
    final formData = FormData.fromMap({
      "type": type,
      "file": await MultipartFile.fromFile(image.path),
    });
    await dioClient!
        .post(UserEndpoint.urlUploadFile, data: formData)
        .then((value) {
      data = value;
    });
    return ResponseUploadFile.fromJson(data);
  }

  Future<void> deleteToken() async {
    await Future.delayed(const Duration(seconds: 1));
    return;
  }

  Future<void> persistToken(String token) async {
    await Future.delayed(const Duration(seconds: 1));
    return;
  }

  Future<bool> hasToken() async {
    await Future.delayed(const Duration(seconds: 1));
    return false;
  }

  Future<NoContent> forgotPassword(
      {required String? email,
      required String? phoneNumber,
      required String? type}) async {
    await dioClient!.post(UserEndpoint.urlForgotPassword, data: {
      "email": email,
      "phone_number": phoneNumber,
      "type": type
    }).then((value) {
      data = value;
    });
    return NoContent();
  }

  Future<ResponseForgotPasswordCheck> forgotPasswordCheck(
      {required String? email,
      required String? phoneNumber,
      required String? type,
      required String? requestCode}) async {
    await dioClient!.post(UserEndpoint.urlForgotPasswordCheck, data: {
      "email": email,
      "phone_number": phoneNumber,
      "type": type,
      "request_code": requestCode,
    }).then((value) {
      data = value;
    });
    if (data.toString().isEmpty) {
      return ResponseForgotPasswordCheck();
    }
    return ResponseForgotPasswordCheck.fromJson(data);
  }

  Future<NoContent> newPassword(
      {required String? identity,
      required String? newPassword,
      required String? codeId}) async {
    await dioClient!.post(UserEndpoint.urlNewPassword, data: {
      "identity": identity,
      "new_password": newPassword,
      "code_id": codeId
    }).then((value) {
      data = value;
    });
    return NoContent();
  }

  Future<NoContent> changeCL({required int? userCLId}) async {
    await dioClient!.put(UserEndpoint.urlChangeCL,
        data: {"user_cl_id": userCLId}).then((value) {
      data = value;
    });
    return NoContent();
  }

  Future<NoContent> changeProfile(
      {required Map<String, dynamic>? changeProfilePayload}) async {
    await dioClient!
        .put(UserEndpoint.urlChangeProfile,
            data: jsonEncode(changeProfilePayload, toEncodable: myEncode))
        .then((value) {
      data = value;
    });
    return NoContent();
  }

  Future<NoContent> markAllNotification() async {
    await dioClient!.put(UserEndpoint.urlMarkAllNotification).then((value) {
      data = value;
    });
    return NoContent();
  }

  Future<NoContent> markNotification(int? id) async {
    await dioClient!.put(UserEndpoint.urlMarkNotification(id)).then((value) {
      data = value;
    });
    return NoContent();
  }

  Future<ResponseListNotification> getListNotification(
      {required int? page, int? perPage}) async {
    await dioClient!
        .get(
      UserEndpoint.urlGetNotification(page, perPage: perPage),
    )
        .then((value) {
      data = value;
    });
    return ResponseListNotification.fromJson(data);
  }

  Future<NoContent> doLogout() async {
    await dioClient!.put(UserEndpoint.urlLogout).then((value) {
      data = value;
    });
    return NoContent();
  }

  Future<ResponseCountNotification> countUnreadNotification() async {
    await dioClient!
        .get(
      UserEndpoint.urlCountlNotification,
    )
        .then((value) {
      data = value;
    });
    return ResponseCountNotification.fromJson(data);
  }

  Future<ResponseVersion> checkVersion() async {
    await dioClient!
        .getInner(
      UserEndpoint.urlCheckVersion,
    )
        .then((value) {
      data = value;
    });
    return ResponseVersion.fromJson(data);
  }

  Future<NoContent> doChangeStore(int? id) async {
    await dioClient!.put(UserEndpoint.urlChangeStore(), data: {
      "store_id": id,
    }).then((value) {
      data = value;
    });
    return NoContent();
  }

  Future<ResponseListAddress> doGetListAddress() async {
    await dioClient!
        .get(
      UserEndpoint.urlAddress,
    )
        .then((value) {
      data = value;
    });
    return ResponseListAddress.fromJson(data);
  }

  Future<NoContent> doActionAddress(Map<String, dynamic>? bodyData,
      {int? addressId}) async {
    if (addressId != null) {
      //addressId exist && bodyData exists
      if (bodyData != null) {
        await dioClient!
            .put("${UserEndpoint.urlAddress}/$addressId", data: bodyData)
            .then((value) {
          data = value;
        });
      } else {
        await dioClient!
            .delete("${UserEndpoint.urlAddress}/$addressId")
            .then((value) {
          data = value;
        });
      }
      return NoContent();
    } else {
      //addressId not exist && bodyData exists
      await dioClient!
          .post(
        UserEndpoint.urlAddress,
        data: bodyData,
      )
          .then((value) {
        data = value;
      });
      return NoContent();
    }
  }
}
