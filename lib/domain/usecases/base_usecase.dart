// ignore_for_file: parameter_assignments

import 'dart:convert';

import 'package:SuperNinja/domain/models/error/error_dynamic.dart';
import 'package:SuperNinja/domain/models/error/error_message.dart';
import 'package:SuperNinja/domain/repositories/base_repository.dart';
import 'package:SuperNinja/ui/widgets/multilanguage.dart';

abstract class BaseUsecase<R extends BaseRepository?> {
  R repository;

  ErrorMessage? error;
  ErrorHandlerDynamic? errorHandlerDynamic;

  BaseUsecase(this.repository);

  Future<ErrorMessage> mappingError(ErrorMessage? error, dynamic e) async {
    print(e);
    print(e.response.toString());
    try {
      error = ErrorMessage.fromJson(jsonDecode(e.response.toString()));
      error.httpCode = e.response.statusCode;
      return Future.value(error);
    } catch (e) {
      final errorDefault = [Errors(error: txt("something_wrong"))];
      error = ErrorMessage(errors: errorDefault, httpCode: 0);
      return Future.value(error);
    }
  }

  Future<ErrorHandlerDynamic> mappingErrorDynamic(
      ErrorHandlerDynamic error, dynamic e) async {
    error = ErrorHandlerDynamic(0, "");
    try {
      final decoded = jsonDecode(e.response.toString());
      error.geMapping(decoded['errors']);
      error.httpCode = e.response.statusCode;
      error.message = decoded['message'];
      return Future.value(error);
    } catch (ignored) {
      error = ErrorHandlerDynamic(e.response.statusCode, e.response.toString());
      return Future.value(error);
    }
  }

  void disposeVariable() {
    error = null;
    errorHandlerDynamic = null;
  }
}
