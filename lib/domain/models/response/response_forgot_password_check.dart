class ResponseForgotPasswordCheck {
  ForgotPasswordCheck? data;
  dynamic meta;

  ResponseForgotPasswordCheck({this.data, this.meta});

  ResponseForgotPasswordCheck.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null
        ? ForgotPasswordCheck.fromJson(json['data'])
        : null;
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

class ForgotPasswordCheck {
  int? codeId;

  ForgotPasswordCheck({this.codeId});

  ForgotPasswordCheck.fromJson(Map<String, dynamic> json) {
    codeId = json['code_id'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['code_id'] = codeId;
    return data;
  }
}
