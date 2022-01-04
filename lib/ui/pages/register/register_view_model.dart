// ignore_for_file: invalid_return_type_for_catch_error, avoid_positional_boolean_parameters

import 'dart:collection';
import 'dart:convert';

import 'package:SuperNinja/data/remote/endpoints/endpoints.dart';
import 'package:SuperNinja/domain/commons/base_view_model.dart';
import 'package:SuperNinja/domain/commons/other_utils.dart';
import 'package:SuperNinja/domain/commons/tracking_utils.dart';
import 'package:SuperNinja/domain/models/entity/city.dart';
import 'package:SuperNinja/domain/models/entity/community_leader.dart';
import 'package:SuperNinja/domain/models/entity/province.dart';
import 'package:SuperNinja/domain/repositories/user_repository.dart';
import 'package:SuperNinja/domain/usecases/user/user_usecase.dart';
import 'package:SuperNinja/ui/pages/register/register_navigator.dart';
import 'package:http/http.dart' as http;
import 'package:smartech_flutter_plugin/smartech_plugin.dart';

enum typeUser { buyer, seller }

class RegisterViewModel extends BaseViewModel<RegisterNavigator> {
  Province? provinceSelected;
  City? citySelected;
  late CommunityLeader communityLeaderSelected;
  late UserUsecase _usecase;

  double latitude = 0;
  double longitude = 0;

  static const String typeProfilePicture = "profile_pictures";
  static const String typeKtp = "ktp";
  static const String typeSelfie = "selfie";
  static const String typeNpwp = "npwp";

  bool alreadySentCode = false;

  String? methodSelected;
  String? registerVia;

  RegisterViewModel(this.registerVia) {
    _usecase = UserUsecase(UserRepository(dioClient));
  }

  Future<void> doRegister(Map<String, dynamic> value) async {
    // value['user_cl_id'] = communityLeaderSelected.id;
    // value['birthdate'] = value['birthdate'].toString().substring(0, 10);
    value['phone_number'] =
        value['phone_number'].toString().replaceAll("+", "");
    value.addAll({"register_verification_method": methodSelected});

    print(jsonEncode(value, toEncodable: OtherUtils.myEncode));
    // var img64 = "";
    // if ((value['profile_picture'] as List).isNotEmpty) {
    //   if (value['profile_picture'][0] is File) {
    //     final pathFile = (value['profile_picture'][0] as File).path;
    //     final bytes = File(pathFile).readAsBytesSync();
    //     img64 = base64Encode(bytes);
    //   } else if (value['profile_picture'][0] is String) {
    //     img64 =
    //         await networkImageToBase64(value['profile_picture'][0] as String);
    //   }
    //   value['profile_picture'] = "data:image/png;base64,$img64";
    // } else {
    //   value['profile_picture'] = null;
    // }

    await _usecase.getFirebaseToken().then((token) => {
          value.addAll({"firebase_token": token})
        });
    value.addAll({"latitude": latitude, "longitude": longitude});
    showLoading(true);
    await _usecase.register(registerPayload: value).then((response) {
      showLoading(false);
      if (response.values.first != null) {
        getView()!.showError(
            response.values.first!.errors, response.values.first!.httpCode);
      } else {
        /*Tracking Event*/

        if (registerVia == Endpoints.googleKey) {
          final payload = {
            "name": value['name'],
            "mobile": value['phone_number'],
            "email": value['email'],
            // "dob": value['birthdate']
          };
          SmartechPlugin()
              .trackEvent(TrackingUtils.SIGNUP_SUBMIT_GOOGLE, payload);
        } else if (registerVia == Endpoints.facebookKey) {
          final payload = {
            "name": value['name'],
            "mobile": value['phone_number'],
            "email": value['email'],
            // "dob": value['birthdate']
          };
          SmartechPlugin()
              .trackEvent(TrackingUtils.SIGNUP_SUBMIT_FACEBOOK, payload);
        } else {
          final payloadData = HashMap<String, Object?>();
          payloadData["name"] = value['name'];
          payloadData["mobile"] = value['phone_number'];

          final payload = {
            "name": value['name'],
            "mobile": value['phone_number']
          };

          if (methodSelected == "sms") {
            SmartechPlugin()
                .trackEvent(TrackingUtils.SIGNUP_SUBMIT_OTP, payload);
          } else {
            SmartechPlugin()
                .trackEvent(TrackingUtils.SIGNUP_SUBMIT_EMAIL, payload);
          }
        }
        getView()!.showMainPage();
      }
    }).catchError(print);
  }

  Future<void> requestCodeVerification(
      String? value, bool isMethodEmail) async {
    alreadySentCode = false;
    var realValue = value;
    if (!isMethodEmail) {
      realValue = value!.replaceAll("+", "");
    }
    showLoading(true);
    methodSelected = isMethodEmail ? "email" : "wa";
    notifyListeners();
    await _usecase
        .requestVerificationCode(
            value: realValue, registerVerificationMethod: methodSelected)
        .then((value) {
      showLoading(false);
      if (value.values.first != null) {
        getView()!.showError(
            value.values.first!.errors, value.values.first!.httpCode);
      } else {
        alreadySentCode = true;
        getView()!.showSuccessSentCode(isMethodEmail);
        notifyListeners();
      }
    }).catchError(print);
  }

  Future<String> networkImageToBase64(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));
    final bytes = response.bodyBytes;
    // ignore: unnecessary_null_comparison
    return bytes != null ? base64Encode(bytes) : "";
  }
}
