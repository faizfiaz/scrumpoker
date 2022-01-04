import 'dart:io';

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

import '../base_usecase.dart';

abstract class IUserUsecase extends BaseUsecase<UserRepository?> {
  IUserUsecase(UserRepository? repository) : super(repository);

  Future<Map<ResponseLogin?, ErrorMessage?>> login(
      String email, String password);

  Future<Map<NoContent?, ErrorMessage?>> requestVerificationCode(
      {String? value, required String registerVerificationMethod});

  Future<Map<ResponseLogin?, ErrorMessage?>> loginSocial(
      {String? email, String? token, String? type});

  Future<Map<ResponseLogin?, ErrorMessage?>> register(
      {Map<String, dynamic>? registerPayload});

  Future<Profile?> fetchUserData();

  Future<Map<ResponseUploadFile?, ErrorMessage?>> uploadFile(
      File image, String type);

  Future<Map<ResponseProfile?, ErrorMessage?>> getProfile();

  Future<Map<NoContent?, ErrorMessage?>> changePassword(
      {Map<String, dynamic>? changePasswordPayload});

  Future<Map<ResponseForgotPasswordCheck?, ErrorMessage?>> forgotPasswordCheck(
      {required String email,
      required String phoneNumber,
      required String type,
      required String requestCode});

  Future<Map<NoContent?, ErrorMessage?>> forgotPassword(
      {required String email,
      required String phoneNumber,
      required String type});

  Future<Map<NoContent?, ErrorMessage?>> newPassword(
      {required String identity,
      required String newPassword,
      required String codeId});

  Future<Map<NoContent?, ErrorMessage?>> doChangeCL({required int userCLId});

  Future<Map<NoContent?, ErrorMessage?>> doChangeProfile(
      {required Map<String, dynamic> changeProfilePayload});

  Future<Map<ResponseListNotification?, ErrorMessage?>> getListNotification(
      {required int page});

  Future<Map<NoContent?, ErrorMessage?>> doMarkAllNotification();

  Future<Map<NoContent?, ErrorMessage?>> doMarkNotification({required int id});

  Future<Map<NoContent?, ErrorMessage?>> doLogout();

  Future<Map<ResponseCountNotification?, ErrorMessage?>>
      countUnreadNotification();

  Future<Map<ResponseVersion?, ErrorMessage?>> checkVersion();

  Future<Map<NoContent?, ErrorMessage?>> doChangeStore({required int id});

  Future<Map<ResponseListAddress?, ErrorMessage?>> doGetListAddress();

  Future<Map<NoContent?, ErrorMessage?>> doActionAddress(
      Map<String, dynamic>? value,
      {int? addressId});
}
