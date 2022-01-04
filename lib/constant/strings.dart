// ignore_for_file: constant_identifier_names

import 'package:SuperNinja/ui/widgets/multilanguage.dart';

class Strings {
  Strings._();

  //General
  static const String appName = "Super Ninja";
  static String currentLanguage = Languages.en;

  static const String dummyImagePowerTools =
      "https://img3.ralali.id/mediaflex/280/assets/img/Libraries/318279_Bor-listrik-tangan-electric-drill-10mm-murah-ekonomis-MPT_28KxyOSvJigIawRw_1574839235.JPG";
  static const String dummyImageHandTools =
      "https://s3.bukalapak.com/img/352201109/w-1000/Kunci_Sok_Tekiro_24_pcs_6PT_Box_Plastik_Berkualitas.jpg";
  static const String dummyImageSportingGoods =
      "https://ecs7.tokopedia.net/img/cache/700/product-1/2019/3/11/723876/723876_2e261562-f417-4716-aa5b-4a249f96b22c_1000_1000";
  static const String dummyDescriptionProduct =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed id mauris mi. Suspendisse potenti. Aenean sit amet rutrum quam. Suspendisse cursus elementum ante, eget tristique libero feugiat non. Aenean vitae libero erat. In venenatis tempor interdum. Duis sagittis nisl vel laoreet egestas. Donec pretium libero nec facilisis posuere. Curabitur eget viverra libero. Donec id felis.";

  static const String error_minimum_six = "Minimum 6 Character";
  static const String error_minimum_four = "Minimum 4 Character";
  static const String error_minimum_twenty_four = "Minimum 24 Character";

  //Login
  static const String login_hint_email = "Email@gmail.com";
  static const String login_label_email = "Alamat email anda";
  static const String login_hadits_title =
      "“Maka kerjakanlah shalat karena Tuhanmu, dan berkurbanlah (sebagai ibadah dan mendekatkan diri kepada Allah).“\n (Al Kautsar Ayat 2)";
  static const String login_label_password = "Masukkan password anda";
  static const String login_et_user_password = "Enter password";
  static const String login_btn_forgot_password = "Lupa password?";
  static const String login_btn_sign_in = "Login";
  static const String login_btn_facebook = "Facebook";
  static const String login_btn_google = "Google";
  static const String login_btn_sign_up = "Sign Up";

  //REGISTER
  static const String register_title =
      "”Bacalah Al-Qur’an. Sebab, ia akan datang memberikan syafaat pada hari Kiamat kepada pemilik (pembaca, pengamal)-nya,” (HR. Ahmad).";
  static const String register_sign_label = "Daftar";
  static const String register_label_phone = "Phone";
  static const String register_label_name = "Name";
  static const String register_label_email = "E-mail";
  static const String register_hint_email = "Contoh: kamal@mail.com";
  static const String register_hint_first_name = "Contoh: Kamal";
  static const String register_hint_last_name = "Contoh: Abdul";
  static const String register_hint_password = "**********";
  static const String register_error_email = "E-mail address is not valid";
  static const String register_error_repassword = "Password not match";
  static const String register_error_phone_number = "Phone number is not valid";

  //Create Group
  static const String create_group_label_name_hint = "Name";
  static const String create_group_label_description_hint = "Description";
  static const String create_group_label_user_limit_hint = "Max User";
  static const String error_minimum_user_limit = "Minimum 3 max user";
}
