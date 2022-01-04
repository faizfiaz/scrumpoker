import 'package:flutter_dotenv/flutter_dotenv.dart';

class Endpoints {
  Endpoints();

  String? baseUrl = dotenv.env['CURRENT_ENV'] == "0"
      ? dotenv.env['BASE_URL_DEV']
      : dotenv.env['BASE_URL'];
  static String? clientID = dotenv.env['CLIENT_ID'];
  static String? innerToken = dotenv.env['INNER_TOKEN'];
  static String? xenditToken = dotenv.env['XENDIT_TOKEN'];

  static const int receiveTimeout = 30000;
  static const int connectionTimeout = 30000;

  static const String googleKey = "google";
  static const String facebookKey = "facebook";
  static const String manualKey = "manual";
  static const String facebookGraph =
      "https://graph.facebook.com/v2.12/me?fields=name,picture.width(800).height(800),first_name,last_name,email&access_token=";
}
