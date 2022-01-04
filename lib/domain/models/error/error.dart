class ErrorHandler {
  int? httpCode;
  String? error;
  String? message;

  ErrorHandler(this.httpCode, this.error, this.message);

  ErrorHandler.fromJson(Map<String, dynamic> json) {
    httpCode = json['httpCode'];
    error = json['error'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['httpCode'] = httpCode;
    data['error'] = error;
    data['message'] = message;
    return data;
  }
}
