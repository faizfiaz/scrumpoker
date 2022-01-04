import 'package:SuperNinja/domain/models/entity/city.dart';
import 'package:SuperNinja/domain/models/entity/province.dart';
import 'package:SuperNinja/domain/models/entity/user_cl.dart';

import 'response_list_store.dart';

class ResponseProfile {
  Profile? data;
  dynamic meta;

  ResponseProfile({this.data, this.meta});

  ResponseProfile.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Profile.fromJson(json['data']) : null;
    meta = json['meta'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['meta'] = meta;
    return data;
  }
}

class Profile {
  int? id;
  String? userType;
  String? name;
  String? displayName;
  String? email;
  String? phoneNumber;
  Details? details;
  UserCl? userCl;
  StoreData? store;

  Profile(
      {this.id,
      this.userType,
      this.name,
      this.displayName,
      this.email,
      this.phoneNumber,
      this.details,
      this.userCl,
      this.store});

  Profile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userType = json['user_type'];
    name = json['name'];
    displayName = json['display_name'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    details =
        json['details'] != null ? Details.fromJson(json['details']) : null;
    userCl = json['user_cl'] != null ? UserCl.fromJson(json['user_cl']) : null;
    store = json['store'] != null ? StoreData.fromJson(json['store']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['user_type'] = userType;
    data['name'] = name;
    data['display_name'] = displayName;
    data['email'] = email;
    data['phone_number'] = phoneNumber;
    if (details != null) {
      data['details'] = details!.toJson();
    }
    if (userCl != null) {
      data['user_cl'] = userCl!.toJson();
    }
    if (store != null) {
      data['store'] = store!.toJson();
    }
    return data;
  }
}

class Details {
  Province? province;
  City? city;
  String? postalCode;
  String? address;
  String? bankAccountNumber;
  String? bankAccountName;
  String? bank;
  String? npwpNumber;
  String? npwpAddress;
  String? ktpImageUrl;
  String? profilePicture;
  String? birthdate;
  String? placeOfBirth;
  String? registerVerificationMethod;
  String? registerVerificationCode;
  dynamic country;
  String? identityNumber;

  Details(
      {this.province,
      this.city,
      this.postalCode,
      this.address,
      this.bankAccountNumber,
      this.bankAccountName,
      this.bank,
      this.npwpNumber,
      this.npwpAddress,
      this.ktpImageUrl,
      this.profilePicture,
      this.birthdate,
      this.placeOfBirth,
      this.registerVerificationMethod,
      this.registerVerificationCode,
      this.country,
      this.identityNumber});

  Details.fromJson(Map<String, dynamic> json) {
    province =
        json['province'] != null ? Province.fromJson(json['province']) : null;
    city = json['city'] != null ? City.fromJson(json['city']) : null;
    postalCode =
        json['postal_code'] is int ? postalCode.toString() : postalCode;
    address = json['address'];
    bankAccountNumber = json['bank_account_number'];
    bankAccountName = json['bank_account_name'];
    bank = json['bank'];
    npwpNumber = json['npwp_number'];
    npwpAddress = json['npwp_address'];
    ktpImageUrl = json['ktp_image_url'];
    profilePicture = json['profile_picture'];
    birthdate = json['birthdate'];
    placeOfBirth = json['place_of_birth'];
    registerVerificationMethod = json['register_verification_method'];
    registerVerificationCode = json['register_verification_code'];
    country = json['country'];
    identityNumber = json['identity_number'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (province != null) {
      data['province'] = province!.toJson();
    }
    if (city != null) {
      data['city'] = city!.toJson();
    }
    data['postal_code'] =
        postalCode is int ? postalCode.toString() : postalCode;
    data['address'] = address;
    data['bank_account_number'] = bankAccountNumber;
    data['bank_account_name'] = bankAccountName;
    data['bank'] = bank;
    data['npwp_number'] = npwpNumber;
    data['npwp_address'] = npwpAddress;
    data['ktp_image_url'] = ktpImageUrl;
    data['profile_picture'] = profilePicture;
    data['birthdate'] = birthdate;
    data['place_of_birth'] = placeOfBirth;
    data['register_verification_method'] = registerVerificationMethod;
    data['register_verification_code'] = registerVerificationCode;
    data['country'] = country;
    data['identity_number'] = identityNumber;
    return data;
  }
}
