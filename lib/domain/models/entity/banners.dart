class Banners {
  int? id;
  String? name;
  String? imageUrl;
  String? urlWebview;
  String? deeplinkPath;

  Banners(
      {this.id, this.name, this.imageUrl, this.urlWebview, this.deeplinkPath});

  Banners.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    imageUrl = json['image_url'];
    urlWebview = json['url_webview'];
    deeplinkPath = json['deeplink_path'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image_url'] = imageUrl;
    data['url_webview'] = urlWebview;
    data['deeplink_path'] = deeplinkPath;
    return data;
  }
}
