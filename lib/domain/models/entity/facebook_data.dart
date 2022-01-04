class FacebookData {
  String? name;
  Picture? picture;
  String? firstName;
  String? lastName;
  String? email;
  String? id;

  FacebookData(
      {this.name,
      this.picture,
      this.firstName,
      this.lastName,
      this.email,
      this.id});

  FacebookData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    picture =
        json['picture'] != null ? Picture.fromJson(json['picture']) : null;
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    if (picture != null) {
      data['picture'] = picture!.toJson();
    }
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['id'] = id;
    return data;
  }
}

class Picture {
  Image? data;

  Picture({this.data});

  Picture.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Image.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Image {
  int? height;
  bool? isSilhouette;
  String? url;
  int? width;

  Image({this.height, this.isSilhouette, this.url, this.width});

  Image.fromJson(Map<String, dynamic> json) {
    height = json['height'];
    isSilhouette = json['is_silhouette'];
    url = json['url'];
    width = json['width'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['height'] = height;
    data['is_silhouette'] = isSilhouette;
    data['url'] = url;
    data['width'] = width;
    return data;
  }
}
