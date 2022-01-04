class ResponseVersion {
  AppVersionInfo? data;

  ResponseVersion({this.data});

  ResponseVersion.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? AppVersionInfo.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class AppVersionInfo {
  String? linkAndroid;
  String? linkIos;
  int? statusCode;

  AppVersionInfo({this.linkAndroid, this.linkIos, this.statusCode});

  AppVersionInfo.fromJson(Map<String, dynamic> json) {
    linkAndroid = json['link_android'];
    linkIos = json['link_ios'];
    statusCode = json['status_code'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['link_android'] = linkAndroid;
    data['link_ios'] = linkIos;
    data['status_code'] = statusCode;
    return data;
  }
}
