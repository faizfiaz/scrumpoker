import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:scrumpoker/data/remote/endpoints/endpoints.dart';

class UserEndpoint {
  UserEndpoint._();

  static String urlLogin = '${Endpoints().baseUrl!}/v1/users/login';
  static String urlLogout = '${Endpoints().baseUrl!}/v1/users/logout';
  static String urlLoginSocial =
      '${Endpoints().baseUrl!}/v1/users/login-social';
  static String urlRequestVerificationCode =
      '${Endpoints().baseUrl!}/v1/users/request-register-verification';
  static String urlRegister =
      '${Endpoints().baseUrl!}/v1/users/register-customer';
  static String urlChangePassword =
      '${Endpoints().baseUrl!}/v1/users/change-password';
  static String urlProfile = '${Endpoints().baseUrl!}/v1/users/profile';
  static String urlUploadFile = '${Endpoints().baseUrl!}/v1/upload-files';
  static String urlForgotPassword =
      '${Endpoints().baseUrl!}/v1/users/forgot-password';
  static String urlForgotPasswordCheck =
      '${Endpoints().baseUrl!}/v1/users/check-forgot-password';
  static String urlNewPassword =
      '${Endpoints().baseUrl!}/v1/users/new-password';
  static String urlChangeCL = '${Endpoints().baseUrl!}/v1/users/change-cl';
  static String urlChangeProfile =
      '${Endpoints().baseUrl!}/v1/users/update-profile-customer';
  static String urlMarkAllNotification =
      '${Endpoints().baseUrl!}/v1/notifications/mark-all-as-read';
  static String urlCountlNotification =
      '${Endpoints().baseUrl!}/v1/notifications/count-unread';
  static String urlAddress = '${Endpoints().baseUrl!}/v1/user-addresses';

  static String? versionCode = Platform.isAndroid
      ? dotenv.env['VERSION_CODE_ANDROID']
      : dotenv.env['VERSION_CODE_IOS'];

  static String urlCheckVersion =
      '${Endpoints().baseUrl!}/v1/app-versions/check?version_code=$versionCode&isAndroid=${Platform.isAndroid.toString()}';

  static String urlMarkNotification(int? id) {
    return '${Endpoints().baseUrl!}/v1/notifications/detail/${id.toString()}/mark-as-read';
  }

  static String urlGetNotification(int? page, {int? perPage}) {
    return '${Endpoints().baseUrl!}/v1/notifications?page=$page&per_page=$perPage';
  }

  static String urlChangeStore() {
    return '${Endpoints().baseUrl!}/v1/users/change-store';
  }
}
