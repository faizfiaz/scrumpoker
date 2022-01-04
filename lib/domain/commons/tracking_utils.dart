// ignore_for_file: constant_identifier_names

import 'package:SuperNinja/domain/commons/formatter_date.dart';

// ignore: avoid_classes_with_only_static_members
class TrackingUtils {
  static const String ONBOARDING_1 = "BC1";
  static const String ONBOARDING_2 = "BC2";
  static const String ONBOARDING_3 = "BC3";
  static const String ONBOARDING_4 = "BC4";
  static const String SIGNUP_LANDED = "Signup_Landed";
  static const String SIGNUP_SUBMIT_GOOGLE = "Signup_Submit_Google";
  static const String SIGNUP_SUBMIT_FACEBOOK = "Signup_Submit_Facebook";
  static const String SIGNUP_SUBMIT_OTP = "Signup_Submit_OTP";
  static const String SIGNUP_SUBMIT_EMAIL = "Signup_Submit_Email";
  static const String HOMEPAGE = "Homepage";
  static const String CATEGORY_NAME_CLICKED = "Category_Name_clicked";
  static const String CATEGORY_ALL_CLICKED = "Category_All_clicked";
  static const String NOT_STARTED = "Not Started";
  static const String CATEGORYNAME_LISTING = "Categoryname_listing";
  static const String CATEGORYNAME_PLUCODE = "Categoryname_PLUcode";
  static const String ADD_TO_CART = "Add To Cart";
  static const String CART_VALUE_NUMBER_OF_ITEMS_IN_CART =
      "Cart_Value_Number_of_Items_in_Cart";
  static const String CHECKOUT = "Checkout";
  static const String CARTVALUE = "CartValue";
  static const String PAYMENT_TYPE_PICKED = "Payment Type Picked";
  static const String SUCCESS = "Success";
  static const String FAILED = "Failed";
  static const String HOMEPAGE_PROMO_PLU = "Homepage_promo_plu";
  static const String HOMEPAGE_RECOMMENDED_PLU = "Homepage_recommended_plu";
  static const String SIGNIN_OTP = "SignIn_OTP";
  static const String SIGNIN_FACEBOOK = "SignIn_Facebook";
  static const String SIGNIN_GOOGLE = "SignIn_Google";
  static const String LOGOUT = "Logout";

  static Map<String, String> getEmptyPayload() {
    final payloadEmpty = {"date": FormatterDate.getDateTimeNow()};
    return payloadEmpty;
  }
}
