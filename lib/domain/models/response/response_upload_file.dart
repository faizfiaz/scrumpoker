class ResponseUploadFile {
  ImageData? data;

  ResponseUploadFile({this.data});

  ResponseUploadFile.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? ImageData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class ImageData {
  String? url;

  ImageData({this.url});

  ImageData.fromJson(Map<String, dynamic> json) {
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['url'] = url;
    return data;
  }
}
