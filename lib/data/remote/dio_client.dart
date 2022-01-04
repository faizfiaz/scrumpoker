import 'dart:developer';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:scrumpoker/data/remote/endpoints/endpoints.dart';
import 'package:scrumpoker/data/sharedpreference/user_preferences.dart';
import 'package:scrumpoker/domain/commons/nav_key.dart';
import 'package:scrumpoker/domain/commons/other_utils.dart';
import 'package:scrumpoker/ui/widgets/multilanguage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioClient {
  final Dio _dio;
  static const String _hk = "2uzew%T3p8wF^E!x1BTMs6ZIbRLoDqlT";

  DioClient(this._dio);

  // Get:-----------------------------------------------------------------------
  Future<dynamic> get(String uri,
      {Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onReceiveProgress,
      String token = ""}) async {
    log("$uri $queryParameters");
    final dioOptions = await generateDioOption(options, token: token);

    try {
      (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
        client.badCertificateCallback = (cert, host, port) {
          if (cert.pem == NavKey.pemKey) {
            return true;
          }
          return false;
        };
        return client;
      };
      final response = await _dio.get(
        uri,
        queryParameters: queryParameters,
        options: dioOptions,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      OtherUtils.printWrapped(response.data.toString());
      return response.data;
    } on DioError catch (e) {
      OtherUtils.printWrapped(
          e.response?.data.toString() ?? e.response.toString());
      if (e.response.toString().toLowerCase().contains("expired")) {
        // ScreenUtils.expiredToken();
      }
      rethrow;
    }
  }

  Future<dynamic> getInner(
    String uri, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    log("$uri $queryParameters");
    final dioOptions = await generateDioOption(options, isInnerService: true);

    try {
      (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
        client.badCertificateCallback = (cert, host, port) {
          if (cert.pem == NavKey.pemKey) {
            return true;
          }
          return false;
        };
        return client;
      };
      final response = await _dio.get(
        uri,
        queryParameters: queryParameters,
        options: dioOptions,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      OtherUtils.printWrapped(response.data.toString());
      return response.data;
    } on DioError catch (e) {
      OtherUtils.printWrapped(
          e.response?.data.toString() ?? e.response.toString());
      if (e.response.toString().toLowerCase().contains("expired")) {
        // ScreenUtils.expiredToken();
      }
      rethrow;
    }
  }

  // Get:-----------------------------------------------------------------------
  Future<dynamic> delete(String uri,
      {Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken}) async {
    log("$uri $queryParameters");
    final dioOptions = await generateDioOption(options);

    try {
      (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
        client.badCertificateCallback = (cert, host, port) {
          if (cert.pem == NavKey.pemKey) {
            return true;
          }
          return false;
        };
        return client;
      };
      final response = await _dio.delete(
        uri,
        queryParameters: queryParameters,
        options: dioOptions,
        cancelToken: cancelToken,
      );
      print(response.data);
      return response.data;
    } on DioError catch (e) {
      OtherUtils.printWrapped(
          e.response?.data.toString() ?? e.response.toString());
      if (e.response.toString().toLowerCase().contains("expired")) {
        // ScreenUtils.expiredToken();
      }
      rethrow;
    }
  }

  // Post:----------------------------------------------------------------------
  Future<dynamic> post(
    String uri, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    log("$uri $queryParameters $data");
    final dioOptions = await generateDioOption(options);

    try {
      (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
        client.badCertificateCallback = (cert, host, port) {
          if (cert.pem == NavKey.pemKey) {
            return true;
          }
          return false;
        };
        return client;
      };
      final response = await _dio.post(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: dioOptions,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      print(response);
      return response.data;
    } on DioError catch (e) {
      OtherUtils.printWrapped(
          e.response?.data.toString() ?? e.response.toString());
      if (e.response.toString().toLowerCase().contains("expired")) {
        // ScreenUtils.expiredToken();
      }
      rethrow;
    }
  }

  Future<dynamic> put(
    String uri, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    log("$uri $queryParameters $data");
    final dioOptions = await generateDioOption(options);
    try {
      (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
        client.badCertificateCallback = (cert, host, port) {
          if (cert.pem == NavKey.pemKey) {
            return true;
          }
          return false;
        };
        return client;
      };
      final response = await _dio.put(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: dioOptions,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      print(response);
      print(response.statusCode);
      return response.data;
    } on DioError catch (e) {
      OtherUtils.printWrapped(
          e.response?.data.toString() ?? e.response.toString());
      if (e.response.toString().toLowerCase().contains("expired")) {
        // ScreenUtils.expiredToken();
      }
      rethrow;
    }
  }

  String decryptor() {
    final plainText = Endpoints.clientID!;
    final key = Key.fromUtf8(_hk);
    final iv = IV.fromLength(16);

    final _e = Encrypter(AES(key));
    final _edr = _e.decrypt16(plainText, iv: iv);
    return _edr;
  }

  Future<Options> generateDioOption(Options? options,
      {String token = "", bool isInnerService = false}) async {
    final prefs = await SharedPreferences.getInstance();
    final currentLanguage = prefs.getString(langKey);

    final dioOptions = options ?? Options();
    dioOptions.headers = dioOptions.headers ?? {};
    dioOptions.headers!["content-type"] = "application/json";
    dioOptions.headers!["Access-Control-Allow-Origin"] = "*";
    dioOptions.headers!["Accept-Language"] =
        currentLanguage == Languages.en ? "en" : "id";
    dioOptions.headers!["Client-Id"] = decryptor();
    dioOptions.headers!["Authorization"] = await UserPreferences().getToken();
    if (isInnerService) {
      dioOptions.headers!["Authorization"] = dotenv.env["INNER_TOKEN"];
    }

    if (token.isNotEmpty) {
      dioOptions.headers!["Authorization"] = "Basic $token";
    }
    return dioOptions;
  }
}
