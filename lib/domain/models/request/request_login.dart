class RequestLogin {
  String? identity;
  String? password;

  RequestLogin({this.identity, this.password});

  RequestLogin.fromJson(Map<String, dynamic> json) {
    identity = json['identity'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['identity'] = identity;
    data['password'] = password;
    return data;
  }
}
