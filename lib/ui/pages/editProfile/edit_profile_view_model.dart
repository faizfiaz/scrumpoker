// ignore_for_file: invalid_return_type_for_catch_error

import 'dart:convert';
import 'dart:io';

import 'package:SuperNinja/domain/commons/base_view_model.dart';
import 'package:SuperNinja/domain/commons/other_utils.dart';
import 'package:SuperNinja/domain/repositories/user_repository.dart';
import 'package:SuperNinja/domain/usecases/user/user_usecase.dart';
import 'package:SuperNinja/ui/pages/editProfile/edit_profile_navigator.dart';
import 'package:http/http.dart' as http;

class EditProfileViewModel extends BaseViewModel<EditProfileNavigator> {
  late UserUsecase _usecase;

  EditProfileViewModel() {
    _usecase = UserUsecase(UserRepository(dioClient));
  }

  Future<void> doEdit(Map<String, dynamic> value) async {
    showLoading(true);
    value['birthdate'] = value['birthdate'].toString().substring(0, 10);
    value['phone_number'] =
        value['phone_number'].toString().replaceAll("+", "");
    print(jsonEncode(value, toEncodable: OtherUtils.myEncode));
    var img64 = "";
    if (value['profile_picture'].length > 0) {
      if (value['profile_picture'][0] is File) {
        final pathFile = (value['profile_picture'][0] as File).path;
        final bytes = File(pathFile).readAsBytesSync();
        img64 = base64Encode(bytes);
      } else if (value['profile_picture'][0] is String) {
        img64 =
            await networkImageToBase64(value['profile_picture'][0] as String);
      }
      value['profile_picture'] = "data:image/png;base64,$img64";
    } else {
      value['profile_picture'] = null;
    }
    await _usecase.doChangeProfile(changeProfilePayload: value).then((value) {
      showLoading(false);
      if (value.values.first != null) {
        getView()!.showError(
            value.values.first!.errors, value.values.first!.httpCode);
      } else {
        getView()!.successEditProfile();
      }
    }).catchError(print);
  }

  Future<String> networkImageToBase64(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));
    final bytes = response.bodyBytes;
    // ignore: unnecessary_null_comparison
    return bytes != null ? base64Encode(bytes) : "";
  }

  String getPhoneNumber(String? phoneNumber) {
    // ignore: unnecessary_null_comparison
    if (phoneNumber != null) {
      if (phoneNumber.startsWith("62")) {
        return phoneNumber.replaceFirst("62", "");
      } else if (phoneNumber.startsWith("0")) {
        return phoneNumber.replaceFirst("0", "");
      } else {
        return phoneNumber;
      }
    } else {
      return "";
    }
  }
}
