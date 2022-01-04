class ErrorMessage {
  int? httpCode;
  List<Errors>? errors;
  Meta? meta;

  ErrorMessage({this.errors, this.meta, this.httpCode});

  ErrorMessage.fromJson(Map<String, dynamic> json) {
    if (json['errors'] != null) {
      errors = <Errors>[];
      json['errors'].forEach((v) {
        errors!.add(Errors.fromJson(v));
      });
    }
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (errors != null) {
      data['errors'] = errors!.map((v) => v.toJson()).toList();
    }
    if (meta != null) {
      data['meta'] = meta!.toJson();
    }
    data['httpCode'] = httpCode;
    return data;
  }
}

class Errors {
  String? error;

  Errors({this.error});

  Errors.fromJson(Map<String, dynamic> json) {
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['error'] = error;
    return data;
  }
}

class Meta {
  String? message;

  Meta({this.message});

  Meta.fromJson(Map<String, dynamic> json) {
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['message'] = message;
    return data;
  }
}
